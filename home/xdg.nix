{
  config,
  pkgs,
  ...
}: {
  xdg = {
    enable = true;

    portal = {
      enable = true;
      config.common.default = ["hyprland" "gtk"];
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["firefox.desktop"];
        fileManager = ["org.gnome.Nautilus.desktop"];
        editor = ["neovide.desktop"];
        player = ["mpv.desktop"];
        viewer = ["nsxiv.desktop"];
        reader = ["org.pwmt.zathura.desktop"];
      in {
        "application/pdf" = reader;
        "application/epub" = reader;

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/x-wine-extension-ini" = editor;

        "application/json" = browser;
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

        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        "inode/directory" = fileManager;
        "application/zip" = fileManager;

        "audio/mpeg" = player;
        "audio/aac" = player;
        "audio/flac" = player;
        "audio/wav" = player;
        "video/mp4" = player;
        "video/vnd.mpegurl" = player;
        "video/x-matroska" = player;
        "application/x-mpegURL" = player;

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

    configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --enable-features=UseOzonePlatform
      --ozone-platform-hint=wayland
      --disable-gpu-compositing
    '';
  };
}
