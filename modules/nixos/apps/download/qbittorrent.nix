{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.download.qbittorrent;
in
{
  options.mine.apps.download.qbittorrent = {
    enable = mkEnableOption "Enable qBittorrent";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ qbittorrent ];
    };
  };
}
