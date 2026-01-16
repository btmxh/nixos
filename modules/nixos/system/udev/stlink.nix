{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.udev.stlink;
in
{
  options.mine.system.udev.stlink = {
    enable = mkEnableOption "Enable ST-Link udev rules";
  };

  config = mkIf cfg.enable {
    services.udev.extraRules = ''
      # STMicroelectronics ST-LINK/V2
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0660", GROUP="plugdev"

      # STMicroelectronics ST-LINK/V2-1
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0660", GROUP="plugdev"

      # STLINK-V3
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374d", MODE="0660", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3752", MODE="0660", GROUP="plugdev"
    '';

    users.users.${user.name}.extraGroups = [ "plugdev" ];
  };
}
