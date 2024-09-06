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
    xdg-utils
    playerctl
    translate-shell
    pulsemixer
    nvtopPackages.nvidia
    lutgen
    gammastep
    grimblast
    cliphist
    hyprpicker
    swww
    wl-clipboard
    wvkbd
    eww

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

    ### vns
    onscripter-en

    ### emulators
    desmume
    mgba
    snes9x-gtk
    #config.nur.repos.chigyutendies.citra-nightly
    #config.nur.repos.chigyutendies.suyu-dev

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
    zed-editor
    #lem-ncurses

    # disabled
    #logseq
    #openmw
  ];
}
