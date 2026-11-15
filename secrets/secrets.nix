let
  ericbreh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com";
  silver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdX2ZGu+vzz7td6aKvsb2rrb14S3cBdc32ds3dPfrWm";
  rhea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5rO535d1JMLcRcgZClCwA4sMFeH3LlPPiiD+O9qinr";
  all = [ericbreh silver rhea];
in {
  "webdav.age".publicKeys = all;
  "restic.age".publicKeys = all;
  "healthchecks-restic-local-rhea.age".publicKeys = all;
  "healthchecks-restic-offsite-rhea.age".publicKeys = all;
  "healthchecks-restic-check-rhea.age".publicKeys = all;
  "healthchecks-restic-check-silver.age".publicKeys = all;
  "healthchecks-smartd-rhea.age".publicKeys = all;
  "healthchecks-smartd-silver.age".publicKeys = all;
  "restic-offsite-ssh.age".publicKeys = all;
  "duckdns.age".publicKeys = all;
}
