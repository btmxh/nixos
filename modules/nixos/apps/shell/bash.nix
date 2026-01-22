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
    mkOption
    types
    ;
  inherit (config.mine) user agentUser;
  cfg = config.mine.apps.shell.bash;
  inherit (config.mine.apps.cli) zoxide;
in
{
  options.mine.apps.shell.bash = {
    enable = mkEnableOption "Enable Bash shell";
    rebuild = {
      enable = mkEnableOption "Enable rebuild alias";
      nixosDir = mkOption {
        type = types.str;
        description = "`nixos` directory (this repo)";
        default = "$HOME/dev/nixos";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = mkIf user.enable {
      programs.bash = {
        enable = true;
        historyFile = "$HOME/.bash_history";
        historyFileSize = 10000;
        historySize = 10000;
        shellAliases = {
          q = "exit";
          v = "nvim";
          g = "git";
          ".." = "cd ..";
          gc = "git clone";
          cd = mkIf zoxide.enable "z";
          rebuild = mkIf cfg.rebuild.enable "nixos-rebuild switch --flake ${cfg.rebuild.nixosDir}#mine --sudo";
          o = "xdg-open";
        };
        bashrcExtra = "eval \"$(zoxide init bash)\"";
      };
    };

    home-manager.users.${agentUser.name} = mkIf agentUser.enable {
      programs.bash = {
        enable = true;
        shellAliases = {
          q = "exit";
          v = "nvim";
          g = "git";
          ".." = "cd ..";
          gc = "git clone";
          gp = "git push";
          gs = "git status";
        };
      };
    };
  };
}
