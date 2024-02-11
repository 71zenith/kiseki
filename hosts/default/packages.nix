{ config, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    eza
    steam
    xwayland
    yt-dlp
    duf
    wl-clipboard
    cliphist
    heroic
    du-dust
    zoxide
    fd
    ani-cli
    protonup-qt
    gnome.nautilus
    libnotify
    libsForQt5.qt5.qtwayland
    playerctl
    spotify-player
    gtk3
    dbus
    fzf
    ripgrep
    wget
    bat
    curl
    firefox
    mako
    nil
    xdg-utils
    aria2
    nitch
    btop
    calibre
    swww
    pulsemixer
    foot
    waybar
    blueman
    mpv
    nsxiv
    zathura
    zip
    unzip
    rar
    unrar
    neofetch
    zsh-powerlevel10k
    git

    inputs.hyprland-contrib.packages."${pkgs.system}".grimblast
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    terminus_font
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    (nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
}
