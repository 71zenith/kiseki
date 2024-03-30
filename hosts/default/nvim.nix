{inputs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs = {
    nixvim = {
      enable = true;
      colorschemes.oxocarbon.enable = true;
      globals.mapleader = " ";
      clipboard.providers.wl-copy.enable = true;
      opts = {
        number = true;
        relativenumber = false;
        shiftwidth = 2;
        clipboard = "unnamedplus";
      };
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
        lsp-format.enable = true;
        barbecue.enable = true;
        lsp = {
          enable = true;
          servers = {nil_ls.enable = true;};
        };
        indent-blankline.enable = true;
        leap.enable = true;
        gitsigns.enable = true;
        cursorline.enable = true;
        alpha = {
          enable = true;
          theme = "dashboard";
        };
        neo-tree.enable = true;
        auto-save.enable = true;
        cmp-buffer.enable = true;
        cmp-nvim-lsp.enable = true;
        lastplace.enable = true;
        cmp-nvim-lua.enable = true;
        lspkind.enable = true;
        friendly-snippets.enable = true;
        noice.enable = true;
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
            sources = [{name = "nvim_lsp";} {name = "path";} {name = "buffer";}];
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
          extensionConfig.ui-select = {};
          extensions.frecency.enable = true;
          extensions.fzf-native.enable = true;
          extensions.file_browser = {
            enable = true;
            hidden = true;
            depth = 9999999999;
            autoDepth = true;
          };
          keymaps = {
            "<leader>ff" = "fd";
            "<leader>fs" = "lsp_document_symbols";
            "<leader>fg" = "live_grep";
          };
        };
      };
      keymaps = [
        {
          key = "<leader>t";
          action = "<CMD>Neotree float toggle<NL>";
        }
        {
          key = "<leader>n";
          action = "<CMD>ToggleTerm<NL>";
        }
        {
          key = "<Tab>";
          action = "<CMD>:bnext<NL>";
        }
        {
          key = "<S-Tab>";
          action = "<CMD>:bprevious<NL>";
        }
      ];
    };
  };
}
