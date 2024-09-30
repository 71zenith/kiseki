{
  inputs,
  pkgs,
  config,
  myUserName,
  ...
}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "129.0";
    hash = "sha256-hpkEO5BhMVtINQG8HN4xqfas/R6q5pYPZiFK8bilIDs=";
  };
  minimal-arc = pkgs.fetchFromGitHub {
    owner = "zayihu";
    repo = "Minimal-Arc";
    rev = "ccdb8ed51c0c9bd0d1894564ccc2b6499166c0cc";
    hash = "sha256-bRuHyEnz0Iev7/bry7IuSVjStWT9EsFgB2FIzJJhAZw=";
  };
in {
  programs.firefox = {
    enable = true;

    profiles = {
      ${myUserName} = {
        id = 0;
        isDefault = true;
        name = myUserName;
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          refined-github
          sponsorblock
          mal-sync
          to-google-translate
          foxyproxy-standard
          istilldontcareaboutcookies
          localcdn
          clearurls
          privacy-badger
          don-t-fuck-with-paste
          skip-redirect
          search-by-image
          vimium-c
          ublock-origin
          sidebery
          inputs.firefox-addons.packages.${pkgs.system}."10ten-ja-reader"
        ];
        settings = {
          "browser.startup.page" = "https://71zenith.github.io/";
          "browser.display.use_document_fonts" = 0;
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          "browser.theme.toolbar-theme" = 0;
          "general.autoScroll" = true;
          "extensions.autoDisableScopes" = 0;
          "extensions.allowPrivateBrowsingByDefault" = true;

          # TELEMETRY
          "browser.ping-centre.telemetry" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;

          # PERFS
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.rdd-vpx.enabled" = false;

          # TWEAKS
          "browser.cache.memory.capacity" = -1;
          "middlemouse.paste" = false;
          "network.dns.echconfig.enabled" = true;

          # PRIVACY
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "app.normandy.enabled" = false;
        };

        bookmarks = [
          {
            name = "NixOS";
            toolbar = false;
            bookmarks = [
              {
                name = "Nix Package";
                keyword = "np";
                url = "https://search.nixos.org/packages?channel=unstable";
              }
              {
                name = "Nix Options";
                keyword = "no";
                url = "https://search.nixos.org/options?channel=unstable";
              }
              {
                name = "NixOS Wiki";
                keyword = "nw";
                url = "https://wiki.nixos.org/wiki/";
              }
              {
                name = "Home-Manager";
                keyword = "hm";
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              }
            ];
          }
          {
            name = "1337";
            toolbar = false;
            bookmarks = [
              {
                name = "ProtonMail";
                keyword = "ma";
                url = "https://mail.proton.me/";
              }
              {
                name = "Anilist";
                keyword = "an";
                url = "https://anilist.co";
              }
              {
                name = "ChatGPT";
                keyword = "ch";
                url = "https://chat.openai.com";
              }
              {
                name = "GitHub";
                keyword = "gh";
                url = "https://github.com";
              }
              {
                name = "Discord";
                keyword = "di";
                url = "https://discord.com/channels/@me";
              }
              {
                name = "Element";
                keyword = "el";
                url = "https://app.element.io";
              }
              {
                name = "Nhentai";
                keyword = "nh";
                url = "https://nhentai.net";
              }
            ];
          }
          {
            name = "waste";
            toolbar = false;
            bookmarks = [
              {
                name = "Google";
                keyword = "g";
                url = "https://google.com";
              }
              {
                name = "Twitter";
                keyword = "tw";
                url = "https://twitter.com";
              }
              {
                name = "YouTube";
                keyword = "yo";
                url = "https://YouTube.com";
              }
              {
                name = "Whatsapp";
                keyword = "we";
                url = "https://web.whatsapp.com";
              }
            ];
          }
        ];

        search = {
          default = "Brave";
          force = true;
          engines = {
            "Brave" = {
              urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
              definedAliases = ["@b"];
              iconUpdateURL = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
            };
            "GitHub" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=code";}];
              definedAliases = ["@gh"];
            };
            "Nix Packages" = {
              urls = [{template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "Home Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
              urls = [{template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";}];
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/wiki/{searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nw"];
            };
            "Noogle" = {
              urls = [{template = "https://noogle.dev/q?term={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@ng"];
            };
            "NixVim" = {
              urls = [{template = "https://nix-community.github.io/nixvim/?search={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nv"];
            };
            "YouTube" = {
              iconUpdateURL = "https://youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
              definedAliases = ["@yt"];
            };
            "Nhentai" = {
              updateInterval = 24 * 60 * 60 * 1000;
              urls = [{template = "https://www.nhentai.net/search?q={searchTerms}";}];
              definedAliases = ["@nh"];
            };
            "Google".metaData.alias = "g";
          };
        };
        extraConfig = ''
          ${builtins.readFile "${betterfox}/user.js"}
          ${builtins.readFile "${betterfox}/Fastfox.js"}
          ${builtins.readFile "${betterfox}/Peskyfox.js"}
          ${builtins.readFile "${betterfox}/Smoothfox.js"}
        '';
        userChrome = with config.lib.stylix.colors.withHashtag; ''
          ${builtins.readFile "${minimal-arc}/chrome/userChrome.css"}
          html {
            --custom-bg-dark: ${base00};
            --custom-bg: ${base00};
          }
          #nav-bar {
            padding-block-start: 0px !important;
            border: none !important;
            box-shadow: none !important;
            background: transparent !important;
          }
        '';
      };
    };
  };
}
