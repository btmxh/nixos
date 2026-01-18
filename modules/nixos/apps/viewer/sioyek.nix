{
  lib,
  config,
  pkgs,
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
    default = mkEnableOption "Make sioyek the default PDF viewer";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.sioyek = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "sioyek";
          paths = [ pkgs.sioyek ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/sioyek \
              --set QT_QPA_PLATFORM xcb
          '';
        };
      };
    };
  };
}
