{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.cli.media;
in
{
  options.mine.apps.cli.media = {
    enable = mkEnableOption "Enable media control utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      playerctl
    ];
  };
}
