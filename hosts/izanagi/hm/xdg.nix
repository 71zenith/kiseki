{config, ...}: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["firefox.desktop"];
        fileManager = ["nautilus.desktop"];
        editor = ["neovide.desktop"];
        player = ["mpv.desktop"];
        viewer = ["nsxiv.desktop"];
        reader = ["org.pwmt.zathura.desktop"];
      in {
        "application/json" = browser;
        "application/pdf" = reader;
        "application/epub" = reader;
        "application/epub+zip" = reader;

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        "inode/directory" = fileManager;

        "audio/*" = player;
        "video/*" = player;
        "image/*" = viewer;
        "image/gif" = viewer;
        "image/jpeg" = viewer;
        "image/png" = viewer;
        "image/webp" = viewer;
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      download = "${config.home.homeDirectory}/dl";
      documents = "${config.home.homeDirectory}/dl/dox";
      desktop = "${config.home.homeDirectory}/dl/desk";
      videos = "${config.home.homeDirectory}/dl/vid";
      pictures = "${config.home.homeDirectory}/pix";
      music = "${config.home.homeDirectory}/dl/music";
      templates = "${config.home.homeDirectory}/.local/share/templates";
      publicShare = "${config.home.homeDirectory}/.local/share/public";
    };
    mime.enable = true;
  };
  home.file = {
    "${config.xdg.configHome}/electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}
