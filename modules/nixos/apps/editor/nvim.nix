{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.editor.nvim;
in
{
  options.mine.apps.editor.nvim = {
    enable = mkEnableOption "Enable neovim";
    default = mkEnableOption "Make neovim the default editor";
  };

  config = mkIf cfg.enable {
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = mkIf cfg.default true;
  };
}
