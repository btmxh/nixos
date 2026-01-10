{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.imv;
in
{
  options.mine.apps.viewer.imv = {
    enable = mkEnableOption "Enable imv image viewer";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.imv.enable = true;
    };
  };
}
