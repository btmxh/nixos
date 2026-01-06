{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.audio.pipewire;
in
{
  options.mine.services.audio.pipewire = {
    enable = mkEnableOption "Enable Pipewire for audio";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pwvucontrol
    ];
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  };
}
