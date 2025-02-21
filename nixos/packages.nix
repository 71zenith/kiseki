{
  pkgs,
  pkgs-stable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # CLI
    ## internet
    aria2
    curl
    wget
    yt-dlp
    rsync
    rclone
    (ani-cli.override {mpv = null;})

    ## rusty unix
    dust
    xcp
    duf
    fd
    file
    sd
    ripgrep
    jaq

    ## helpful
    gcc
    xdg-utils
    ffmpeg
    nvtopPackages.nvidia
    sqlite
    timg
    imagemagick
    playerctl
    translate-shell
    pulsemixer

    ## wayland
    grimblast
    cliphist
    swww
    wl-clipboard
    eww
    wayvnc

    ## nix
    microfetch
    nix-output-monitor
    nurl
    nix-tree
    nix-init
    nvd
    sops

    ## compression
    zip
    unzip
    rar
    unrar
    _7zz

    # GUI
    pkgs-stable.calibre
    pkgs-stable.vesktop
    pkgs-stable.qbittorrent
    nautilus
    qalculate-qt
    glava
    pkgs-stable.nsxiv
    gimp

    ## games
    heroic
    (prismlauncher.override {jdks = with pkgs; [jdk23 jdk21 jdk17];})
    protonup-qt
    # shipwright
    yuzu

    ### VNs
    pkgs-stable.onscripter-en

    ### emulators
    pkgs-stable.desmume
    pkgs-stable.mgba
    snes9x-gtk

    pkgs-stable.pcsx2

    # DEV

    ## libs
    libnotify
    gtk3
    libsixel
    openssl
    xwayland

    ## docs
    man-pages
    man-pages-posix

    ## langs
    python3
    python312Packages.ipython
    zig
    zls
    leiningen

    ## editors
    neovim
    emacs30-pgtk
    emacs-lsp-booster
  ];
}
