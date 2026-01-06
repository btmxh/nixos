{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.editor.nvim;
in
{
  options.mine.apps.editor.nvim = {
    enable = mkEnableOption "Enable neovim";
    default = mkEnableOption "Make neovim the default editor";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixfmt-rfc-style
    ];

    home-manager.users.${user.name} = {
      imports = [ inputs.nixvim.homeModules.default ];
      programs.nixvim =
        { lib, ... }:
        let
          inherit (lib.nixvim) mkRaw;
        in
        {
          enable = true;
          defaultEditor = mkIf cfg.default true;

          globals = {
            mapleader = " ";
            copilot_nes_debounce = 500;
          };

          colorschemes.catppuccin.enable = true;

          plugins = {
            lualine.enable = true;
            oil = {
              enable = true;
              settings = {
                view_options = {
                  show_hidden = true;
                };
              };
            };
            lspconfig.enable = true;
            which-key.enable = true;
            telescope.enable = true;
            web-devicons.enable = true;
            lazygit.enable = true;
            nvim-autopairs.enable = true;
            treesitter = {
              enable = true;

              settings = {
                indent = {
                  enable = true;
                };
                highlight = {
                  enable = true;
                };
              };

              nixvimInjections = true;
              grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
            };

            treesitter-context = {
              enable = true;
            };

            treesitter-textobjects = {
              enable = true;
              settings = {
                select = {
                  enable = true;
                  lookahead = true;
                };
              };
            };

            blink-cmp = {
              enable = true;
              settings.sources = {
                default = [
                  "copilot"
                  "lsp"
                  "path"
                  "snippets"
                  "buffer"
                ];
                providers = {
                  copilot = {
                    name = "copilot";
                    module = "blink-copilot";
                    score_offset = 100;
                    async = true;
                  };
                };
              };
            };

            copilot-lua = {
              enable = true;
              settings = {
                nes = {
                  enabled = true;
                  keymap = {
                    accept_and_goto = "<leader>y";
                    accept = false;
                    dismiss = "<Esc>";
                  };
                };
              };
            };
            copilot-lsp = {
              enable = true;
            };
            blink-copilot.enable = true;
          };

          opts = {
            number = true;
            relativenumber = true;
            termguicolors = true;
            ignorecase = true;
            smartcase = true;
            splitright = true;
            splitbelow = true;
            list = true;
            listchars = mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }";
            expandtab = true;
            tabstop = 4;
            shiftwidth = 2;
            softtabstop = 0;
            smarttab = true;
            clipboard = {
              providers.wl-copy.enable = true;
              register = "unnamedplus";
            };
            encoding = "utf-8";
            fileencoding = "utf-8";

            undofile = true;
            swapfile = true;
            backup = false;
            autoread = true;

            cursorline = true;
            ruler = true;
            gdefault = true;
            scrolloff = 5;
            foldmethod = "expr";
            foldexpr = "v:lua.vim.lsp.foldexpr()";
            foldlevel = 99;
            foldlevelstart = 99;
          };

          lsp.servers = {
            clangd = {
              config = {
                cmd = [
                  "clangd"
                  "--background-index"
                ];
              };
              enable = true;
            };
            lua_ls.enable = true;
            nixd = {
              enable = true;
              config.nixd.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
          };

          keymaps = [
            {
              key = ";";
              action = ":";
            }
            {
              key = ";;";
              action = ";";
            }
            {
              key = "<leader>?";
              action = mkRaw "function() require(\"which-key\").show({ global = false }) end";
              options.desc = "Buffer-local keymaps (which-key)";
            }
            {
              key = "<leader>lg";
              action = "<cmd>LazyGit<cr>";
              options.desc = "LazyGit";
            }
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

            # ─────────────────────────────
            # Split keybinds
            # ─────────────────────────────
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
            {
              key = "<leader>f";
              action = mkRaw "vim.lsp.buf.format";
              options.desc = "Format buffer (LSP)";
            }
            {
              key = "-";
              action = "<cmd>Oil<cr>";
              options.desc = "Open parent directory (oil.nvim)";
            }

            # ─────────────────────────────
            # Visual mode line movement
            # ─────────────────────────────
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

            # ─────────────────────────────
            # Make current buffer executable
            # ─────────────────────────────
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
        };
    };
  };
}
