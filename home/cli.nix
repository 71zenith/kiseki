{
  pkgs,
  matrixId,
  ...
}: {
  imports = [./custom/iamb.nix];

  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        rounded_corners = false;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = ["--hyperlink"];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    iamb = {
      enable = true;
      settings = {
        profiles.main = {
          user_id = matrixId;
          settings = {
            image_preview = {
              protocol.type = "sixel";
              size = {
                height = 10;
                width = 30;
              };
            };
            users = {
              ${matrixId} = {
                name = "thou thyself";
                color = "yellow";
              };
            };
            message_user_color = false;
            notifications.enabled = true;
            open_command = ["xdg-open"];
            user_gutter_width = 20;
            username_display = "displayname";
          };
          # NOTE: <S-Tab> does not work
          macros = {
            "normal|visual" = {
              "Q" = ":qa<CR>";
              "s" = "<C-W>m";
              "<C-o>" = ":open<CR>";
              "r" = ":react ";
              "e" = ":edit<CR>";
              "E" = ":reply<CR>";
              "<Esc>" = ":cancel<CR>y";
              "z" = "<C-W>z";
              "t" = ":redact<CR>";
              "<C-N>" = ":tabn<CR>";
              "<C-P>" = ":tabp<CR>";
            };
          };
          layout = {
            style = "config";
            tabs = [
              {window = "!JWluPDcFzVMlxykpoI:matrix.org";}
              {window = "!tOWyKLILvZUrnrhovA:matrix.org";}
              {window = "!mVGiciUDlnEmaxEOry:matrix.org";}
              {window = "#gen-ani-cli:matrix.org";}
              {window = "@mrfluffy:mrfluffy.xyz";}
              {window = "@nannk:synapse.nannk.xyz";}
            ];
          };
        };
      };
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "ya";
      keymap = {
        manager.prepend_keymap = [
          {
            run = ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'';
            on = ["y"];
          }
          {
            run = ''shell "$SHELL" --block --confirm'';
            on = ["<C-s>"];
          }
          {
            run = "plugin --sync max-preview";
            on = ["T"];
          }
        ];
      };
      plugins = {
        max-preview = "${pkgs.yazi-plugins}/share/max-preview.yazi";
      };
      settings = {
        manager = {
          ratio = [1 3 3];
          sort_by = "natural";
          show_hidden = true;
        };
      };
    };
  };
}
