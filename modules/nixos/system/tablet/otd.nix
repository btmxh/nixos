{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.tablet.otd;
in
{
  options.mine.system.tablet.otd = {
    enable = mkEnableOption "Enable OpenTabletDriver";
  };

  config = mkIf cfg.enable {
    hardware = {
      opentabletdriver.enable = true;
      uinput.enable = true;
    };

    boot.kernelModules = [ "uinput" ];
  };
}
