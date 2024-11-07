{
  inputs,
  config,
  pkgs,
  ...
}: let
  plugins = import ../pkgs/plugins-nvim.nix {inherit pkgs;};
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
        require("supermaven-nvim").setup({})
      '';
      extraConfigLuaPost = ''
        require("cmp").event:on(
          'confirm_done',
          require("nvim-autopairs.completion.cmp").on_confirm_done())
      '';
      # HACK: till upstream fix arrives
      highlight = with config.lib.stylix.colors.withHashtag; {
        WinBar.bg = base00;
        WinBarNC.bg = base00;
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
        neovide_transparency = config.stylix.opacity.terminal;
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
      extraPlugins = with plugins // pkgs.vimPlugins; [satellite-nvim lualine-so-fancy buffer-manager supermaven-nvim];
      plugins = {
        nix.enable = false;
        nvim-bqf.enable = true;
        nvim-autopairs.enable = true;
        todo-comments.enable = true;
        barbecue = {
          enable = true;
          settings = {
            lead_custom_section = ''
              function()
                return {{" ","WinBar"}}
              end
            '';
          };
        };
        dressing.enable = true;
        web-devicons.enable = true;
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
            nil_ls = {
              enable = true;
              settings.nix.flake = {
                autoArchive = true;
                nixpkgsInputName = "nixos";
              };
            };
            texlab.enable = true;
            bashls.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
              settings.check.command = "clippy";
            };
            pyright.enable = true;
            zls.enable = true;
            ruff_lsp.enable = true;
          };
        };
        zig = {
          enable = true;
          settings = {
            fmt_autosave = 0;
          };
        };
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = true;
          };
        };
        cursorline = {
          enable = true;
          cursorword.hl = {
            bold = true;
            underline = false;
          };
        };
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
        vim-surround.enable = true;
        lastplace.enable = true;
        lsp-format.enable = true;
        none-ls = {
          enable = true;
          sources = {
            formatting = {
              alejandra.enable = true;
              black.enable = true;
            };
            diagnostics = {
              statix.enable = true;
            };
          };
        };
        noice = {
          enable = true;
          settings = {
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
        };
        neogit = {
          enable = true;
          settings.integrations.telescope = true;
        };
        lualine = {
          enable = true;
          settings = {
            options = {
              disabled_filetypes = ["alpha" "trouble" "telescope" "oil" "toggleterm"];
              section_separators = {
                left = "";
                right = "";
              };
              component_separators = {
                left = "";
                right = "";
              };
            };
            sections = {
              lualine_a = ["fancy_mode"];
              lualine_b = ["fancy_branch" "fancy_diff" "fancy_diagnostics"];
              lualine_x = ["fancy_macro" "fancy_lsp_servers"];
              lualine_y = ["fancy_filetype"];
              lualine_z = ["fancy_searchcount" "fancy_location"];
            };
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
            highlight.enable = true;
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
        treesitter-textobjects = let
          queryDesc = query: desc: {inherit query desc;};
        in {
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
                name = "supermaven";
                keyword_length = 1;
              }
              {
                name = "nvim_lsp";
                keyword_length = 2;
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
          extensions = {
            frecency = {
              enable = true;
              settings.db_validate_threshold = 200;
            };
            fzf-native.enable = true;
          };
          settings.defaults.mappings.i = {
            "<C-j>".__raw = "require('telescope.actions').move_selection_next";
            "<C-h>".__raw = "require('telescope.actions').close";
            "<C-l>".__raw = "require('telescope.actions').select_default";
            "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
          };
        };
      };
      keymaps = let
        mkKeymap = key: mode: action: {inherit key mode action;};
        mkKeymapDesc = key: mode: action: desc: (mkKeymap key mode action) // {options = {inherit desc;};};
        mkKeymapOpt = key: mode: action: opt: (mkKeymap key mode action) // {options = opt;};
      in [
        (mkKeymapDesc "<leader>la" "n" "<CMD>lua vim.lsp.buf.code_action()<CR>" "Show code actions")
        (mkKeymapDesc "<leader>lo" "n" "<CMD>lua vim.lsp.buf.definition()<CR>" "Goto definition")
        (mkKeymapDesc "<leader>lr" "n" "<CMD>lua vim.lsp.buf.rename()<CR>" "Rename symbol")
        (mkKeymapDesc "<leader>lg" "n" "<CMD>lua vim.diagnostic.setqflist()<CR>" "Diagnostics qflist")
        (mkKeymapDesc "<leader>ld" "n" "<CMD>lua vim.diagnostic.open_float()<CR>" "Hover diagnostics")

        (mkKeymapDesc "<leader>fo" "n" "<CMD>Telescope<CR>" "Open Telescope")
        (mkKeymapDesc "<leader>ls" "n" "<CMD>Telescope lsp_document_symbols<CR>" "Document symbols")
        (mkKeymapDesc "<leader>ln" "n" "<CMD>Telescope diagnostics<CR>" "List diagnostics")
        (mkKeymapDesc "<leader>li" "n" "<CMD>Telescope lsp_implementations<CR>" "Goto implementations")
        (mkKeymapDesc "<leader>le" "n" "<CMD>Telescope lsp_references<CR>" "List references")
        (mkKeymapDesc "<leader>b" "n" "<CMD>lua require('buffer_manager.ui').toggle_quick_menu()<CR>" "Popup buffers")

        (mkKeymapDesc "<leader>fn" "n" "<CMD>ene<CR>" "New file")
        (mkKeymapDesc "<leader>o" "n" "<CMD>lua require('oil').toggle_float()<CR>" "Open oil")
        (mkKeymapDesc "<C-k>" "n" "<cmd>m .-2<cr>==" "Move up")
        (mkKeymapDesc "<C-j>" "n" "<cmd>m .+1<cr>==" "Move down")
        (mkKeymapDesc "<C-j>" "i" "<ESC><CMD>m .+1<cr>==gi" "Move down")
        (mkKeymapDesc "<C-k>" "i" "<ESC><CMD>m .-2<cr>==gi" "Move up")
        (mkKeymapDesc "K" ["x" "v"] ":move '<-2<CR>gv=gv" "Move up")
        (mkKeymapDesc "==" "n" "gg<S-v>G" "Select all")
        (mkKeymapDesc "<" "v" "<gv" "Decrease indent")
        (mkKeymapDesc ">" "v" ">gv" "Increase indent")

        (mkKeymap "N" ["n" "x" "o"] "Nzzzv")
        (mkKeymap "n" ["n" "x" "o"] "nzzzv")
        (mkKeymap "<C-u>" ["n" "x" "o"] "<C-u>zz")
        (mkKeymap "<C-d>" "n" "<C-d>zz")
        (mkKeymap "p" "v" "P")

        (mkKeymapOpt "<Up>" ["n" "x"] "v:count == 0 ? 'gk' : 'k'" {expr = true;})
        (mkKeymapOpt "<Down>" ["n" "x"] "v:count == 0 ? 'gj' : 'j'" {expr = true;})
        (mkKeymapOpt "k" ["n" "x"] "v:count == 0 ? 'gk' : 'k'" {expr = true;})
        (mkKeymapOpt "j" ["n" "x"] "v:count == 0 ? 'gj' : 'j'" {expr = true;})

        (mkKeymapDesc "J" ["x" "v"] ":move '>+1<CR>gv=gv" "Move down")
        (mkKeymapDesc "<leader>fc" "n" "<CMD>Telescope grep_string<CR>" "Find string under cursor")
        (mkKeymapDesc "<leader>ft" "n" "<CMD>TodoTelescope<CR>" "Todo Telescope")
        (mkKeymapDesc "<leader>fg" "n" "<CMD>Telescope live_grep<CR>" "Live grep")
        (mkKeymapDesc "<leader>fr" "n" "<CMD>Telescope frecency<CR>" "Frecency files")
        (mkKeymapDesc "<leader>fe" "n" "<CMD>Telescope oldfiles<CR>" "Recent files")
        (mkKeymapDesc "<leader>fu" "n" "<CMD>Telescope colorscheme<CR>" "Change colorscheme")
        (mkKeymapDesc "<leader>fp" "n" "<CMD>Telescope git_files<CR>" "Project files")
        (mkKeymapDesc "<leader>ff" "n" "<CMD>Telescope fd<CR>" "Find files")

        (mkKeymapDesc "]g" "n" "<CMD>Gitsigns prev_hunk<CR>" "Previous Git hunk")
        (mkKeymapDesc "[g" "n" "<CMD>Gitsigns next_hunk<CR>" "Next Git hunk")
        (mkKeymapDesc "<leader>gg" "n" "<CMD>Neogit<CR>" "Open Neogit")
        (mkKeymapDesc "<leader>gR" "n" "<CMD>Gitsigns reset_buffer<CR>" "Reset buffer")
        (mkKeymapDesc "<leader>gd" "n" "<CMD>Gitsigns toggle_deleted<CR>" "Toggle deleted")
        (mkKeymapDesc "<leader>gS" ["n" "v"] "<CMD>Gitsigns stage_buffer<CR>" "Stage buffer")
        (mkKeymapDesc "<leader>gs" "n" "<CMD>Gitsigns stage_hunk<CR>" "Stage hunk")
        (mkKeymapDesc "<leader>gu" "n" "<CMD>Gitsigns undo_stage_hunk<CR>" "Unstage hunk")
        (mkKeymapDesc "<leader>gp" "n" "<CMD>Gitsigns preview_hunk<CR>" "Preview hunk")
        (mkKeymapDesc "<leader>gr" ["n" "v"] "<CMD>Gitsigns reset_hunk<CR>" "Reset hunk")

        (mkKeymapDesc "<leader>wv" "n" "<C-w>v" "Split window vertically")
        (mkKeymapDesc "[t" ["n" "t"] "<CMD>tabp<CR>" "Previous tab")
        (mkKeymapDesc "]t" ["n" "t"] "<CMD>tabn<CR>" "Next tab")
        (mkKeymapDesc "<leader>wd" ["n" "t"] "<CMD>tabp<CR>" "Previous tab")
        (mkKeymapDesc "<leader>wa" ["n" "t"] "<CMD>tabn<CR>" "Next tab")
        (mkKeymapDesc "<leader>wc" "n" "<CMD>close!<CR>" "Close current split")
        (mkKeymapDesc "<leader>wh" "n" "<C-w>s" "Split window horizontally")
        (mkKeymapDesc "<leader>wn" "n" "<CMD>tabnew<CR>" "Open new tab")
        (mkKeymapDesc "<leader>wk" "n" "<CMD>bd!<CR>" "Close current tab")
        (mkKeymapDesc "<leader>wb" "n" "<CMD>e #<CR>" "Switch to other buffer")
        (mkKeymapDesc "[b" "n" "<CMD>bprevious<CR>" "Previous buffer")
        (mkKeymapDesc "]b" "n" "<CMD>bnext<CR>" "Next buffer")

        (mkKeymapDesc "<C-h>" "n" "<C-w>h" "Navigate to pane left")
        (mkKeymapDesc "<C-l>" "n" "<C-w>l" "Navigate to pane right")
        (mkKeymapDesc "<C-k>" "n" "<C-w>k" "Navigate to pane up")
        (mkKeymapDesc "<C-j>" "n" "<C-w>j" "Navigate to pane down")
        (mkKeymapDesc "<C-Right>" "n" "<CMD>vertical resize +2<CR>" "Resize pane right")
        (mkKeymapDesc "<C-Left>" "n" "<CMD>vertical resize -2<CR>" "Resize pane left")
        (mkKeymapDesc "<C-Up>" "n" "<CMD>resize +2<CR>" "Resize pane up")
        (mkKeymapDesc "<C-Down>" "n" "<CMD>resize -2<CR>" "Resize pane down")

        (mkKeymapDesc "<leader>-" "n" "<C-x>" "Decrement number")
        (mkKeymapDesc "<leader>+" "n" "<C-a>" "Increment number")
        (mkKeymapDesc "]T" "n" "<CMD>lua require('todo-comments').jump_next()<CR>" "Next TODO")
        (mkKeymapDesc "[T" "n" "<CMD>lua require('todo-comments').jump_prev()<CR>" "Prev TODO")
        (mkKeymapDesc "<leader><leader>" ["n" "v"] ":" "Open cmdline")
        (mkKeymapDesc "<ESC>" "n" "<CMD>noh<CR>" "Clear highlights")
        (mkKeymapDesc "<leader>K" "n" "<CMD>qa<CR>" "Quit")
        (mkKeymapDesc "<leader>s" "n" "<CMD>w<CR>" "Save Buffer")

        (mkKeymap "<C-j>" "c" "<C-n>")
        (mkKeymap "<C-l>" "c" "<CR>")
        (mkKeymap "<C-h>" "c" "<ESC>")
        (mkKeymap "<C-k>" "c" "<C-p>")

        (mkKeymapDesc "]q" "n" "<CMD>cnext<CR>" "Next quickfix")
        (mkKeymapDesc "[q" "n" "<CMD>cprev<CR>" "Prev quickfix")
        (mkKeymapDesc "<leader>v" ["n" "t"] "<CMD>1ToggleTerm direction=float name=はい <CR>" "Open terminal")
        (mkKeymapDesc "<leader>." ["n" "v"] "~" "Change case")
        (mkKeymapDesc "<C-BS>" ["n" "i" "c"] "<C-w>" "Ctrl+Backspace to delete word")
      ];
    };
  };
}
