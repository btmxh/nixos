# Treesitter configuration
# Advanced syntax highlighting and code parsing
{ pkgs, ... }:
{
  plugins = {
    # Main treesitter plugin
    treesitter = {
      enable = true;

      settings = {
        # Indentation based on treesitter
        indent = {
          enable = true;
        };
        # Syntax highlighting
        highlight = {
          enable = true;
        };
      };

      nixvimInjections = true; # Enable nixvim-specific injections
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars; # Install all language grammars
    };

    # Show context at top of buffer (function/class name)
    treesitter-context = {
      enable = true;
    };

    # Advanced text objects based on syntax tree
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true; # Look ahead for next text object
        };
      };
    };
  };
}
