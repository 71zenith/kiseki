{
  pkgs,
  inputs,
  config,
  myUserName,
  ...
}: let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "122.1";
    hash = "sha256-eHocB5vC6Zjz7vsvGOTGazuaUybqigODEIJV9K/h134=";
  };
in {
  programs.firefox = {
    enable = true;

    profiles = {
      ${myUserName} = {
        id = 0;
        isDefault = true;
        name = "${myUserName}";
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          refined-github
          sponsorblock
          to-google-translate
          foxyproxy-standard
          i-dont-care-about-cookies
          localcdn
          privacy-badger
          search-by-image
          vimium
          ublock-origin
          inputs.firefox-addons.packages.${pkgs.system}."10ten-ja-reader"
        ];
        settings = {
          "intl.accept_languages" = "en-US,en";
          "browser.startup.page" = 3;
          "browser.aboutConfig.showWarning" = false;
          "browser.display.use_document_fonts" = 0;
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.download.useDownloadDir" = false;
          "privacy.clearOnShutdown.history" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "accessibility.typeaheadfind.enablesound" = false;
          "layers.acceleration.force-enabled" = true;
          "general.autoScroll" = true;

          # TELEMETRY
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.tabs.crashReporting.sendReport" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;

          # POCKET
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "extensions.pocket.enabled" = false;

          # PERF
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.rdd-vpx.enabled" = false;
          "browser.uitour.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # TWEAKS
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;
          "browser.cache.memory.capacity" = -1;
          "browser.preferences.defaultPerformanceSettings.enabled" = false;
          "middlemouse.paste" = false;
          "network.dns.echconfig.enabled" = true;
          "network.predictor.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;

          # SMOOTH SCROLL
          "general.smoothScroll" = true;
          "general.smoothScroll.lines.durationMaxMS" = 125;
          "general.smoothScroll.lines.durationMinMS" = 125;
          "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
          "general.smoothScroll.mouseWheel.durationMinMS" = 100;
          "general.smoothScroll.msdPhysics.enabled" = true;
          "general.smoothScroll.other.durationMaxMS" = 125;
          "general.smoothScroll.other.durationMinMS" = 125;
          "general.smoothScroll.pages.durationMaxMS" = 125;
          "general.smoothScroll.pages.durationMinMS" = 125;
          "mousewheel.min_line_scroll_amount" = 30;
          "mousewheel.system_scroll_override_on_root_content.enabled" = true;
          "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
          "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
          "toolkit.scrollbox.horizontalScrollDistance" = 6;
          "toolkit.scrollbox.verticalScrollDistance" = 2;

          # PRIVACY
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          "browser.send_pings" = false;
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
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
                url = "https://wiki.nixos.org/wiki/Linux_kernel";
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
                keyword = "yt";
                url = "https://YouTube.com";
              }
              {
                name = "Whatsapp";
                keyword = "wh";
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
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "GitHub" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=code";}];
              definedAliases = ["@gh"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "Home-Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [{template = "https://rycee.gitlab.io/home-manager/options.html";}];
              definedAliases = ["@hm"];
            };
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/wiki/{searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nw"];
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
          ${builtins.readFile "${betterfox}/Fastfox.js"}
          ${builtins.readFile "${betterfox}/Peskyfox.js"}
        '';
      };
    };
  };
}
