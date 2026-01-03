{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.remap.interception-tools;
in
{
  options.mine.services.remap.interception-tools = {
    enable = mkEnableOption "Enable interception-tools + default remaps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      interception-tools
      interception-tools-plugins.caps2esc
    ];
    services.interception-tools = {
  	enable = true;
	plugins = [ pkgs.interception-tools-plugins.caps2esc ];
	udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
    };
  };
}

