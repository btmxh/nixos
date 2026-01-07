{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.notification.mako;
in
{
  options.mine.apps.notification.mako = {
    enable = mkEnableOption "Enable notification daemon (mako) and utilities (libnotify)";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.mako.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libnotify
    ];
  };
}
