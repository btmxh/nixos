{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.browser.chromium;
in
{
  options.mine.apps.browser.chromium = {
    enable = mkEnableOption "Enable Chromium browser";
    default = mkEnableOption "Make Chromium the default browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.chromium = {
        enable = true;
      };
    };
  };
}
