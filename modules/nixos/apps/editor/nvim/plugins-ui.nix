# UI and interface-related plugins
# Status line, file explorer, fuzzy finder, etc.
{
  plugins = {
    # Status line
    lualine.enable = true;

    # File explorer
    oil = {
      enable = true;
      settings = {
        view_options = {
          show_hidden = true; # Show hidden files
        };
      };
    };

    # Keybinding help
    which-key.enable = true;

    # Fuzzy finder
    telescope.enable = true;

    # File type icons
    web-devicons.enable = true;

    # Git UI
    lazygit.enable = true;

    # Auto-close brackets/quotes
    nvim-autopairs.enable = true;
  };
}
