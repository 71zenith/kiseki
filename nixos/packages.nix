{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    config.nur.repos.mic92.hello-nur

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
    nitch
    nix-output-monitor
    nurl
    nix-tree
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
    steam-run
    protonup-qt

    ### VNs
    onscripter-en

    ### emulators
    desmume
    mgba
    snes9x-gtk
    duckstation
    #config.nur.repos.chigyutendies.citra-nightly

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

    # disabled
    #logseq
    #openmw
  ];
}
