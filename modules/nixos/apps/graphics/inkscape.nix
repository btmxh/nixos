{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.graphics.inkscape;
in
{
  options.mine.apps.graphics.inkscape = {
    enable = mkEnableOption "Enable Inkscape vector graphics editor";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ inkscape ];
    };
  };
}
