{
  pkgs,
  config,
  inputs,
  ...
}: let
  ani-cli = pkgs.callPackage ../../../pkgs/ani-cli.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ani-cli
    aria2
    calibre
    cliphist
    config.nur.repos.mic92.hello-nur
    curl
    dbus
    desmume
    du-dust
    duf
    fd
    ffmpeg
    firefox
    gcc
    gnome.nautilus
    grimblast
    gtk3
    heroic
    imagemagick
    inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    libnotify
    libsForQt5.qt5.qtwayland
    libsixel
    # logseq # NOTE: NOTES
    mgba
    neovim
    nitch
    nix-init
    nix-output-monitor
    nsxiv
    nvd
    # openmw  NOTE: morrowind
    openssl
    playerctl
    protonup-qt
    pulsemixer
    python3
    qbittorrent
    qemu
    ripgrep
    rsync
    snes9x-gtk
    sops
    steam-run
    swww
    translate-shell
    unzip
    wget
    wl-clipboard
    xdg-utils
    xwayland
    yt-dlp
    zip
    zoxide
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
}
