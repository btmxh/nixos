{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.docker;
in
{
  options.mine.apps.dev.docker = {
    enable = mkEnableOption "Enable Docker";
    customPath = {
      enable = mkEnableOption "Enable custom Docker storage path";
      path = mkOption {
        type = types.str;
        description = "Custom Docker storage path";
        default = "/var/lib/docker/";
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = mkIf cfg.customPath.enable {
        data-root = cfg.customPath.path;
      };
    };

    # basically root, beware!
    users.users.${user.name}.extraGroups = [ "docker" ];

    hardware.nvidia-container-toolkit.enable = true;
  };
}
