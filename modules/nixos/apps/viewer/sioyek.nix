{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.sioyek;
in
{
  options.mine.apps.viewer.sioyek = {
    enable = mkEnableOption "Enable sioyek PDF viewer";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.sioyek.enable = true;
    };
  };
}
