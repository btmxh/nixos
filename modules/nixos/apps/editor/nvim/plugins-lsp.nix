# LSP (Language Server Protocol) configuration
# Code completion, language servers, and formatting
{ lib, pkgs, ... }:
{
  plugins = {
    # LSP base configuration
    lspconfig.enable = true;

    # Code completion engine
    blink-cmp = {
      enable = true;
      settings.sources = {
        default = [
          "copilot" # AI suggestions
          "lsp" # Language server completions
          "path" # File path completions
          "snippets" # Code snippets
          "buffer" # Buffer text completions
        ];
        providers = {
          copilot = {
            name = "copilot";
            module = "blink-copilot";
            score_offset = 100; # Prioritize copilot suggestions
            async = true;
          };
        };
      };
    };
  };

  # Language server configurations
  lsp.servers = {
    # C/C++ language server
    clangd = {
      config = {
        cmd = [
          "clangd"
          "--background-index" # Index in background for better performance
        ];
      };
      enable = true;
    };

    # Lua language server
    lua_ls.enable = true;

    # Nix language server
    nixd = {
      enable = true;
      config.nixd.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
    };
  };
}
