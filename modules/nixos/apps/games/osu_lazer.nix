{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.games.osu_lazer;
in
{
  options.mine.apps.games.osu_lazer = {
    enable = mkEnableOption "Enable osu!lazer";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        osu-lazer-bin
      ];
    };
  };
}
