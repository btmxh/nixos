# GitHub Copilot AI assistance configuration
# AI-powered code completions and suggestions
{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    # Main copilot plugin
    copilot-lua = {
      enable = true;
      settings = {
        should_attach = mkRaw ''
          function()
            local cwd = vim.uv.cwd()
            if not cwd then
              return true
            end

            return not vim.uv.fs_stat(cwd .. "/.copilotignore")
          end
        '';
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
