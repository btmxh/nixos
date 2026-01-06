# Neovim configuration entry point
# Main module definition with options and imports
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.editor.nvim;
in
{
  # Module options
  options.mine.apps.editor.nvim = {
    enable = mkEnableOption "Enable neovim";
    default = mkEnableOption "Make neovim the default editor";
  };

  config = mkIf cfg.enable {
    # System packages needed for neovim
    environment.systemPackages = with pkgs; [
      nixfmt-rfc-style # Nix formatter for LSP
    ];

    # Home-manager configuration
    home-manager.users.${user.name} = {
      imports = [ inputs.nixvim.homeModules.default ];
      programs.nixvim =
        { lib, ... }:
        {
          enable = true;
          defaultEditor = mkIf cfg.default true;

          # Import all configuration modules
          imports = [
            ./globals.nix # Global settings and colorscheme
            ./options.nix # Editor options
            ./plugins-ui.nix # UI plugins
            ./plugins-lsp.nix # LSP configuration
            ./plugins-treesitter.nix # Treesitter plugins
            ./plugins-copilot.nix # Copilot AI assistance
            ./keymaps.nix # Keybindings
          ];
        };
    };
  };
}
