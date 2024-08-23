{
  inputs,
  config,
  pkgs,
  ...
}: let
  plugins = import ../pkgs/plugins-nvim.nix {inherit pkgs;};
  queryDesc = query: desc: {inherit query desc;};
in {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  stylix.targets = {
    nixvim.enable = false;
    vim.enable = false;
  };

  programs = {
    nixvim = {
      enable = true;
      luaLoader.enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      colorschemes.oxocarbon.enable = true;
      performance = {
        combinePlugins = {
          enable = true;
          standalonePlugins = ["nvim-treesitter" "nvim-treesitter-textobjects"];
        };
        byteCompileLua = {
          enable = true;
          nvimRuntime = true;
          plugins = true;
        };
      };
      extraConfigLuaPre = ''
        require("buffer_manager").setup({ focus_alternate_buffer = true})
        require("which-key").setup({icons = {rules = false}})
        require("nvim-paredit").setup({use_default_keys = true})
      '';
      extraConfigLuaPost = ''
        require("cmp").event:on(
          'confirm_done',
          require("nvim-autopairs.completion.cmp").on_confirm_done())
      '';
      # HACK: till upstream fix arrives
      highlight = {
        WinBar.bg = config.lib.stylix.colors.withHashtag.base00;
        WinBarNC.bg = config.lib.stylix.colors.withHashtag.base00;
      };
      globals = {
        mapleader = " ";
        maplocalleader = ";";
        neovide_cursor_animation_length = 0.025;
        neovide_cursor_vfx_mode = "railgun";
        neovide_refresh_rate = 75;
        neovide_input_ime = true;
        neovide_padding_bottom = 8;
        neovide_padding_top = 8;
        neovide_padding_right = 8;
        neovide_padding_left = 8;
        neovide_transparency = 0.90;
      };
      clipboard.providers.wl-copy.enable = true;
      enableMan = false;
      opts = {
        number = true;
        relativenumber = false;
        completeopt = "menu,menuone,noselect";
        encoding = "utf-8";
        fileencoding = "utf-8";
        shiftwidth = 2;
        tabstop = 2;
        confirm = true;
        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";
        expandtab = true;
        autoindent = true;
        laststatus = 3;
        autoread = true;
        history = 10000;
        foldlevelstart = 99;
        timeoutlen = 300;
        inccommand = "split";
        cindent = true;
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
        wildmode = "longest:full,full";
        mouse = "a";
        smartcase = true;
        smartindent = true;
        winminwidth = 5;
        cursorline = true;
        scrolloff = 999;
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
        formatoptions = "jqlnt";
        conceallevel = 0;
        spelllang = ["en_us"];
        concealcursor = "nc";
        autowrite = true;
        pumheight = 10;
        pumblend = 10;
        shiftround = true;
        updatetime = 200;
        showbreak = "⤷ ";
      };
      extraPlugins = with plugins // pkgs.vimPlugins; [satellite-nvim lualine-so-fancy buffer-manager nvim-paredit vim-jack-in vim-dispatch];
      plugins = {
        nix.enable = false;
        nvim-bqf.enable = true;
        nvim-autopairs.enable = true;
        todo-comments.enable = true;
        barbecue = {
          enable = true;
          leadCustomSection = ''
            function()
              return {{" ","WinBar"}}
            end
          '';
        };
        dressing.enable = true;
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
            nil-ls.enable = true;
            bashls.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            pyright.enable = true;
            zls.enable = true;
            ruff-lsp.enable = true;
          };
        };
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = true;
          };
        };
        cursorline.enable = true;
        toggleterm = {
          enable = true;
          settings.direction = "float";
        };
        alpha = {
          enable = true;
          layout = [
            {
              type = "padding";
              val = 4;
            }
            {
              opts = {
                hl = "Type";
                position = "center";
              };
              type = "text";
              val = [
                "⠀⠀⡜⡁⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
                "⠀⠀⢻⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇"
                "⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣿⡟⠀⢸⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇"
                "⠀⠀⢸⡿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢸⡿⡇⠀⢸⡿⢸⣿⡟⣿⣿⣿⣿⣿⣿⡏⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃"
                "⠀⠀⠀⠁⠈⢿⣿⣿⣿⡯⢬⣼⣁⠀⣧⢧⠀⠠⡇⠝⣿⡇⢻⣿⣿⣿⣿⣿⠃⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
                "⠀⠀⠀⠀⠀⠈⣿⣿⣿⡀⣀⣙⠋⠛⠷⣄⠀⢀⡇⠨⢃⣧⠚⠉⠙⣿⠿⠟⠀⢘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
                "⠀⠀⠀⠀⠀⠀⣿⢿⣿⡏⣙⣿⣷⣄⣢⡈⠁⠀⠀⠀⠀⠏⠠⠶⠷⠿⢶⣦⣄⡐⠟⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡘⠀"
                "⠀⠀⠀⠀⠀⠀⢻⠀⢻⡇⠘⠻⠿⠿⠿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣖⡀⠉⠛⠓⠦⣼⣿⠟⣿⣿⣿⣿⣿⣿⣿⠋⡈⣿⣿⣿⡇⠇"
                "⠀⠀⠀⠀⠀⠀⠘⠂⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⣷⣶⣤⣀⡀⢻⢓⣿⣿⣿⣿⣿⣿⣯⠞⣼⣿⣿⣿⡧"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠿⠿⠗⠛⠀⠀⠘⣿⣿⣿⣿⣿⡟⣀⣾⣿⣿⣿⠏⣿"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢧⡀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣭⣿⣿⣿⣿⣿⣿⡏⠀⠹"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢳⣄⠀⠀⠈⠓⢤⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⣿⣿⣿⣿⡟⠛⠛⠿⠋⡟"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣎⣴⣿⣿⣿⣿⣿⣦"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣦⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⡶⠟⡡⢼⣿⣿⣿⣿⣯⣿"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⢾⣿⣿⣿⡇⠑⢤⣀⠀⠀⠀⢀⡀⢠⣴⡮⠕⢋⡡⠔⠋⠀⣼⣿⣿⣿⣿⠿⢹⡙⢆"
                "⠀⠀⠀⠀⠀⢀⣠⢤⣶⣪⣿⣷⣿⣿⣿⡿⡇⠀⠀⠈⢫⡉⠉⠩⢉⣩⠤⠒⠊⠁⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣶⡀⠑⢄"
                "⠀⠀⢀⡤⠒⣉⣀⣾⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⣠⣾⣿⣿⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠑⣄"
                "⢀⣀⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣴⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠈⢢⡀"
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣼⠙"
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠈⠉⢀⣨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣢"
              ];
            }
            {
              type = "padding";
              val = 4;
            }
            {
              type = "button";
              val = "█";
            }
            {
              opts = {
                hl = "Todo";
                position = "center";
              };
              type = "text";
              val = "let's all love lain";
            }
          ];
        };
        direnv.enable = true;
        oil = {
          enable = true;
          settings = {
            keymaps = {
              "H" = "actions.parent";
              "Q" = "actions.close";
              "L" = "actions.select";
            };
            view_options = {
              show_hidden = true;
            };
          };
        };
        surround.enable = true;
        lastplace.enable = true;
        lsp-format.enable = true;
        conjure.enable = true;
        none-ls = {
          enable = true;
          sources = {
            formatting = {
              alejandra.enable = true;
              zprint.enable = true;
            };
            diagnostics = {
              statix.enable = true;
              clj_kondo.enable = true;
            };
          };
        };
        noice = {
          enable = true;
          lsp.override = {
            "cmp.entry.get_documentation" = true;
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          views = {
            cmdline_popup.border.style = "single";
            cmdline_popupmenu.border.style = "single";
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = false;
          };
        };
        neogit = {
          enable = true;
          settings.integrations.telescope = true;
        };
        lualine = {
          enable = true;
          disabledFiletypes.statusline = ["alpha" "trouble" "telescope" "oil" "toggleterm"];
          sectionSeparators = {
            left = "";
            right = "";
          };
          componentSeparators = {
            left = "";
            right = "";
          };
          sections = {
            lualine_a = [
              {name = "fancy_mode";}
            ];
            lualine_b = [
              {name = "fancy_branch";}
              {name = "fancy_diff";}
              {name = "fancy_diagnostics";}
            ];
            lualine_y = [
              {name = "fancy_filetype";}
            ];
            lualine_x = [
              {name = "fancy_macro";}
              {name = "fancy_lsp_servers";}
            ];
            lualine_z = [
              {name = "fancy_location";}
            ];
          };
        };
        luasnip.enable = true;
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>f";
              desc = "FILES";
            }
            {
              __unkeyed-1 = "<leader>g";
              desc = "GIT";
            }
            {
              __unkeyed-1 = "<leader>l";
              desc = "LSP";
            }
            {
              __unkeyed-1 = "<leader>w";
              desc = "WINDOW";
            }
          ];
        };
        treesitter = {
          enable = true;
          settings = {
            highlight.disable = ["zig"];
            incremental_selection = {
              enable = true;
              keymaps = {
                init_selection = "<C-SPACE>";
                node_incremental = "<C-SPACE>";
                node_decremental = "<BS>";
              };
            };
          };
        };
        treesitter-textobjects = {
          enable = true;
          lspInterop = {
            enable = true;
            peekDefinitionCode."gd" = queryDesc "@function.outer" "Hover definition";
          };
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "a=" = queryDesc "@assignment.outer" "Select outer part of an assignment";
              "i=" = queryDesc "@assignment.inner" "Select inner part of an assignment";
              "aj" = queryDesc "@assignment.lhs" "Select left hand side of an assignment";
              "ak" = queryDesc "@assignment.rhs" "Select right hand side of an assignment";
              "ai" = queryDesc "@conditional.outer" "Select outer part of a conditional";
              "ii" = queryDesc "@conditional.inner" "Select inner part of a conditional";
              "il" = queryDesc "@loop.inner" "Select inner part of a loop";
              "al" = queryDesc "@loop.outer" "Select outer part of a loop";
              "aa" = queryDesc "@parameter.outer" "Select outer part of a parameter";
              "ia" = queryDesc "@parameter.inner" "Select inner part of a parameter";
              "af" = queryDesc "@function.outer" "Select outer part of a function";
              "if" = queryDesc "@function.inner" "Select inner part of a function";
              "am" = queryDesc "@call.outer" "Select outer part of a method";
              "im" = queryDesc "@call.inner" "Select inner part of a method";
            };
          };
          move = {
            enable = true;
            setJumps = true;
            gotoNextStart = {
              "]f" = queryDesc "@function.outer" "Next function call start";
              "]m" = queryDesc "@call.outer" "Next method call start";
              "]l" = queryDesc "@loop.outer" "Next loop start";
              "]i" = queryDesc "@conditional.outer" "Next conditional start";
            };
            gotoPreviousStart = {
              "[f" = queryDesc "@function.outer" "Previous function call start";
              "[m" = queryDesc "@call.outer" "Previous method call start";
              "[l" = queryDesc "@loop.outer" "Previous loop start";
              "[i" = queryDesc "@conditional.outer" "Previous conditional start";
            };
            gotoPreviousEnd = {
              "[F" = queryDesc "@function.outer" "Previous function call end";
              "[M" = queryDesc "@call.outer" "Previous method call end";
              "[L" = queryDesc "@loop.outer" "Previous loop end";
              "[I" = queryDesc "@conditional.outer" "Previous conditional end";
            };
            gotoNextEnd = {
              "]M" = queryDesc "@call.outer" "Next method call end";
              "]F" = queryDesc "@function.outer" "Next function call end";
              "]L" = queryDesc "@loop.outer" "Next loop end";
              "]I" = queryDesc "@conditional.outer" "Next conditional end";
            };
          };
        };
        rainbow-delimiters.enable = true;
        cmp = {
          enable = true;
          settings = {
            sources = [
              {
                name = "nvim_lsp";
                keyword_length = 1;
              }
              {
                name = "path";
                keyword_length = 4;
              }
              {
                name = "buffer";
                keyword_length = 4;
              }
              {
                name = "luasnip";
                keyword_length = 2;
              }
            ];
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
              "<TAB>" = ''
                  cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require('luasnip').locally_jumpable(1) then
                    require('luasnip').jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
              "<S-TAB>" = ''
                  cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require('luasnip').locally_jumpable(-1) then
                    require('luasnip').jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
            };
          };
        };
        telescope = {
          enable = true;
          extensions.frecency = {
            enable = true;
            settings.db_validate_threshold = 200;
          };
          settings.defaults.mappings.i = {
            "<C-j>".__raw = "require('telescope.actions').move_selection_next";
            "<C-h>".__raw = "require('telescope.actions').close";
            "<C-l>".__raw = "require('telescope.actions').select_default";
            "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
          };
        };
      };
      keymaps = [
        {
          key = "<leader>fo";
          mode = "n";
          action = "<CMD>Telescope<CR>";
          options.desc = "Open Telescope";
        }
        {
          key = "<leader>ls";
          mode = "n";
          action = "<CMD>Telescope lsp_document_symbols<CR>";
          options.desc = "Document symbols";
        }
        {
          key = "<leader>la";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
          options.desc = "Show code actions";
        }
        {
          key = "<leader>lo";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.definition()<CR>";
          options.desc = "Goto definition";
        }
        {
          key = "<leader>lr";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.rename()<CR>";
          options.desc = "Rename symbol";
        }
        {
          key = "<leader>lg";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.setqflist()<CR>";
          options.desc = "Diagnostics qflist";
        }
        {
          key = "<leader>ld";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.open_float()<CR>";
          options.desc = "Hover diagnostics";
        }
        {
          key = "<leader>ln";
          mode = "n";
          action = "<CMD>Telescope diagnostics<CR>";
          options.desc = "List diagnostics";
        }
        {
          key = "<leader>li";
          mode = "n";
          action = "<CMD>Telescope lsp_implementations<CR>";
          options.desc = "Goto implementations";
        }
        {
          key = "<leader>le";
          mode = "n";
          action = "<CMD>Telescope lsp_references<CR>";
          options.desc = "List references";
        }
        {
          key = "<leader>b";
          mode = "n";
          action = "<CMD>lua require('buffer_manager.ui').toggle_quick_menu()<CR>";
          options.desc = "Popup buffers";
        }
        {
          key = "<C-k>";
          mode = "n";
          action = "<cmd>m .-2<cr>==";
          options.desc = "Move up";
        }
        {
          key = "<C-j>";
          mode = "n";
          action = "<cmd>m .+1<cr>==";
          options.desc = "Move down";
        }
        {
          key = "<C-j>";
          mode = "i";
          action = "<ESC><CMD>m .+1<cr>==gi";
          options.desc = "Move down";
        }
        {
          key = "<C-k>";
          mode = "i";
          action = "<ESC><CMD>m .-2<cr>==gi";
          options.desc = "Move up";
        }
        {
          key = "K";
          mode = ["x" "v"];
          action = ":move '<-2<CR>gv=gv";
          options.desc = "Move up";
        }
        {
          key = "==";
          mode = "n";
          action = "gg<S-v>G";
          options.desc = "Select all";
        }
        {
          key = "<";
          mode = "v";
          action = "<gv";
        }
        {
          key = ">";
          mode = "v";
          action = ">gv";
        }
        {
          key = "N";
          mode = ["n" "x" "o"];
          action = "Nzzzv";
        }
        {
          key = "n";
          mode = ["n" "x" "o"];
          action = "nzzzv";
        }
        {
          key = "<C-u>";
          mode = ["n" "x" "o"];
          action = "<C-u>zz";
        }
        {
          key = "<C-d>";
          mode = "n";
          action = "<C-d>zz";
        }
        {
          key = "p";
          mode = "v";
          action = "P";
        }
        {
          key = "<Up>";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {expr = true;};
        }
        {
          key = "<Down>";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {expr = true;};
        }
        {
          key = "k";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {expr = true;};
        }
        {
          key = "j";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {expr = true;};
        }
        {
          key = "J";
          mode = ["x" "v"];
          options.desc = "Move down";
          action = ":move '>+1<CR>gv=gv";
        }
        {
          key = "<leader>fc";
          mode = "n";
          action = "<CMD>Telescope grep_string<CR>";
          options.desc = "Find string under cursor";
        }
        {
          key = "<leader>ft";
          mode = "n";
          action = "<CMD>TodoTelescope<CR>";
          options.desc = "Todo Telescope";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<CMD>Telescope live_grep<CR>";
          options.desc = "Live grep";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<CMD>Telescope frecency<CR>";
          options.desc = "Frecency files";
        }
        {
          key = "<leader>fe";
          mode = "n";
          action = "<CMD>Telescope oldfiles<CR>";
          options.desc = "Recent files";
        }
        {
          key = "<leader>fu";
          mode = "n";
          action = "<CMD>Telescope colorscheme<CR>";
          options.desc = "Change colorscheme";
        }
        {
          key = "<leader>fp";
          mode = "n";
          action = "<CMD>Telescope git_files<CR>";
          options.desc = "Project files";
        }
        {
          key = "<leader>ff";
          mode = "n";
          action = "<CMD>Telescope fd<CR>";
          options.desc = "Find files";
        }
        {
          key = "<leader>fn";
          mode = "n";
          action = "<CMD>ene<CR>";
          options.desc = "New file";
        }
        {
          key = "<leader>o";
          mode = "n";
          action = "<CMD>lua require('oil').toggle_float()<CR>";
          options.desc = "Open oil";
        }
        {
          key = "]g";
          mode = "n";
          action = "<CMD>Gitsigns prev_hunk<CR>";
          options.desc = "Previous Git hunk";
        }
        {
          key = "[g";
          mode = "n";
          action = "<CMD>Gitsigns next_hunk<CR>";
          options.desc = "Next Git hunk";
        }
        {
          key = "<leader>gg";
          mode = "n";
          action = "<CMD>Neogit<CR>";
          options.desc = "Open Neogit";
        }
        {
          key = "<leader>gR";
          mode = "n";
          action = "<CMD>Gitsigns reset_buffer<CR>";
          options.desc = "Reset buffer";
        }
        {
          key = "<leader>gd";
          mode = "n";
          action = "<CMD>Gitsigns toggle_deleted<CR>";
          options.desc = "Toggle deleted";
        }
        {
          key = "<leader>gS";
          mode = ["v" "n"];
          action = "<CMD>Gitsigns stage_buffer<CR>";
          options.desc = "Stage buffer";
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<CMD>Gitsigns stage_hunk<CR>";
          options.desc = "Stage hunk";
        }
        {
          key = "<leader>gu";
          mode = "n";
          action = "<CMD>Gitsigns undo_stage_hunk<CR>";
          options.desc = "Unstage hunk";
        }
        {
          key = "<leader>gp";
          mode = "n";
          action = "<CMD>Gitsigns preview_hunk<CR>";
          options.desc = "Preview hunk";
        }
        {
          key = "<leader>gr";
          mode = ["v" "n"];
          action = "<CMD>Gitsigns reset_hunk<CR>";
          options.desc = "Reset hunk";
        }
        {
          key = "<leader>wv";
          mode = "n";
          action = "<C-w>v";
          options.desc = "Split window vertically";
        }
        {
          key = "[t";
          mode = ["n" "t"];
          action = "<CMD>tabp<CR>";
          options.desc = "Previous tab";
        }
        {
          key = "]t";
          mode = ["n" "t"];
          action = "<CMD>tabn<CR>";
          options.desc = "Next tab";
        }
        {
          key = "<leader>wd";
          mode = ["n" "t"];
          action = "<CMD>tabp<CR>";
          options.desc = "Previous tab";
        }
        {
          key = "<leader>wa";
          mode = ["n" "t"];
          action = "<CMD>tabn<CR>";
          options.desc = "Next tab";
        }
        {
          key = "<leader>wc";
          mode = "n";
          action = "<CMD>close!<CR>";
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
          action = "<CMD>tabnew<CR>";
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
          action = "<CMD>bd!<CR>";
          options.desc = "Close current tab";
        }
        {
          key = "<leader>wb";
          mode = "n";
          action = "<CMD>e #<CR>";
          options.desc = "Switch to other buffer";
        }
        {
          key = "[b";
          mode = "n";
          action = "<CMD>bprevious<CR>";
          options.desc = "Previous buffer";
        }
        {
          key = "]b";
          mode = "n";
          action = "<CMD>bnext<CR>";
          options.desc = "Next buffer";
        }
        {
          key = "]T";
          mode = "n";
          action = "<CMD>lua require('todo-comments').jump_next()<CR>";
          options.desc = "Next TODO";
        }
        {
          key = "[T";
          mode = "n";
          action = "<CMD>lua require('todo-comments').jump_prev()<CR>";
          options.desc = "Prev TODO";
        }
        {
          key = "<leader><leader>";
          mode = ["n" "v"];
          action = ":";
          options.desc = "Open cmdline";
        }
        {
          key = "<ESC>";
          mode = "n";
          action = "<CMD>noh<CR>";
          options.desc = "Clear highlights";
        }
        {
          key = "<leader>K";
          mode = "n";
          action = "<CMD>qa<CR>";
          options.desc = "Quit";
        }
        {
          key = "<leader>s";
          mode = "n";
          action = "<CMD>w<CR>";
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
          key = "<C-Right>";
          mode = "n";
          action = "<CMD>vertical resize +2<CR>";
          options.desc = "Resize pane right";
        }
        {
          key = "<C-Left>";
          mode = "n";
          action = "<CMD>vertical resize -2<CR>";
          options.desc = "Resize pane left";
        }
        {
          key = "<C-Up>";
          mode = "n";
          action = "<CMD>resize +2<CR>";
          options.desc = "Resize pane up";
        }
        {
          key = "<C-Down>";
          mode = "n";
          action = "<CMD>resize -2<CR>";
          options.desc = "Resize pane down";
        }
        {
          key = "<C-j>";
          mode = "c";
          action = "<C-n>";
        }
        {
          key = "<C-l>";
          mode = "c";
          action = "<CR>";
        }
        {
          key = "<C-h>";
          mode = "c";
          action = "<ESC>";
        }
        {
          key = "<C-k>";
          mode = "c";
          action = "<C-p>";
        }
        {
          key = "]q";
          mode = "n";
          action = "<CMD>cnext<CR>";
          options.desc = "Next quickfix";
        }
        {
          key = "[q";
          mode = "n";
          action = "<CMD>cprev<CR>";
          options.desc = "Prev quickfix";
        }
        {
          key = "<leader>v";
          mode = ["n" "t"];
          action = "<CMD>1ToggleTerm direction=float name=はい <CR>";
          options.desc = "Open terminal";
        }
        {
          key = "<leader>.";
          mode = ["n" "v"];
          action = "~";
          options.desc = "Change case";
        }
        {
          key = "<C-BS>";
          mode = ["n" "i" "c"];
          action = "<C-w>";
          options.desc = "Ctrl+Backspace to delete word";
        }
      ];
    };
  };
}
