{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.viewer.mpv;
in
{
  options.mine.apps.viewer.mpv = {
    enable = mkEnableOption "Enable mpv media player";
    default = mkEnableOption "Make mpv the default media player";
    bluray = {
      enableAACS = mkEnableOption "Enable AACS decryption for Blu-ray playback (requires libaacs, libbluray)";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.mpv = {
        enable = true;
        package = mkIf cfg.bluray.enableAACS (
          pkgs.mpv.override {
            extraMakeWrapperArgs = [
              "--prefix"
              "LD_LIBRARY_PATH"
              ":"
              "${pkgs.libaacs}/lib"
            ];
          }
        );
        config = mkIf cfg.bluray.enableAACS {
          bluray = "yes";
        };
      };
    };
  };
}
