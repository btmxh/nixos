{
  lib,
  config,
  pkgs,
  inputs,
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

  home-directory = "/home/${user.name}";

in
{
  options.mine.user = {
    enable = mkEnableOption "Enable User";
    name = mkOption {
      type = types.str;
      default = "ayaneso";
      description = "User account name";
    };
    alias = mkOption {
      type = types.str;
      default = "ayns";
      description = "Full alias";
    };
    email = mkOption {
      type = types.str;
      default = "nam8.gb@gmail.com";
      description = "My email";
    };
    homeDir = mkOption {
      type = types.str;
      default = "${home-directory}";
      description = "Home directory path";
    };
    home-manager.enable = mkEnableOption "Enable home-manager";
    ghToken.enable = mkEnableOption "Include GitHub access-tokens in nix.conf";
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
          starship.enable = mkEnableOption "Enable starship";
        };
      };
    };
  };

  config = mkIf user.enable {
    mine.apps.shell.bash.enable = mkIf (user.shell.package == pkgs.bash) true;
    # mine.system.shell.fish.enable = mkIf (user.shell.package == pkgs.fish) true;
    # mine.system.shell.zsh.enable = mkIf (user.shell.package == pkgs.zsh) true;

    nix.settings.trusted-users = [ "${user.name}" ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';

    users.groups.${user.name} = { };

    users.users.${user.name} = {
      isNormalUser = true;
      createHome = true;
      uid = 1000;
      group = "${user.name}";
      extraGroups = [ "wheel" ];
      shell = user.shell.package;
    };

  };
}
