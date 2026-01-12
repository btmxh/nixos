# Neovim keymaps configuration
# Organized by functionality with clear groupings
{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  keymaps = [
    # ─────────────────────────────────────────────────────────
    # Command mode shortcuts
    # ─────────────────────────────────────────────────────────
    {
      key = ";";
      action = ":";
    }
    {
      key = ";;";
      action = ";";
    }

    # ─────────────────────────────────────────────────────────
    # Help & Discovery
    # ─────────────────────────────────────────────────────────
    {
      key = "<leader>?";
      action = mkRaw "function() require(\"which-key\").show({ global = false }) end";
      options.desc = "Buffer-local keymaps (which-key)";
    }

    # ─────────────────────────────────────────────────────────
    # Git Integration
    # ─────────────────────────────────────────────────────────
    {
      key = "<leader>lg";
      action = "<cmd>LazyGit<cr>";
      options.desc = "LazyGit";
    }

    # ─────────────────────────────────────────────────────────
    # Window Navigation
    # ─────────────────────────────────────────────────────────
    # Focus navigation (Ctrl + hjkl)
    {
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to left window";
    }
    {
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to lower window";
    }
    {
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to upper window";
    }
    {
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to right window";
    }

    # Window movement (Ctrl + Shift + hjkl)
    {
      key = "<C-S-h>";
      action = "<C-w>H";
      options.desc = "Move window to left";
    }
    {
      key = "<C-S-j>";
      action = "<C-w>J";
      options.desc = "Move window to lower";
    }
    {
      key = "<C-S-k>";
      action = "<C-w>K";
      options.desc = "Move window to upper";
    }
    {
      key = "<C-S-l>";
      action = "<C-w>L";
      options.desc = "Move window to right";
    }

    # ─────────────────────────────────────────────────────────
    # Split Management
    # ─────────────────────────────────────────────────────────
    {
      key = "<leader>ph";
      action = "<cmd>split<cr>";
      options.desc = "Open horizontal split";
    }
    {
      key = "<leader>pv";
      action = "<cmd>vsplit<cr>";
      options.desc = "Open vertical split";
    }
    {
      key = "<leader>pH";
      action = "<cmd>split<cr><cmd>term<cr>";
      options.desc = "Open horizontal terminal split";
    }
    {
      key = "<leader>pV";
      action = "<cmd>vsplit<cr><cmd>term<cr>";
      options.desc = "Open vertical terminal split";
    }

    # ─────────────────────────────────────────────────────────
    # Search (Telescope)
    # ─────────────────────────────────────────────────────────
    {
      key = "<leader>sf";
      action = mkRaw "require('telescope.builtin').find_files";
      options.desc = "Search Files (Telescope)";
    }
    {
      key = "<leader>sg";
      action = mkRaw "require('telescope.builtin').live_grep";
      options.desc = "Search by Grep (Telescope)";
    }

    # ─────────────────────────────────────────────────────────
    # LSP & Formatting
    # ─────────────────────────────────────────────────────────
    {
      key = "grd";
      action = mkRaw "vim.lsp.buf.definition";
      options.desc = "Go to Definition (LSP)";
    }
    {
      key = "grD";
      action = mkRaw "vim.lsp.buf.declaration";
      options.desc = "Go to Declaration (LSP)";
    }
    {
      key = "<leader>f";
      action = mkRaw "vim.lsp.buf.format";
      options.desc = "Format buffer (LSP)";
    }

    # ─────────────────────────────────────────────────────────
    # LSP-specific functionalities
    # ─────────────────────────────────────────────────────────
    {
      key = "gpm";
      action = mkRaw ''
        function()
          local exec = false
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.name == "tinymist" then
              client:exec_cmd({
                title = 'tinymist/pinMain',
                command = 'tinymist.pinMain',
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
              exec = true
            end
          end

          if exec then
            vim.notify("Pinned main Typst file for tinymist LSP", vim.log.levels.INFO)
          else
            vim.notify("tinymist LSP not active in this buffer", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Pin main Typst file";
    }

    # ─────────────────────────────────────────────────────────
    # File Management
    # ─────────────────────────────────────────────────────────
    {
      key = "-";
      action = "<cmd>Oil<cr>";
      options.desc = "Open parent directory (oil.nvim)";
    }

    # ─────────────────────────────────────────────────────────
    # Visual Mode - Line Movement
    # ─────────────────────────────────────────────────────────
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<cr>gv=gv";
      options.desc = "Move line down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<cr>gv=gv";
      options.desc = "Move line up";
    }

    # ─────────────────────────────────────────────────────────
    # Script Utilities
    # ─────────────────────────────────────────────────────────
    {
      key = "<leader>x";
      action = mkRaw ''
        function()
          local name = vim.api.nvim_buf_get_name(0)
          local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

          local function add_shebang_line(cmd)
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!" .. cmd })
          end

          if not first_line:find("^#!") then
            if name:find("%.py$") then
              add_shebang_line("/bin/env python3")
            elseif name:find("%.sh$") then
              add_shebang_line("/bin/sh")
            else
              vim.notify("Unrecognized script filetype, shebang line not added")
            end
          end

          vim.fn.system({ "chmod", "+x", name })
        end
      '';
      options = {
        desc = "Make current buffer executable";
        silent = true;
      };
    }
  ];
}
