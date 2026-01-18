{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.browser.firefox;
in
{
  options.mine.apps.browser.firefox = {
    enable = mkEnableOption "Enable Firefox browser";
    default = mkEnableOption "Make Firefox the default browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.firefox = {
        enable = true;
      };
    };
  };
}
