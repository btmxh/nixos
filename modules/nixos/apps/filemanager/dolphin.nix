{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.filemanager.dolphin;
in
{
  options.mine.apps.filemanager.dolphin = {
    enable = mkEnableOption "Enable Dolphin file browser";
    udisk2 = mkEnableOption "Enable udisk2 daemon";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
      kdePackages.qtsvg
    ];
    services.udisks2.enable = mkIf cfg.udisk2 true;
  };
}
