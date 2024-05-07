{
  pkgs,
  inputs,
  config,
  ...
}: let
  ani-cli = pkgs.callPackage ../../../modules/nix-os/ani-cli.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    steam-run
    ffmpeg
    libsixel
    sops
    anime4k
    rsync
    xwayland
    yt-dlp
    duf
    wl-clipboard
    cliphist
    nix-output-monitor
    nvd
    openssl
    heroic
    du-dust
    zoxide
    fd
    ani-cli
    gcc
    protonup-qt
    gnome.nautilus
    libnotify
    libsForQt5.qt5.qtwayland
    playerctl
    gtk3
    dbus
    ripgrep
    wget
    curl
    firefox
    xdg-utils
    aria2
    nitch
    calibre
    swww
    pulsemixer
    mgba
    desmume
    blueman
    qbittorrent
    nsxiv
    python3
    zip
    imagemagick
    snes9x-gtk
    unzip
    qemu
    openmw
    zsh-powerlevel10k
    config.nur.repos.mic92.hello-nur
    grimblast
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
}
