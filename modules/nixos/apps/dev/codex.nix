{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.codex;
in
{
  options.mine.apps.dev.codex = {
    enable = mkEnableOption "Enable Codex";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.codex.enable = true;
    };
  };
}
