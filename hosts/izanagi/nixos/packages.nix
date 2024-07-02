{
  pkgs,
  config,
  ...
}: let
  ani-cli = pkgs.callPackage ../../../pkgs/ani-cli.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Custom
    config.nur.repos.mic92.hello-nur
    ani-cli
    # Cli
    ## internet
    aria2
    curl
    wget
    yt-dlp
    rsync
    ## utils
    dust
    duf
    fd
    file
    ## helpful
    gcc
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
    dvd-zig
    firefox
    librewolf
    qemu
    gnome.nautilus
    glava
    nsxiv
    qbittorrent
    ## games
    heroic
    prismlauncher
    steam-run
    protonup-qt
    ### emulators
    desmume
    mgba
    snes9x-gtk
    config.nur.repos.chigyutendies.citra-nightly
    # libs
    libnotify
    gtk3
    libsixel
    openssl
    xwayland
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
    # logseq  NOTE: NOTES
    # openmw  NOTE: morrowind
  ];
}
