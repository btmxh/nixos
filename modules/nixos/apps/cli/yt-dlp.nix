{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.cli.yt-dlp;
in
{
  options.mine.apps.cli.yt-dlp = {
    enable = mkEnableOption "Enable yt-dlp";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yt-dlp
    ];
  };
}
