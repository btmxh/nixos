{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.browser.chromium;
in
{
  options.mine.apps.browser.chromium = {
    enable = mkEnableOption "Enable Chromium browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chromium
    ];
  };
}
