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
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
