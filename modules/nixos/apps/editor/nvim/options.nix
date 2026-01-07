# Neovim editor options (opts)
# Configure editor behavior, appearance, and preferences
{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  # Clipboard integration
  clipboard = {
    providers.wl-copy.enable = true; # Wayland clipboard support
    register = "unnamedplus"; # Use system clipboard
  };

  opts = {
    # Line numbers
    number = true; # Show line numbers
    relativenumber = true; # Show relative line numbers

    # Appearance
    termguicolors = true; # Enable 24-bit RGB colors
    cursorline = true; # Highlight current line
    ruler = true; # Show cursor position
    list = true; # Show invisible characters
    listchars = mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }"; # Define invisible chars

    # Search behavior
    ignorecase = true; # Case insensitive search
    smartcase = true; # Case sensitive when uppercase present
    gdefault = true; # Global flag for substitute by default

    # Split behavior
    splitright = true; # New vertical splits open to the right
    splitbelow = true; # New horizontal splits open below

    # Indentation
    expandtab = true; # Use spaces instead of tabs
    tabstop = 4; # Number of spaces a tab counts for
    shiftwidth = 2; # Number of spaces for each indentation level
    softtabstop = 0; # Number of spaces for tab in insert mode
    smarttab = true; # Smart tab behavior

    # File encoding
    encoding = "utf-8";
    fileencoding = "utf-8";

    # File handling
    undofile = true; # Enable persistent undo
    swapfile = true; # Enable swap files
    backup = false; # Disable backup files
    autoread = true; # Auto-reload changed files

    # Scrolling
    scrolloff = 5; # Minimum lines to keep above/below cursor

    # Code folding
    foldmethod = "expr"; # Use expression for folding
    foldexpr = "v:lua.vim.lsp.foldexpr()"; # LSP-based folding
    foldlevel = 99; # Start with all folds open
    foldlevelstart = 99; # Start with all folds open on file open
  };
}
