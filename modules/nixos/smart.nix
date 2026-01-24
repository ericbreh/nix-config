{
  lib,
  config,
  pkgs,
  ...
}: {
  options.smart.enable = lib.mkEnableOption "Enable SMART";

  config = lib.mkIf config.smart.enable {
    environment.systemPackages = [pkgs.smartmontools];

    systemd.services."smart-check" = {
      description = "Check SMART health of drives";
      path = [pkgs.smartmontools pkgs.coreutils pkgs.curl pkgs.util-linux pkgs.gnugrep];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        set -euo pipefail

        HC_URL=$(cat /etc/healthchecks-smart)

        # Ping start
        curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/start"

        FAILED=0

        # Find devices by UUID and check SMART health
        for UUID in "daf86907-e811-4bd1-9baf-fa44f2a83203" "ae6a911d-ccbf-48fc-a54f-2ba26a036269"; do
          DEVICE=$(blkid -U "$UUID" 2>/dev/null || true)

          if [ -z "$DEVICE" ]; then
            echo "WARNING: Could not find device for UUID $UUID"
            FAILED=1
            continue
          fi

          # Get the base device (strip partition number if present)
          BASE_DEVICE=$(lsblk -no PKNAME "$DEVICE" | head -1)
          if [ -n "$BASE_DEVICE" ]; then
            DEVICE="/dev/$BASE_DEVICE"
          fi

          echo "Checking SMART health for $DEVICE (UUID: $UUID)"

          # Use -d scsi for USB-connected drives (Seagate Backup Plus)
          if ! smartctl -d scsi -H "$DEVICE" | grep -q "PASSED\|OK"; then
            echo "SMART check FAILED for $DEVICE"
            FAILED=1
          else
            echo "SMART check passed for $DEVICE"
          fi
        done

        if [ "$FAILED" -eq 1 ]; then
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL/fail"
          exit 1
        else
          curl -fsS -m 10 --retry 5 -o /dev/null "$HC_URL"
        fi
      '';
    };

    systemd.timers."smart-check" = {
      description = "Daily SMART health check";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:00";
        Persistent = true;
      };
    };
  };
}
