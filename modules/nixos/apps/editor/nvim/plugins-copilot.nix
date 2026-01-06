# GitHub Copilot AI assistance configuration
# AI-powered code completions and suggestions
{
  plugins = {
    # Main copilot plugin
    copilot-lua = {
      enable = true;
      settings = {
        nes = {
          enabled = true; # Enable new suggestion UI
          keymap = {
            accept_and_goto = "<leader>y"; # Accept suggestion and move to next
            accept = false; # Disable default accept key
            dismiss = "<Esc>"; # Dismiss suggestion with Escape
          };
        };
      };
    };

    # Copilot LSP integration
    copilot-lsp = {
      enable = true;
    };

    # Copilot completion source for blink-cmp
    blink-copilot.enable = true;
  };
}
