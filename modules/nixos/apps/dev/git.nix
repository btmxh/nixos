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
  cfg = config.mine.apps.dev.git;
in
{
  options.mine.apps.dev.git = {
    enable = mkEnableOption "Enable Git";
    userName = mkOption {
      type = types.str;
      description = "Git username";
      default = "defaultgit";
    };
    userEmail = mkOption {
      type = types.str;
      description = "Git email";
      default = "defaultgit@git.dev";
    };
    defaultBranch = mkOption {
      type = types.str;
      description = "Default branch";
      default = "master";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.gh.enable = true;
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
          init.defaultBranch = cfg.defaultBranch;
        };
      };
    };
  };
}
