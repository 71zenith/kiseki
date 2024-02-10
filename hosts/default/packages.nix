{ config, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    eza
    steam
    xwayland
    duf
    wl-clipboard
    du-dust
    zoxide
    fd
    gnome.nautilus
    libnotify
    libsForQt5.qt5.qtwayland
    playerctl
    gtk3
    dbus
    fzf
    ripgrep
    wget
    bat
    curl
    firefox
    mako
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
    monaspace
    noto-fonts
    terminus_font
    noto-fonts-cjk-sans
    (nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
}
