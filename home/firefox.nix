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
    rev = "ab5ede0fef39f02f0ef2bd119879226e3ab71f9f";
    hash = "sha256-s54Y6Ix7W942T+TIwGudoqDzUHifMBJOU9AWqpqIKl4=";
  };
  ultima = pkgs.fetchFromGitHub {
    owner = "soulhotel";
    repo = "FF-ULTIMA";
    rev = "d7d53dd31af32618c13b0e5b5c0405080a3f3673";
    hash = "sha256-IAdqKF4WfQzo1I/tizHMWDLST/T2tKz4do+Dkw9eZs8=";
  };
in {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.tridactyl-native];
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
          tridactyl
          ublock-origin
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
          "browser.toolbars.bookmarks.visibility" = "never";

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

          "user.theme.dark.a" = false;
          "user.theme.light.a" = false;
          "ultima.theme.extensions" = false;
          "ultima.urlbar.centered" = false;

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
          ${builtins.readFile "${ultima}/user.js"}
        '';
        userChrome = with config.lib.stylix.colors.withHashtag; ''
          @import "${ultima}/userChrome.css";
          :root, body, * {
            --uc-ultima-window: ${base00};
            --uc-text: ${base06};
            --uc-dark-color: ${base01};
            --uc-light-color: ${base04};
            --uc-accent-i: ${base09};
            --uc-accent-ii: ${base06};
            --uc-accent-iii: ${base08};
            --uc-accent-iv: ${base07};
            --uc-accent-v: ${base0F};
            --uc-accent-vi: ${base0A};
            --uc-accent-vii: ${base0F};
            --uc-background-main: ${base01};
            --uc-background-layered: ${base00};
            --uc-transparent: rgba(0,0,0,0);
            --uc-button-selected: ${base03};
            --uc-tab-selected-bg: ${base01};
            --uc-urlbar-background: ${base01};
            --uc-panel-background: ${base01};
            --uc-panel-border: ${base00};
            --uc-panel-border-ii: ${base00};
            --uc-context-menu: ${base01};
          }
          #nav-bar {
            padding-block-start: 0px !important;
            border: none !important;
            box-shadow: none !important;
            background: transparent !important;
          }
        '';
        userContent = with config.lib.stylix.colors.withHashtag; ''
          @import "${ultima}/userContent.css";
          @-moz-document url("about:newtab") {
            body {
              background-color: ${base01} !important;
            }
          }
        '';
      };
    };
  };
}
