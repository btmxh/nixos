{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.utils.notifications;
in
{
  options.mine.apps.utils.notifications = {
    enable = mkEnableOption "Enable notification daemon (mako)";
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
