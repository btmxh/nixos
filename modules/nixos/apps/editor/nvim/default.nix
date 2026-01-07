# Neovim configuration entry point
# Main module definition with options and imports
{
  inputs,
  config,
  lib,
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
    lsp = {
      skipInstallServers = mkEnableOption "Skip automatic installation of LSP servers";
    };
  };

  config = mkIf cfg.enable {
    # Home-manager configuration
    home-manager.users.${user.name} = {
      imports = [ inputs.nixvim.homeModules.default ];
      programs.ripgrep.enable = true; # Enable ripgrep for searching within Neovim
      programs.nixvim = {
        enable = true;
        defaultEditor = mkIf cfg.default true;

        # Import all configuration modules
        imports = [
          ./globals.nix # Global settings and colorscheme
          ./options.nix # Editor options
          ./plugins-ui.nix # UI plugins
          (import ./plugins-lsp.nix { inherit (cfg) lsp; }) # LSP configuration
          ./plugins-treesitter.nix # Treesitter plugins
          ./plugins-copilot.nix # Copilot AI assistance
          ./keymaps.nix # Keybindings
        ];

        extraSpecialArgs = {
          nvimCfg = cfg;
        };
      };
    };
  };
}
