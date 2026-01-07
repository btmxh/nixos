{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.launcher.rofi;
in
{
  options.mine.apps.launcher.rofi = {
    enable = mkEnableOption "Enable Rofi launcher";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.rofi = {
        enable = true;
        theme = "Arc-Dark";
      };
    };
  };
}
