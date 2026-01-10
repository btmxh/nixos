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
  inherit (config.mine) user agentUser;
in
{
  options.mine.agentUser = {
    enable = mkEnableOption "Enable AI Agent User";
    name = mkOption {
      type = types.str;
      default = "ai";
      description = "AI Agent user account name";
    };
    email = mkOption {
      type = types.str;
      default = "aiagent@ai.slop";
      description = "AI agent email";
    };
    shell = mkOption {
      default = { };
      description = "Shell config for user";
      type = types.submodule {
        options = {
          package = mkOption {
            type = types.package;
            default = pkgs.bash;
            description = "User shell";
          };
        };
      };
    };
  };

  config = mkIf user.enable {
    mine.apps.shell.bash.enable = mkIf (user.shell.package == pkgs.bash) true;
    # mine.system.shell.fish.enable = mkIf (user.shell.package == pkgs.fish) true;
    # mine.system.shell.zsh.enable = mkIf (user.shell.package == pkgs.zsh) true;

    nix.settings.trusted-users = [ "${user.name}" ];

    users.groups.${agentUser.name} = { };

    users.users = {
      ${agentUser.name} = {
        isNormalUser = true;
        createHome = true;
        group = "${agentUser.name}";
        shell = user.shell.package;
      };

      ${user.name}.extraGroups = [ agentUser.name ];
    };

    home-manager.users.${agentUser.name} = {
      programs.git = {
        enable = true;
        settings.user = {
          inherit (agentUser) name email;
        };
      };

      home = {
        username = agentUser.name;
        stateVersion = "25.11";
      };
    };
  };
}
