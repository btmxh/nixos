{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.apps.browser.zen;

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "general.autoScroll" = true;
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
  ];
in
{
  options.mine.apps.browser.zen = {
    enable = mkEnableOption "Enable Zen Browser";
    default = mkEnableOption "Make Zen Browser the default browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.wrapFirefox
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
        {
          extraPrefs = lib.concatLines (
            lib.mapAttrsToList (
              name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
            ) prefs
          );

          extraPolicies = {
            DisableTelemetry = true;
            ExtensionSettings = builtins.listToAttrs extensions;

            SearchEngines = {
              Default = "ddg";
            };
          };
        }
      )
    ];
  };
}
