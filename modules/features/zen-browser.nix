{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos.zen-browser = {
    home-manager.sharedModules = [self.modules.homeManager.zen-browser];
  };
  flake.modules.homeManager.zen-browser = {...}: let
    mkLockedAttrs = builtins.mapAttrs (_: value: {
      Value = value;
      Status = "locked";
    });

    mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

    mkExtensionEntry = id: {
      install_url = mkPluginUrl id;
      installation_mode = "force_installed";
    };

    mkExtensionSettings = builtins.mapAttrs (_: id: mkExtensionEntry id);
  in {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];
    programs.zen-browser = {
      enable = true;
      profiles.default = {
        search = {
          force = true;
          default = "StartPage";
          privateDefault = "StartPage";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@pkgs"];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@nop"];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              definedAliases = ["@hmop"];
            };
            "Google Maps" = {
              urls = [
                {
                  template = "http://maps.google.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@maps"];
            };
            "StartPage" = {
              urls = [
                {
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@startpage" "@sp"];
            };
            "ddg" = {
              urls = [
                {
                  template = "https://duckduckgo.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@duck" "@ddg"];
            };
          };
        };
      };
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        SanitizeOnShutdown = {
          FormData = true;
          Cache = true;
        };
        ExtensionSettings = mkExtensionSettings {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "remove.youtube.tracking@moreo.app" = "remove-youtube-tracking";
          "{4590d8b8-3569-46e3-a571-cabfbaeab2c1}" = "no-youtube-shorts";
          "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "@searchengineadremover" = "searchengineadremover";
          "duplicate-tab@firefox.stefansundin.com" = "duplicate-tab-shortcut";
        };
        Preferences = mkLockedAttrs {
          "browser.tabs.warnOnClose" = false;
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;
        };
      };
    };
  };
}
