{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    types
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.notification.mako;
in
{
  options.mine.apps.notification.mako = {
    enable = mkEnableOption "Enable notification daemon (mako) and utilities (libnotify)";
    sound = {
      enable = mkEnableOption "Play a sound when a notification is received";
      path = mkOption {
        type = types.str;
        description = "Path to the notification sound file";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.mako = {
        enable = true;
        settings = optionalAttrs cfg.sound.enable {
          on-notify = "exec ${pkgs.mpv}/bin/mpv --no-video --really-quiet ${cfg.sound.path}";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      libnotify
      mpv
      sox
    ];
  };
}
