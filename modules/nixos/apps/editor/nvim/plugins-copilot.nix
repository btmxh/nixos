# GitHub Copilot AI assistance configuration
# AI-powered code completions and suggestions
{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) mkRaw;

  # nixpkgs nixos-26.05 pins the v2.0.4 tarball with a stale hash because
  # upstream re-tagged that release. Fetch the current tarball instead.
  copilot-lua = pkgs.vimPlugins.copilot-lua.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      tag = "v2.0.4";
      hash = "sha256-05f76OeWBlFmlUh90tH4XMMKfNI1jnhuIJDqYPPQokA=";
    };
  });
in
{
  plugins = {
    # Main copilot plugin
    copilot-lua = {
      enable = true;
      package = copilot-lua;
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
