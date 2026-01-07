{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.graphics.nvidia;
in
{
  options.mine.system.graphics.nvidia = {
    enable = mkEnableOption "Enable NVIDIA graphics drivers";
  };

  config = mkIf cfg.enable {
    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        open = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
