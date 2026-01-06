{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.wm.waybar;
in
{
  options.mine.apps.wm.waybar = {
    enable = mkEnableOption "Enable Hyprland WM + related utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];
    home-manager.users.${user.name} = {
      programs.waybar.enable = true;
      xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
      xdg.configFile."waybar/style.css".source = ./style.css;
    };
  };

}
