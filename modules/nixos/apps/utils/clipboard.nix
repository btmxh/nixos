{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.utils.clipboard;
in
{
  options.mine.apps.utils.clipboard = {
    enable = mkEnableOption "Enable clipboard utilities";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.wl-clip-persist.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
