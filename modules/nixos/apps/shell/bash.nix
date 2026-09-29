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

  # The machine config is a flake input so it never enters git. When its
  # location is known, every rebuild carries the override.
  personalFlag =
    if cfg.rebuild.personalConfig != null then
      "--override-input personal path:${cfg.rebuild.personalConfig} "
    else
      "";
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
      personalConfig = mkOption {
        type = types.str;
        description = ''
          Directory holding config.user.nix, passed to the flake as the
          `personal` input so that file stays out of git. Set this in your
          machine config; when it is null the aliases are built without the
          override and the flake's throwing stub reports the problem.
        '';
        default = null;
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
          rebuild = mkIf cfg.rebuild.enable "nixos-rebuild switch ${personalFlag}--flake ${cfg.rebuild.nixosDir}#mine --sudo";
          rebuild-boot = mkIf cfg.rebuild.enable "nixos-rebuild boot ${personalFlag}--flake ${cfg.rebuild.nixosDir}#mine --sudo";
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
