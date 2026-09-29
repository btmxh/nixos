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
    mkIf
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.opencode;
in
{
  options.mine.apps.dev.opencode = {
    enable = mkEnableOption "Enable OpenCode";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
      ];
    };
  };
}
