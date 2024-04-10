{inputs, pkgs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs = {
    nixvim = {
      enable = true;
      globals = {
        mapleader = " ";
        neovide_cursor_animation_length = 0.025;
        neovide_cursor_vfx_mode = "railgun";
        neovide_background_color = "#1e1e2ed9";
        neovide_refresh_rate = 75;
        neovide_transparency = 0.0;
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
        smartcase = true;
        cursorline = true;
        termguicolors = true;
        background = "dark";
        signcolumn = "yes";
        backspace = "indent,eol,start";
        splitright = true;
        splitbelow = true;
        swapfile = false;
        clipboard = "unnamedplus";
      };
      extraPlugins = with pkgs; [ vimPlugins.oxocarbon-nvim ];
      colorscheme = "oxocarbon";
      plugins = {
        nix.enable = true;
        bufferline.enable = true;
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
        barbecue.enable = true;
        lsp = {
          enable = true;
          servers = {nil_ls.enable = true;};
        };
        indent-blankline.enable = true;
        flash.enable = true;
        gitsigns.enable = true;
        cursorline.enable = true;
        alpha = {
          enable = true;
          theme = "dashboard";
        };
        trouble.enable = true;
        diffview.enable = true;
        direnv.enable = true;
        zen-mode.enable = true;
        neo-tree.enable = true;
        auto-save.enable = true;
        cmp-buffer.enable = true;
        cmp-nvim-lsp.enable = true;
        lastplace.enable = true;
        better-escape.enable = true;
        lspkind.enable = true;
        friendly-snippets.enable = true;
        none-ls = {
          enable = true;
          sources = {
            formatting = {
              alejandra.enable = true;
            };
          };
        };
        noice.enable = true;
        neorg.enable = true;
        neogit.enable = true;
        lualine.enable = true;
        nvim-colorizer.enable = true;
        luasnip.enable = true;
        cmp_luasnip.enable = true;
        which-key.enable = true;
        fidget.enable = true;
        ts-context-commentstring.enable = true;
        treesitter.enable = true;
        rainbow-delimiters.enable = true;
        cmp = {
          enable = true;
          settings = {
            sources = [{name = "nvim_lsp";} {name = "luasnip";} {name = "path";} {name = "buffer";}];
            matching.disallow_fullfuzzy_matching = true;
            snippet.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "fd";
            "<leader>fs" = "lsp_document_symbols";
            "<leader>fg" = "live_grep";
          };
        };
      };
      keymaps = [
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
          options.desc = "Toggle Term";
        }
        {
          key = "<leader>sv";
          mode = "n";
          action = "<C-w>v";
          options.desc = "Split window vertically";
        }
        {
          key = "<leader>sk";
          mode = "n";
          action = "<CMD>close<NL>";
          options.desc = "Close current split";
        }
        {
          key = "<leader>sh";
          mode = "n";
          action = "<C-w>s";
          options.desc = "Split window horizontally";
        }
        {
          key = "<leader>tn";
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
          key = "<leader>tc";
          mode = "n";
          action = "<CMD>tabclose<NL>";
          options.desc = "Close current tab";
        }
        {
          key = "<Tab>";
          mode = "n";
          action = "<CMD>:tabn<NL>";
        }
        {
          key = "<S-Tab>";
          mode = "n";
          action = "<CMD>:tabp<NL>";
        }
      ];
    };
  };
}
