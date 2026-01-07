{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.utils.media;
in
{
  options.mine.apps.utils.media = {
    enable = mkEnableOption "Enable media control utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      playerctl
    ];
  };
}
