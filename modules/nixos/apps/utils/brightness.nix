{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.utils.brightness;
in
{
  options.mine.apps.utils.brightness = {
    enable = mkEnableOption "Enable brightness control utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
  };
}
