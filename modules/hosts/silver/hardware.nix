{...}: {
  flake.modules.nixos.silver = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/cbead601-96f3-4c2a-9052-de106fb29197";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/5514-44AA";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
      "/srv/storage" = {
        device = "/dev/disk/by-uuid/daf86907-e811-4bd1-9baf-fa44f2a83203";
        fsType = "ext4";
        options = ["noatime"];
      };
      "/srv/backup" = {
        device = "/dev/disk/by-uuid/ae6a911d-ccbf-48fc-a54f-2ba26a036269";
        fsType = "ext4";
        options = ["nofail" "noatime"];
      };
    };

    swapDevices = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    services.logind = {
      settings = {
        Login = {
          AllowSuspend = false;
          AllowHibernation = false;
          AllowHybridSleep = false;
          AllowSuspendThenHibernate = false;
          HandleLidSwitch = "ignore";
        };
      };
    };

    services.tlp = {
      enable = true;
      settings = {
        STOP_CHARGE_THRESH_BAT0 = 55;
        START_CHARGE_THRESH_BAT0 = 45;
      };
    };
  };
}
