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

    ## utils
    dust
    duf
    fd
    file
    sd

    ## helpful
    gcc
    sqlite
    grimblast
    cliphist
    ffmpeg
    pulsemixer
    imagemagick
    nvtopPackages.nvidia
    playerctl
    wl-clipboard
    xdg-utils
    swww
    ripgrep
    sops
    translate-shell
    zoxide

    ## nix
    nitch
    nix-init
    nix-output-monitor
    nurl
    nvd

    ## compression
    zip
    unzip
    rar
    unrar
    _7zz

    # gui
    calibre
    vesktop
    firefox
    librewolf
    qbittorrent
    nautilus
    qalculate-qt
    glava
    nsxiv
    dvd-zig

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

    # libs
    libnotify
    gtk3
    libsixel
    openssl
    xwayland
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))

    # dev
    ## docs
    man-pages
    man-pages-posix

    ## langs
    python3
    zig

    ## editors
    neovim
    lem-sdl2
    zed-editor

    # disabled
    #logseq   # NOTE: NOTES
    #openmw   # NOTE: morrowind
  ];
}
