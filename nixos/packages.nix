{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Cli
    ## internet
    aria2
    curl
    wget
    yt-dlp
    rsync
    ani-cli
    dra-cla
    nhentai

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
    pipes-rs
    xdg-utils
    ffmpeg
    nvtopPackages.nvidia
    sqlite
    timg
    imagemagick
    playerctl
    translate-shell
    pulsemixer
    lutgen
    gammastep

    ## wayland
    grimblast
    cliphist
    hyprpicker
    swww
    wl-clipboard
    wvkbd
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
    cachix

    ## compression
    zip
    unzip
    rar
    unrar
    _7zz

    # gui
    calibre
    vesktop
    librewolf
    qbittorrent
    nautilus
    qalculate-qt
    glava
    nsxiv
    gimp

    ## games
    heroic
    prismlauncher
    protonup-qt
    yuzu

    ### VNs
    onscripter-en

    ### emulators
    desmume
    mgba
    snes9x-gtk
    duckstation
    pcsx2

    # dev
    ## doom emacs
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
    wordnet
    cmigemo

    ### lsp
    nil
    zls

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

    ## editors
    neovim
    #zed-editor
    #lem-ncurses

    # NOTE: disabled
    # logseq
    # openmw
  ];
}
