{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.spotify;
in
{
  options.mine.apps.viewer.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.spotify.enable = true;
    };
  };
}
