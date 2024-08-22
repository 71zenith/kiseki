{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Custom
    config.nur.repos.mic92.hello-nur

    # Cli
    ## internet
    aria2
    curl
    wget
    yt-dlp
    rsync
    ani-cli

    ## unix utils
    dust
    duf
    fd
    file
    sd
    ripgrep

    ## helpful
    gcc
    ffmpeg
    imagemagick
    sqlite
    grimblast
    cliphist
    xdg-utils
    swww
    playerctl
    wl-clipboard
    translate-shell
    pulsemixer
    nvtopPackages.nvidia
    lutgen
    gammastep
    hyprpicker
    wvkbd

    ## nix
    nitch
    nix-output-monitor
    nurl
    nix-tree
    nvd
    sops

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
    dvd-zig
    gimp

    ## games
    heroic
    prismlauncher
    steam-run
    protonup-qt

    ### emulators
    desmume
    mgba
    snes9x-gtk
    #config.nur.repos.chigyutendies.citra-nightly
    #config.nur.repos.chigyutendies.suyu-dev

    # libs
    libnotify
    gtk3
    libsixel
    openssl
    xwayland

    # dev
    ## doom emacs
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
    wordnet
    cmigemo
    ### lsp
    nil
    zls

    ## docs
    man-pages
    man-pages-posix

    ## langs
    python3
    python312Packages.ipython
    zig

    ## editors
    neovim
    lem-ncurses
    zed-editor

    # disabled
    #logseq
    #openmw
  ];
}
