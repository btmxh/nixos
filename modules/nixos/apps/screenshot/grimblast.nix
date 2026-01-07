{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.screenshot.grimblast;
in
{
  options.mine.apps.screenshot.grimblast = {
    enable = mkEnableOption "Enable screenshot utilities (grimblast and satty editor)";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.satty.enable = true;

      home.sessionVariables = {
        GRIMBLAST_EDITOR = "satty --filename";
      };
    };

    environment.systemPackages = with pkgs; [
      grimblast
    ];
  };
}
