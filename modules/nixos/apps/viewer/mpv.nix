{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.mpv;
in
{
  options.mine.apps.viewer.mpv = {
    enable = mkEnableOption "Enable mpv media player";
    default = mkEnableOption "Make mpv the default media player";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.mpv.enable = true;
    };
  };
}
