{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.browser.google-chrome;
in
{
  options.mine.apps.browser.google-chrome = {
    enable = mkEnableOption "Enable Google Chrome browser";
    default = mkEnableOption "Make Google Chrome the default browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [ pkgs.google-chrome ];
    };
  };
}
