{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.chat.discord;
in
{
  options.mine.apps.chat.discord = {
    enable = mkEnableOption "Enable Discord";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.discord = {
        enable = true;
      };
    };
  };
}
