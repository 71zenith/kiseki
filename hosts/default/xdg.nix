{ config, ... }: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = [ "firefox.desktop" ];
        editor = [ "nvim.desktop" ];
        player = [ "mpv.desktop" ];
        viewer = [ "nsxiv.desktop" ];
        reader = [ "zathura.desktop" ];
      in {
        "application/json" = browser;
        "application/pdf" = reader;

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
      extraConfig = {
        XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/dl";
        XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/dox";
        XDG_DESKTOP_DIR = "${config.home.homeDirectory}/dl";
        XDG_VIDEOS_DIR = "${config.home.homeDirectory}/vid";
        XDG_PICTURES_DIR = "${config.home.homeDirectory}/pix";
        XDG_MUSIC_DIR = "${config.home.homeDirectory}/dl";
        XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/dl";
        XDG_PUBLIC_DIR = "${config.home.homeDirectory}/dl";
      };
    };
    mime.enable = true;
  };
  home.file = {
    "${config.xdg.configHome}/electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
  };
}
