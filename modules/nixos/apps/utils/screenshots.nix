{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.utils.screenshots;
in
{
  options.mine.apps.utils.screenshots = {
    enable = mkEnableOption "Enable screenshot utilities (grimblast, satty)";
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
