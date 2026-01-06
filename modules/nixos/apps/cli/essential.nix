{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.cli.essential;
in
{
  options.mine.apps.cli.essential = {
    enable = mkEnableOption "Enable essential CLI tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep
      bottom
      killall
    ];
  };
}
