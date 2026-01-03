{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.wm.hyprland;
in
{
  options.mine.apps.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland WM + related utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hyprland
      hyprpaper
      waybar
      rofi
      kitty
    ];
    
  programs.hyprland = {
  	enable = true;
	xwayland.enable = true;
  };

  environment.sessionVariables = {
  	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
  };

  hardware = {
  	graphics.enable = true;
	nvidia.modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  };
}

