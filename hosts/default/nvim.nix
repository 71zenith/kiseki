{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs = {
    nixvim = {
      enable = true;
      luaLoader.enable = true;
      colorschemes.oxocarbon.enable = true;
      extraConfigLuaPre = ''
        local tele = require("telescope.actions")
      '';
      globals = {
        mapleader = " ";
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
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        autoindent = true;
        autoread = true;
        history = 10000;
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
        wildmode = ["longest" "list" "full"];
        mouse = "a";
        smartcase = true;
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
        spell = true;
        spelllang = ["en_us"];
        concealcursor = "nc";
        autowrite = true;
        pumheight = 10;
        updatetime = 200;
        showbreak = "⤷ ";
      };
      extraPlugins = with pkgs.vimPlugins; [dressing-nvim];
      plugins = {
        nix.enable = true;
        barbar = {
          enable = true;
          autoHide = true;
        };
        hop.enable = true;
        nvim-autopairs = {
          enable = true;
          settings.check_ts = true;
        };
        toggleterm = {
          enable = true;
          direction = "float";
        };
        nvim-bqf.enable = true;
        comment.enable = true;
        todo-comments.enable = true;
        project-nvim = {
          enable = true;
          enableTelescope = true;
          showHidden = true;
        };
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
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = true;
          };
        };
        undotree.enable = true;
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
                "⠀⠀⣿⢷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄"
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
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆"
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠈⠉⢀⣨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣢"
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
        trouble.enable = true;
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
        cmp-buffer.enable = true;
        diffview.enable = true;
        cmp-spell.enable = true;
        cmp-nvim-lsp.enable = true;
        surround.enable = true;
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
        neogit.enable = true;
        lualine = {
          enable = true;
          disabledFiletypes.statusline = ["alpha" "toggleterm" "trouble"];
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
              {
                name = "mode";
                fmt = ''
                  function()
                    return " "
                  end
                '';
              }
            ];
            lualine_b = [
              {
                name = "branch";
                icon = "";
              }
              {name = "diff";}
              {name = "diagnostics";}
            ];
            lualine_x = [
              {
                name = "encoding";
                icon = "";
                fmt = ''
                  function()
                      local msg = ""
                      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                      local clients = vim.lsp.get_active_clients()
                      if next(clients) == nil then
                        return msg
                      end
                      for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                          msg = msg .. client.name .. " "
                        end
                      end
                      return msg:sub(1,-2)
                    end
                '';
              }
              {name = "filetype";}
            ];
          };
        };
        luasnip.enable = true;
        cmp_luasnip.enable = true;
        which-key = {
          enable = true;
          registrations = {
            "<leader>f" = "FILES";
            "<leader>l" = "LSP";
            "<leader>g" = "GIT";
            "<leader>w" = "WINDOW";
            "<leader>r" = "SNIPRUN";
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
              "<leader>ld" = {
                query = "@function.outer";
                desc = "Hover definition";
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
          swap = {
            enable = true;
            swapNext = {
              "<leader>af" = "@function.outer";
            };
            swapPrevious = {
              "<leader>bf" = "@function.outer";
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
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<TAB>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };
        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
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
          action = "<CMD>Telescope<NL>";
          options.desc = "Open Telescope";
        }
        {
          key = "<leader>ls";
          mode = "n";
          action = "<CMD>Telescope lsp_document_symbols<NL>";
          options.desc = "Document symbols";
        }
        {
          key = "<leader>la";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.code_action()<NL>";
          options.desc = "Show code actions";
        }
        {
          key = "<leader>lr";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.rename()<NL>";
          options.desc = "Rename symbol";
        }
        {
          key = "<leader>lg";
          mode = "n";
          action = "<CMD>TroubleToggle<NL>";
          options.desc = "Trouble toggle";
        }
        {
          key = "<leader>lt";
          mode = "n";
          action = "<CMD>Telescope lsp_type_definitions<NL>";
          options.desc = "Show type definitions";
        }
        {
          key = "<C-k>";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.signature_help()<NL>";
          options.desc = "Show signature help";
        }
        {
          key = "K";
          mode = "n";
          action = "<CMD>lua vim.lsp.buf.hover()<NL>";
          options.desc = "Show hover docs";
        }
        {
          key = "[d";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.goto_prev()<NL>";
          options.desc = "Goto prev diagnostic";
        }
        {
          key = "]d";
          mode = "n";
          action = "<CMD>lua vim.diagnostic.goto_next()<NL>";
          options.desc = "Goto next diagnostic";
        }
        {
          key = "<leader>li";
          mode = "n";
          action = "<CMD>Telescope lsp_implementations<NL>";
          options.desc = "Goto implementations";
        }
        {
          key = "<leader>lD";
          mode = "n";
          action = "<CMD>Telescope lsp_definitions<NL>";
          options.desc = "Goto definitions";
        }
        {
          key = "<leader>lw";
          mode = "n";
          action = "<CMD>Telescope lsp_references<NL>";
          options.desc = "List references";
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
          options.desc = "Select all";
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
          key = "J";
          mode = "x";
          options.desc = "Move selected lines down";
          action = ":move '>+1<CR>gv-gv";
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
          key = "<leader>fr";
          mode = "n";
          action = "<CMD>Telescope oldfiles<NL>";
          options.desc = "Recent files";
        }
        {
          key = "<leader>fu";
          mode = "n";
          action = "<CMD>Telescope colorscheme<NL>";
          options.desc = "Change colorscheme";
        }
        {
          key = "<leader>pf";
          mode = "n";
          action = "<CMD>Telescope git_files<NL>";
          options.desc = "Find file in project";
        }
        {
          key = "<leader>pp";
          mode = "n";
          action = "<CMD>Telescope projects<NL>";
          options.desc = "Find projects";
        }
        {
          key = "<leader>ff";
          mode = "n";
          action = "<CMD>Telescope fd<NL>";
          options.desc = "Find files";
        }
        {
          key = "<leader>fn";
          mode = "n";
          action = "<CMD>ene<NL>";
          options.desc = "New file";
        }
        {
          key = "<leader>o";
          mode = "n";
          action = "<CMD>lua require('oil').toggle_float()<NL>";
          options.desc = "Open oil";
        }
        {
          key = "<leader>n";
          mode = ["n" "t"];
          action = "<CMD>ToggleTerm<NL>";
          options.desc = "Open terminal";
        }
        {
          key = "]g";
          mode = "n";
          action = "<CMD>Gitsigns prev_hunk<NL>";
          options.desc = "Previous Git hunk";
        }
        {
          key = "[g";
          mode = "n";
          action = "<CMD>Gitsigns next_hunk<NL>";
          options.desc = "Next Git hunk";
        }
        {
          key = "<leader>gg";
          mode = "n";
          action = "<CMD>Neogit<NL>";
          options.desc = "Open Neogit";
        }
        {
          key = "<leader>gS";
          mode = ["v" "n"];
          action = "<CMD>Gitsigns stage_buffer<NL>";
          options.desc = "Stage buffer";
        }
        {
          key = "<leader>gs";
          mode = ["v" "n"];
          action = "<CMD>Gitsigns stage_hunk<NL>";
          options.desc = "Stage hunk";
        }
        {
          key = "<leader>gu";
          mode = "n";
          action = "<CMD>Gitsigns undo_stage_hunk<NL>";
          options.desc = "Unstage hunk";
        }
        {
          key = "<leader>gp";
          mode = "n";
          action = "<CMD>Gitsigns preview_hunk<NL>";
          options.desc = "Preview hunk";
        }
        {
          key = "<leader>gr";
          mode = "n";
          action = "<CMD>Gitsigns reset_hunk<NL>";
          options.desc = "Reset hunk";
        }
        {
          key = "<leader>wv";
          mode = "n";
          action = "<C-w>v";
          options.desc = "Split window vertically";
        }
        {
          key = "<leader>wd";
          mode = "n";
          action = "<CMD>tabp<NL>";
          options.desc = "Previous tab";
        }
        {
          key = "<leader>wa";
          mode = "n";
          action = "<CMD>tabn<NL>";
          options.desc = "Next tab";
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
          action = "<CMD>bnext<NL>";
          options.desc = "Next buffer";
        }
        {
          key = "<leader>rs";
          mode = ["v" "n"];
          action = "<CMD>SnipClose<NL>";
          options.desc = "Close code output";
        }
        {
          key = "<leader>ra";
          mode = "n";
          action = "<CMD>SnipRun<NL>";
          options.desc = "Run code";
        }
        {
          key = "<leader>rr";
          mode = ["n" "v"];
          action = "<CMD>:lua require'sniprun'.run('v')<NL>";
          options.desc = "Run selected code";
        }
        {
          key = "<leader><leader>";
          mode = ["n" "v"];
          action = ":";
          options.desc = "Open cmdline";
        }
        {
          key = "<S-Tab>";
          mode = "n";
          action = "<CMD>bprevious<NL>";
          options.desc = "Previous Buffer";
        }
        {
          key = "<ESC>";
          mode = "n";
          action = "<CMD>noh<NL>";
          options.desc = "Clear Highlights";
        }
        {
          key = "<leader>K";
          mode = "n";
          action = "<CMD>qa<NL>";
          options.desc = "Quit";
        }
        {
          key = "<leader>s";
          mode = "n";
          action = "<CMD>w<NL>";
          options.desc = "Save Buffer";
        }
        {
          key = "<C-h>";
          mode = "n";
          action = "<C-w>g";
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
          action = "<CMD>vertical resize +2<NL>";
          options.desc = "Resize pane right";
        }
        {
          key = "<C-S-h>";
          mode = "n";
          action = "<CMD>vertical resize -2<NL>";
          options.desc = "Resize pane left";
        }
        {
          key = "<C-S-k>";
          mode = "n";
          action = "<CMD>resize +2<NL>";
          options.desc = "Resize pane up";
        }
        {
          key = "<C-S-j>";
          mode = "n";
          action = "<CMD>resize -2<NL>";
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
          action = "<Esc>";
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
          key = "<leader>jj";
          mode = "n";
          action = "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>";
          options.desc = "Harpoon menu";
        }
        {
          key = "<leader>ap";
          mode = "n";
          action = "<CMD>HopPattern<CR>";
          options.desc = "Jump to pattern";
        }
        {
          key = "<leader>aa";
          mode = "n";
          action = "<CMD>HopPatternCurrentLine<CR>";
          options.desc = "Jump to pattern in current line";
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
          options.desc = "Jump to word";
        }
        {
          key = "<leader>al";
          mode = "n";
          action = "<CMD>HopLineStart<CR>";
          options.desc = "Jump to line";
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
