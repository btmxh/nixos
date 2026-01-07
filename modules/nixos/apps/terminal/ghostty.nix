{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.terminal.ghostty;
in
{
  options.mine.apps.terminal.ghostty = {
    enable = mkEnableOption "Enable Ghostty terminal";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.ghostty = {
        enable = true;
        settings.background-opacity = "0.8";
      };
    };
  };
}
