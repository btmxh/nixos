# Treesitter configuration
# Advanced syntax highlighting and code parsing
{ pkgs, ... }:
let
  treesitter-lyr-grammar = pkgs.tree-sitter.buildGrammar {
    language = "lyr";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "nrs-org";
      repo = "tree-sitter-lyr";
      rev = "5531c257cfda82dc346fa5fa31fa3d4cb63e147c";
      hash = "sha256-TII8yEG9xeCNq9OP+JS0EKsC1yydvM+d5xO4+BpaUN8=";
    };
    meta.homepage = "https://github.com/nrs-org/tree-sitter-lyr";
  };
in
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
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [ treesitter-lyr-grammar ];
      languageRegister.lyr = "lyr";
      extraConfig = ./treesitter-extra.lua;
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

  extraPlugins = [ treesitter-lyr-grammar ];
}
