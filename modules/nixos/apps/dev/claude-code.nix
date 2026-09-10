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
  cfg = config.mine.apps.dev.claude-code;
in
{
  options.mine.apps.dev.claude-code = {
    enable = mkEnableOption "Enable Claude Code";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        claude-code
      ];
    };
  };
}
