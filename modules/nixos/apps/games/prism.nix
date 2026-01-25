{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.games.prism;
in
{
  options.mine.apps.games.prism = {
    enable = mkEnableOption "Enable Prism launcher (Minecraft)";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        prismlauncher
      ];
    };
  };
}
