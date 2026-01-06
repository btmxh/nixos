{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.editor.helix;
in
{
  options.mine.apps.editor.helix = {
    enable = mkEnableOption "Enable helix";
    default = mkEnableOption "Make helix the default editor";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.helix.enable = true;
      programs.helix.defaultEditor = mkIf cfg.default true;
    };
  };
}
