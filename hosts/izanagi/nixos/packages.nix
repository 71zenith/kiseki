{
  pkgs,
  config,
  ...
}: let
  ani-cli = pkgs.callPackage ../../../pkgs/ani-cli.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # NUR
    config.nur.repos.mic92.hello-nur
    # Custom
    ani-cli
    # Cli
    aria2
    curl
    gcc
    dust
    duf
    fd
    file
    unzip
    wget
    yt-dlp
    grimblast
    cliphist
    ffmpeg
    pulsemixer
    imagemagick
    nvtopPackages.nvidia
    playerctl
    zip
    wl-clipboard
    xdg-utils
    swww
    ripgrep
    sops
    translate-shell
    zoxide
    rsync
    ## nix
    nitch
    nix-init
    nix-output-monitor
    nurl
    nvd
    # gui
    calibre
    dvd-zig
    firefox
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
    zed-editor
    # disabled
    # logseq  NOTE: NOTES
    # openmw  NOTE: morrowind
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
}
