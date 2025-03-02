{
  inputs,
  pkgs,
  myUserName,
  ...
}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "09dd87a3abcb15a88798941e5ed74e4aa593108c";
    hash = "sha256-Uu/a5t74GGvMIJP5tptqbiFiA+x2hw98irPdl8ynGoE=";
  };
  lepton = pkgs.fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "7d96af3abec66fc10bb412d0368b04a505199eac";
    hash = "sha256-JEJnmYjY9I0I8rxYVQLMjiayk6PnKq/eptZD8GvaDBo=";
  };
in {
  stylix.targets.firefox.profileNames = [myUserName];
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.tridactyl-native];
    profiles = {
      ${myUserName} = {
        id = 0;
        isDefault = true;
        name = myUserName;
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
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
          # GENERAL
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
          "browser.tabs.loadBookmarksInTabs" = true;
          "browser.urlbar.maxRichResults" = true;

          # PRIVACY
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "app.normandy.enabled" = false;
        };

        bookmarks = [
          {
            name = "nix";
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
            ];
          }
          {
            name = "uhh";
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
            name = "fml";
            toolbar = false;
            bookmarks = [
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
            "Nix Options" = {
              urls = [{template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
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
          ${builtins.readFile "${lepton}/user.js"}
        '';
        userChrome = ''
          @import "${lepton}/userChrome.css";
        '';
        userContent = ''
          @import "${lepton}/userContent.css";
        '';
      };
    };
  };
}
