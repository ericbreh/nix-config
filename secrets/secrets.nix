let
  ericbreh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com";
  silver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdX2ZGu+vzz7td6aKvsb2rrb14S3cBdc32ds3dPfrWm";
in {
  "webdav.age".publicKeys = [ericbreh silver];
  "restic.age".publicKeys = [ericbreh silver];
  "healthchecks-restic.age".publicKeys = [ericbreh silver];
  "healthchecks-restic-check.age".publicKeys = [ericbreh silver];
  "healthchecks-smart.age".publicKeys = [ericbreh silver];
}
