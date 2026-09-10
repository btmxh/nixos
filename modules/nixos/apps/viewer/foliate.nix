{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.foliate;
in
{
  options.mine.apps.viewer.foliate = {
    enable = mkEnableOption "Enable Foliate e-book reader";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ foliate ];
    };
  };
}
