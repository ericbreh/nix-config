let
  ericbreh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR ericchuang94@gmail.com";
  silver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdX2ZGu+vzz7td6aKvsb2rrb14S3cBdc32ds3dPfrWm";
  rhea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5rO535d1JMLcRcgZClCwA4sMFeH3LlPPiiD+O9qinr";
in {
  "webdav.age".publicKeys = [ericbreh silver rhea];
  "restic.age".publicKeys = [ericbreh silver rhea];
  "healthchecks-restic.age".publicKeys = [ericbreh silver rhea];
  "healthchecks-restic-check.age".publicKeys = [ericbreh silver rhea];
  "healthchecks-smart.age".publicKeys = [ericbreh silver rhea];
  "duckdns.age".publicKeys = [ericbreh silver rhea];
}
