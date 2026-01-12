# LSP (Language Server Protocol) configuration
# Code completion, language servers, and formatting
{ lsp, ... }:
{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lsp) skipInstallServers;
  enabled = {
    enable = true;
    package = mkIf skipInstallServers null;
  };
in
{
  plugins = {
    # LSP base configuration
    lspconfig.enable = true;
    rustaceanvim.enable = true; # Rust-specific enhancements
    fidget.enable = true; # Useful LSP status updates

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
  # NOTE: package are intentionally set to null,
  # To use LSPs, install them manually in your nix development shell
  lsp.servers = {
    # C/C++ language server
    clangd = {
      enable = true;
      package = mkIf skipInstallServers null;
      config = {
        cmd = [
          "clangd"
          "--background-index" # Index in background for better performance
        ];
      };
    };

    # Lua language server
    lua_ls = enabled;

    # Nix language server
    nixd = {
      enable = true;
      package = mkIf skipInstallServers null;
      config.nixd.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
    };

    tinymist = {
      enable = true;
      package = mkIf skipInstallServers null;
      config = {
        settings = {
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          root_dir = "-";
          formatterMode = "typstyle";
        };
      };
    };

    # Web dev
    eslint = enabled;
    html = enabled;
    emmet_language_server = enabled;
    cssls = enabled;
    tailwindcss = enabled;
    # NOTE: deno and ts_ls really hates each other, install only one of them in your devenv
    ts_ls = enabled;
    denols = enabled;
  };
}
