{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.screenshot.obs;
in
{
  options.mine.apps.screenshot.obs = {
    enable = mkEnableOption "Enable OBS";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.obs-studio = {
        enable = true;

        package = pkgs.obs-studio.override {
          cudaSupport = true;
        };

        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vaapi # optional AMD hardware acceleration
          obs-gstreamer
          obs-vkcapture
        ];
      };
    };
  };
}
