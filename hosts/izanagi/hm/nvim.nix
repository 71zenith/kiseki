{
  inputs,
  config,
  pkgs,
  ...
}: let
  plugins = import ../../../pkgs/plugins-nvim.nix {inherit pkgs;};
in {
  imports = [
    ../../../modules/hm/neovide.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs = {
    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = ["${config.stylix.fonts.monospace.name}"];
          size = 21;
        };
      };
    };
    nixvim = {
      enable = true;
      luaLoader.enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      colorschemes.oxocarbon.enable = true;
      extraConfigLuaPre = ''
        local luasnip = require("luasnip")
        local tele = require("telescope.actions")
      '';
      extraConfigLuaPost = ''
        require("buffer_manager").setup({
          focus_alternate_buffer = true,
        })
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
          'confirm_done',
          cmp_autopairs.on_confirm_done())
      '';
      globals = {
        mapleader = " ";
        maplocalleader = ",";
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
        formatoptions = "jcroqlnt";
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
      extraPlugins = with plugins // pkgs.vimPlugins; [lualine-so-fancy buffer-manager];
      plugins = {
        nix.enable = true;
        hop.enable = true;
        nvim-autopairs = {
          enable = true;
          settings.check_ts = true;
        };
        nvim-bqf.enable = true;
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
        flash.enable = true;
        neorg = {
          enable = true;
          modules = {
            "core.defaults" = {
              __empty = null;
            };
            "core.concealer" = {
              __empty = null;
            };
            "core.dirman" = {
              config = {
                workspaces = {
                  notes = "~/notes";
                };
                default_workspace = "notes";
              };
            };
            "core.completion" = {
              config = {
                engine = "nvim-cmp";
                name = "Neorg";
              };
            };
          };
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
            nil_ls.enable = true;
            bashls.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            pyright.enable = true;
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
        harpoon.enable = true;
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
        conjure.enable = true;
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
        cmp-buffer.enable = true;
        diffview.enable = true;
        cmp-nvim-lsp.enable = true;
        surround.enable = true;
        lastplace.enable = true;
        better-escape.enable = true;
        lspkind.enable = true;
        lsp-format.enable = true;
        friendly-snippets.enable = true;
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
          settings = {
            integrations.diffview = true;
            integrations.telescope = true;
            commit_editor.kind = "floating";
            commit_popup.kind = "floating";
            preview_buffer.kind = "floating";
            popup.kind = "floating";
            log_view.kind = "floating";
            description_editor.kind = "floating";
          };
        };
        lualine = {
          enable = true;
          disabledFiletypes.statusline = ["alpha" "trouble" "telescope" "oil"];
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
          registrations = {
            "<leader>f" = "FILES";
            "<leader>l" = "LSP";
            "<leader>g" = "GIT";
            "<leader>w" = "WINDOW";
            "<leader>j" = "HARPOON";
          };
        };
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
          lspInterop = {
            enable = true;
            peekDefinitionCode = {
              "gD" = {
                query = "@function.outer";
                desc = "Hover [d]efinition";
              };
            };
          };
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "a=" = {
                query = "@assignment.outer";
                desc = "Select outer part of an assignment";
              };
              "i=" = {
                query = "@assignment.inner";
                desc = "Select inner part of an assignment";
              };
              "ll" = {
                query = "@assignment.lhs";
                desc = "Select left hand side of an assignment";
              };
              "rl" = {
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
              "am" = {
                query = "@call.outer";
                desc = "Select outer part of a method";
              };
              "im" = {
                query = "@call.inner";
                desc = "Select inner part of a method";
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
              "]m" = {
                query = "@call.outer";
                desc = "Next method call start";
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
              "[m" = {
                query = "@call.outer";
                desc = "Previous method call start";
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
              "[M" = {
                query = "@call.outer";
                desc = "Previous method call end";
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
              "]M" = {
                query = "@call.outer";
                desc = "Next method call end";
              };
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
        cmp = {
          enable = true;
          settings = {
            sources = [
              {
                name = "nvim_lsp";
                keyword_length = 1;
              }
              {
                name = "neorg";
                keyword_length = 1;
              }
              {
                name = "path";
                keyword_length = 4;
              }
              {
                name = "buffer";
                keyword_length = 3;
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
                  elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
              "<S-TAB>" = ''
                  cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
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
            frecency.enable = true;
            frecency.settings.db_validate_threshold = 50;
          };
          settings = {
            defaults = {
              mappings = {
                i = {
                  "<C-j>" = {
                    __raw = "tele.move_selection_next";
                  };
                  "<C-h>" = {
                    __raw = "tele.close";
                  };
                  "<C-l>" = {
                    __raw = "tele.select_default";
                  };
                  "<C-k>" = {
                    __raw = "tele.move_selection_previous";
                  };
                };
              };
            };
          };
        };
      };
      keymaps = [
        {
          key = "<leader>fo";
          mode = "n";
          action = "<CMD>Telescope<CR>";
          options.desc = "[O]pen Telescope";
        }
        {
          key = "<leader>ls";
          mode = "n";
          action = "<CMD>Telescope lsp_document_symbols<CR>";
          options.desc = "Document [s]ymbols";
        }
        {
          key = "<leader>la";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
          options.desc = "Show code [a]ctions";
        }
        {
          key = "<leader>lr";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.rename()<CR>";
          options.desc = "[R]ename symbol";
        }
        {
          key = "<leader>lg";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.setloclist()<CR>";
          options.desc = "Dia[g]nostics loclist";
        }
        {
          key = "K";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.hover()<CR>";
          options.desc = "Show hover docs";
        }
        {
          key = "<leader>ld";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.open_float()<CR>";
          options.desc = "Hover [d]iagnostics";
        }
        {
          key = "[d";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.goto_prev()<CR>";
          options.desc = "Goto prev diagnostic";
        }
        {
          key = "]d";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.goto_next()<CR>";
          options.desc = "Goto next diagnostic";
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
          options.desc = "Goto [i]mplementations";
        }
        {
          key = "<leader>le";
          mode = "n";
          action = "<CMD>Telescope lsp_references<CR>";
          options.desc = "List r[e]ferences";
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
          options.desc = "Find string under [c]ursor";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<CMD>Telescope live_grep<CR>";
          options.desc = "Live [g]rep";
        }
        {
          key = "<leader>fe";
          mode = "n";
          action = "<CMD>Telescope frecency<CR>";
          options.desc = "Fr[e]cency files";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<CMD>Telescope oldfiles<CR>";
          options.desc = "[R]ecent files";
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
          options.desc = "Find [f]iles";
        }
        {
          key = "<leader>fn";
          mode = "n";
          action = "<CMD>ene<CR>";
          options.desc = "[N]ew file";
        }
        {
          key = "<leader>o";
          mode = "n";
          action = "<CMD>lua require('oil').toggle_float()<CR>";
          options.desc = "Open [o]il";
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
          options.desc = "Open Neo[g]it";
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
          options.desc = "[S]tage buffer";
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<CMD>Gitsigns stage_hunk<CR>";
          options.desc = "[S]tage hunk";
        }
        {
          key = "<leader>gu";
          mode = "n";
          action = "<CMD>Gitsigns undo_stage_hunk<CR>";
          options.desc = "[U]nstage hunk";
        }
        {
          key = "<leader>gp";
          mode = "n";
          action = "<CMD>Gitsigns preview_hunk<CR>";
          options.desc = "[P]review hunk";
        }
        {
          key = "<leader>gr";
          mode = ["v" "n"];
          action = "<CMD>Gitsigns reset_hunk<CR>";
          options.desc = "[R]eset hunk";
        }
        {
          key = "<leader>wv";
          mode = "n";
          action = "<C-w>v";
          options.desc = "Split window [v]ertically";
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
          options.desc = "Close [c]urrent split";
        }
        {
          key = "<leader>wh";
          mode = "n";
          action = "<C-w>s";
          options.desc = "Split window [h]orizontally";
        }
        {
          key = "<leader>wn";
          mode = "n";
          action = "<CMD>tabnew<CR>";
          options.desc = "Open [n]ew tab";
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
          key = "<leader>rs";
          mode = ["v" "n"];
          action = "<CMD>SnipClose<CR>";
          options.desc = "Close code output";
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
          key = "<leader>jo";
          mode = "n";
          action = "<CMD>lua require('harpoon.mark').add_file()<CR>";
          options.desc = "Add file to harpoon";
        }
        {
          key = "<leader>ja";
          mode = "n";
          action = "<CMD>lua require('harpoon.ui').nav_prev()<CR>";
          options.desc = "Harpoon prev";
        }
        {
          key = "<leader>js";
          mode = "n";
          action = "<CMD>lua require('harpoon.ui').nav_next()<CR>";
          options.desc = "Harpoon next";
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
          key = "<leader>jj";
          mode = "n";
          action = "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>";
          options.desc = "Harpoon menu";
        }
        {
          key = "<leader>ap";
          mode = "n";
          action = "<CMD>HopPattern<CR>";
          options.desc = "Jump to [p]attern";
        }
        {
          key = "<leader>aa";
          mode = "n";
          action = "<CMD>HopPatternCurrentLine<CR>";
          options.desc = "Jump to pattern in current line";
        }
        {
          key = "<leader>al";
          mode = "n";
          action = "<CMD>HopLineStart<CR>";
          options.desc = "Jump to [l]ine";
        }
        {
          key = "<leader>as";
          mode = "n";
          action = "<CMD>HopCamelCaseCurrentLine<CR>";
          options.desc = "Jump to word in current line";
        }
        {
          key = "<leader>aw";
          mode = "n";
          action = "<CMD>HopWord<CR>";
          options.desc = "Jump to [w]ord";
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
