{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.git;
in
{
  options.mine.apps.dev.git = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}

