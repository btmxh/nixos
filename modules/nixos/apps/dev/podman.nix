{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.podman;
in
{
  options.mine.apps.dev.podman = {
    enable = mkEnableOption "Enable Podman";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name}.services.podman = {
      enable = true;
      dockerCompat = true;
    };

    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users.${user.name}.extraGroups = [ "podman" ];
  };
}
