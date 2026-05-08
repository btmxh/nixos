{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.cli.comma;
in
{
  options.mine.apps.cli.comma = {
    enable = mkEnableOption "Enable comma";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        comma
      ];
    };
  };
}
