{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.shell.bash;
in
{
  options.mine.apps.shell.bash = {
    enable = mkEnableOption "Enable Bash shell";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
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
          rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#mine";
        };
      };
    };
  };
}
