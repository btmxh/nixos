{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.theme.dark;
in
{
  options.mine.system.theme.dark = {
    enable = mkEnableOption "Enable dark theme";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };

      systemd.user.sessionVariables = config.home-manager.users.${user.name}.home.sessionVariables;
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
