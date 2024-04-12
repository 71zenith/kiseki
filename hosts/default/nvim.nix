{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs = {
    nixvim = {
      enable = true;
      globals = {
        mapleader = " ";
        neovide_cursor_animation_length = 0.025;
        neovide_cursor_vfx_mode = "railgun";
        neovide_refresh_rate = 75;
        neovide_padding_bottom = 10;
        neovide_padding_top = 10;
        neovide_padding_right = 10;
        neovide_padding_left = 10;
        neovide_transparency = 0.90;
      };
      clipboard.providers.wl-copy.enable = true;
      enableMan = false;
      opts = {
        number = true;
        relativenumber = false;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        autoindent = true;
        wrap = false;
        ignorecase = true;
        autochdir = true;
        smarttab = true;
        listchars = {
          tab = " ──";
          trail = "·";
          nbsp = "␣";
          precedes = "«";
          extends = "»";
        };
        fillchars = {
          eob = " ";
          vert = " ";
          horiz = " ";
          diff = "╱";
          foldclose = "";
          foldopen = "";
          fold = " ";
          msgsep = "─";
        };
        showmode = false;
        wildmode = ["longest" "list" "full"];
        mouse = "a";
        autoread = true;
        smartcase = true;
        cursorline = true;
        scrolloff = 10;
        sidescrolloff = 10;
        termguicolors = true;
        background = "dark";
        signcolumn = "yes";
        backspace = "indent,eol,start";
        splitright = true;
        splitbelow = true;
        swapfile = false;
        clipboard = "unnamedplus";
        undofile = true;
        undolevels = 10000;
        list = true;
        formatoptions = "jcroqlnt";
        conceallevel = 0;
        spell = true;
        spelllang = ["en_us"];
        concealcursor = "nc";
        autowrite = true;
        pumheight = 10;
        updatetime = 200;
        showbreak = "⤷ ";
      };
      extraPlugins = with pkgs.vimPlugins; [oxocarbon-nvim];
      colorscheme = "oxocarbon";
      plugins = {
        nix.enable = true;
        barbar.enable = true;
        nvim-autopairs = {
          enable = true;
          checkTs = true;
        };
        toggleterm = {
          enable = true;
          direction = "float";
        };
        comment.enable = true;
        todo-comments.enable = true;
        barbecue = {
          enable = true;
          leadCustomSection = ''
            function()
              return { { " ", "WinBar" } }
            end,
          '';
        };
        lsp = {
          enable = true;
          preConfig = ''
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
              local hl = "DiagnosticSign" .. type
              vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
          '';
          servers = {
            nil_ls.enable = true;
            clojure-lsp.enable = true;
            bashls.enable = true;
            pyright.enable = true;
            ruff-lsp.enable = true;
          };
        };
        flash.enable = true;
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = true;
          };
        };
        cursorline.enable = true;
        alpha = {
          enable = true;
          theme = "dashboard";
        };
        trouble.enable = true;
        inc-rename.enable = true;
        direnv.enable = true;
        neo-tree.enable = true;
        cmp-buffer.enable = true;
        cmp-spell.enable = true;
        cmp-nvim-lsp.enable = true;
        lastplace.enable = true;
        better-escape.enable = true;
        lspkind.enable = true;
        friendly-snippets.enable = true;
        lsp-format.enable = true;
        none-ls = {
          enable = true;
          enableLspFormat = true;
          sources = {
            formatting = {alejandra.enable = true;};
            diagnostics = {statix.enable = true;};
          };
        };
        noice = {
          enable = true;
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = true;
          };
        };
        neogit.enable = true;
        lualine = {
          enable = true;
          extensions = ["neo-tree" "trouble" "quickfix" "man" "toggleterm"];
          sectionSeparators = {
            left = "";
            right = "";
          };
          componentSeparators = {
            left = "";
            right = "";
          };
        };
        luasnip.enable = true;
        cmp_luasnip.enable = true;
        which-key.enable = true;
        fidget.enable = true;
        treesitter = {
          enable = true;
          incrementalSelection = {
            enable = true;
            keymaps = {
              initSelection = "<C-SPACE>";
              nodeIncremental = "<C-SPACE>";
              nodeDecremental = "<BS>";
            };
          };
        };
        treesitter-textobjects = {
          enable = true;
          lspInterop.enable = true;
          select = {
            lookahead = true;
            keymaps = {
              "a=" = {
                query = "@assignment.outer";
                desc = "Select outer part of an assignment";
              };
              "i=" = {
                query = "@assignment.outer";
                desc = "Select outer part of an assignment";
              };
              "l=" = {
                query = "@assignment.lhs";
                desc = "Select left hand side of an assignment";
              };
              "r=" = {
                query = "@assignment.rhs";
                desc = "Select right hand side of an assignment";
              };
              "ai" = {
                query = "@conditional.outer";
                desc = "Select outer part of a conditional";
              };
              "ii" = {
                query = "@conditional.inner";
                desc = "Select inner part of a conditional";
              };
              "il" = {
                query = "@loop.inner";
                desc = "Select inner part of a loop";
              };
              "al" = {
                query = "@loop.outer";
                desc = "Select outer part of a loop";
              };
              "aa" = {
                query = "@parameter.outer";
                desc = "Select outer part of a parameter";
              };
              "ia" = {
                query = "@parameter.inner";
                desc = "Select inner part of a parameter";
              };
              "af" = {
                query = "@function.outer";
                desc = "Select outer part of a function";
              };
              "if" = {
                query = "@function.inner";
                desc = "Select inner part of a function";
              };
            };
          };
          move = {
            enable = true;
            setJumps = true;
            gotoNextStart = {
              "]f" = {
                query = "@function.outer";
                desc = "Next function call start";
              };
              "]l" = {
                query = "@loop.outer";
                desc = "Next loop start";
              };
              "]i" = {
                query = "@conditional.outer";
                desc = "Next conditional start";
              };
            };
            gotoPreviousStart = {
              "[f" = {
                query = "@function.outer";
                desc = "Previous function call start";
              };
              "[l" = {
                query = "@loop.outer";
                desc = "Previous loop start";
              };
              "[i" = {
                query = "@conditional.outer";
                desc = "Previous conditional start";
              };
            };
            gotoPreviousEnd = {
              "[F" = {
                query = "@function.outer";
                desc = "Previous function call end";
              };
              "[L" = {
                query = "@loop.outer";
                desc = "Previous loop end";
              };
              "[I" = {
                query = "@conditional.outer";
                desc = "Previous conditional end";
              };
            };
            gotoNextEnd = {
              "]F" = {
                query = "@function.outer";
                desc = "Next function call end";
              };
              "]L" = {
                query = "@loop.outer";
                desc = "Next loop end";
              };
              "]I" = {
                query = "@conditional.outer";
                desc = "Next conditional end";
              };
            };
          };
        };
        rainbow-delimiters.enable = true;
        sniprun.enable = true;
        cmp = {
          enable = true;
          settings = {
            sources = [{name = "nvim_lsp";} {name = "spell";} {name = "luasnip";} {name = "path";} {name = "buffer";}];
            matching.disallow_fullfuzzy_matching = true;
            snippet.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-h>" = "cmp.mapping.close()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<C-l>" = "cmp.mapping.confirm({ select = true })";
              "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };
        telescope = {
          enable = true;
          settings = {
            defaults = {
              mappings = {
                i = {
                  "<C-j>" = {
                    __raw = "require('telescope.actions').move_selection_next";
                  };
                  "<C-h>" = {
                    __raw = "require('telescope.actions').select_horizontal";
                  };
                  "<C-l>" = {
                    __raw = "require('telescope.actions').select_horizontal";
                  };
                  "<C-k>" = {
                    __raw = "require('telescope.actions').move_selection_previous";
                  };
                };
              };
            };
          };
        };
      };
      keymaps = [
        {
          key = "<leader>ft";
          mode = "n";
          action = "<CMD>Telescope<NL>";
          options.desc = "Open Telescope";
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<CMD>Telescope lsp_document_symbols<NL>";
          options.desc = "Document Symbols";
        }
        {
          key = "<leader>gS";
          mode = "n";
          action = "<CMD>Telescope lsp_dynamic_workspace_symbols<NL>";
          options.desc = "Workspace Symbols";
        }
        {
          key = "<leader>gr";
          mode = "n";
          action = ":IncRename ";
          options.desc = "Rename symbol";
        }
        {
          key = "<leader>gl";
          mode = "n";
          action = "<CMD>TroubleToggle<NL>";
          options.desc = "Trouble";
        }
        {
          key = "K";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.hover()<NL>";
          options.desc = "Show Hover Docs";
        }
        {
          key = "<leader>gi";
          mode = "n";
          action = "<CMD>Telescope lsp_implementations<NL>";
          options.desc = "Goto Implementations";
        }
        {
          key = "<leader>gd";
          mode = "n";
          action = "<CMD>Telescope lsp_definitions<NL>";
          options.desc = "Goto Definitions";
        }
        {
          key = "<leader>gh";
          mode = "n";
          action = "<CMD>Telescope lsp_references<NL>";
          options.desc = "List References";
        }
        {
          key = "<leader>gr";
          mode = "n";
          action = ":IncRename ";
          options.desc = "Rename symbol";
        }
        {
          key = "K";
          mode = "x";
          action = ":move '<-2<CR>gv-gv";
          options.desc = "Move selected lines up";
        }
        {
          key = "==";
          mode = "n";
          action = "gg<S-v>G";
          options.desc = "Select All";
        }
        {
          key = "N";
          mode = "n";
          action = "Nzzzv";
        }
        {
          key = "n";
          mode = "n";
          action = "nzzzv";
        }
        {
          key = "<C-u>";
          mode = "n";
          action = "<C-u>zz";
        }
        {
          key = "<C-d>";
          mode = "n";
          action = "<C-d>zz";
        }
        {
          key = "J";
          mode = "x";
          action = ":move '>+1<CR>gv-gv";
          options.desc = "Move selected lines down";
        }
        {
          key = "<leader>fc";
          mode = "n";
          action = "<CMD>Telescope grep_string<NL>";
          options.desc = "Find string under cursor";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<CMD>Telescope live_grep<NL>";
          options.desc = "Live grep";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = "<CMD>Telescope registers<NL>";
          options.desc = "Registers";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<CMD>Telescope oldfiles<NL>";
          options.desc = "Recent Files";
        }
        {
          key = "<leader>fu";
          mode = "n";
          action = "<CMD>Telescope colorscheme<NL>";
          options.desc = "Change colorscheme";
        }
        {
          key = "<leader>ff";
          mode = "n";
          action = "<CMD>Telescope fd<NL>";
          options.desc = "Find Files";
        }
        {
          key = "<leader>o";
          mode = "n";
          action = "<CMD>Neotree float toggle<NL>";
          options.desc = "Open NeoTree";
        }
        {
          key = "<leader>n";
          mode = ["n" "t"];
          action = "<CMD>ToggleTerm<NL>";
          options.desc = "Toggle Terminal";
        }
        {
          key = "<leader>hh";
          mode = "n";
          action = "<CMD>Neogit<NL>";
          options.desc = "Open Neogit";
        }
        {
          key = "<leader>hS";
          mode = "n";
          action = "<CMD>Gitsigns stage_buffer<NL>";
          options.desc = "Stage Buffer";
        }
        {
          key = "<leader>hs";
          mode = "n";
          action = "<CMD>Gitsigns stage_hunk<NL>";
          options.desc = "Stage Hunk";
        }
        {
          key = "<leader>hu";
          mode = "n";
          action = "<CMD>Gitsigns undo_stage_hunk<NL>";
          options.desc = "Unstage Hunk";
        }
        {
          key = "<leader>hp";
          mode = "n";
          action = "<CMD>Gitsigns preview_hunk<NL>";
          options.desc = "Preview Hunk";
        }
        {
          key = "<leader>hr";
          mode = "n";
          action = "<CMD>Gitsigns reset_hunk<NL>";
          options.desc = "Reset Hunk";
        }
        {
          key = "<leader>wv";
          mode = "n";
          action = "<C-w>v";
          options.desc = "Split window vertically";
        }
        {
          key = "<leader>wc";
          mode = "n";
          action = "<CMD>close!<NL>";
          options.desc = "Close current split";
        }
        {
          key = "<leader>wh";
          mode = "n";
          action = "<C-w>s";
          options.desc = "Split window horizontally";
        }
        {
          key = "<leader>wn";
          mode = "n";
          action = "<CMD>tabnew<NL>";
          options.desc = "Open new tab";
        }
        {
          key = "<leader>-";
          mode = "n";
          action = "<C-x>";
          options.desc = "Decrement number";
        }
        {
          key = "<leader>+";
          mode = "n";
          action = "<C-a>";
          options.desc = "Increment number";
        }
        {
          key = "<leader>wk";
          mode = "n";
          action = "<CMD>bd!<NL>";
          options.desc = "Close current tab";
        }
        {
          key = "<Tab>";
          mode = "n";
          action = "<CMD>:bnext<NL>";
          options.desc = "Next Buffer";
        }
        {
          key = "<leader><r>";
          mode = ["n" "v"];
          action = "<CMD>SnipRun<NL>";
          options.desc = "Run Code";
        }
        {
          key = "<leader><leader>";
          mode = ["n" "v"];
          action = ":";
          options.desc = "Open CmdLine";
        }
        {
          key = "<S-Tab>";
          mode = "n";
          action = "<CMD>:bprevious<NL>";
          options.desc = "Previous Buffer";
        }
        {
          key = "<ESC>";
          mode = "n";
          action = "<CMD>:noh<NL>";
          options.desc = "Clear Highlights";
        }
        {
          key = "<leader>K";
          mode = "n";
          action = "<CMD>:qa<NL>";
          options.desc = "Quit";
        }
        {
          key = "<leader>s";
          mode = "n";
          action = "<CMD>:w<NL>";
          options.desc = "Save Buffer";
        }
        {
          key = "<C-h>";
          mode = "n";
          action = "<C-w>h";
          options.desc = "Navigate to pane left";
        }
        {
          key = "<C-l>";
          mode = "n";
          action = "<C-w>l";
          options.desc = "Navigate to pane right";
        }
        {
          key = "<C-k>";
          mode = "n";
          action = "<C-w>k";
          options.desc = "Navigate to pane up";
        }
        {
          key = "<C-j>";
          mode = "n";
          action = "<C-w>j";
          options.desc = "Navigate to pane down";
        }
        {
          key = "<C-S-l>";
          mode = "n";
          action = "<CMD>:vertical resize +2<NL>";
          options.desc = "Resize pane right";
        }
        {
          key = "<C-S-h>";
          mode = "n";
          action = "<CMD>:vertical resize -2<NL>";
          options.desc = "Resize pane left";
        }
        {
          key = "<C-S-k>";
          mode = "n";
          action = "<CMD>:resize +2<NL>";
          options.desc = "Resize pane up";
        }
        {
          key = "<C-S-j>";
          mode = "n";
          action = "<CMD>:resize -2<NL>";
          options.desc = "Resize pane down";
        }
        {
          key = "<C-BS>";
          mode = ["n" "i"];
          action = "<C-w>";
          options.desc = "Ctrl+Backspace to delete word";
        }
        {
          key = "[t";
          mode = "n";
          action = "require('todo-comments').jump_previous()";
          options.desc = "Previous TODO Comment";
        }
        {
          key = "]t";
          mode = "n";
          action = "require('todo-comments').jump_next()";
          options.desc = "Next TODO Comment";
        }
        {
          key = ",";
          mode = ["n" "x" "o"];
          action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_move.repeat_last_move_opposite()";
          options.desc = ", with treesitter";
        }
        {
          key = ";";
          mode = ["n" "x" "o"];
          action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_move.repeat_last_move()";
          options.desc = "; with treesitter";
        }
      ];
    };
  };
}
