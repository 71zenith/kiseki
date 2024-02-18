{ pkgs, inputs, ... }:
let ani-cli = pkgs.callPackage ../../modules/nix-os/ani-cli.nix { };
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    eza
    steam
    steam-run
    ffmpeg
    libsixel
    anime4k
    xwayland
    yt-dlp
    duf
    tesseract
    wl-clipboard
    cliphist
    shfmt
    heroic
    du-dust
    zoxide
    nixfmt
    fd
    ani-cli
    nodePackages_latest.bash-language-server
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
    openssl
    imagemagick
    unzip
    rar
    unrar
    zsh-powerlevel10k
    git
    inputs.hyprland-contrib.packages."${pkgs.system}".grimblast
  ];

  fonts.packages = with pkgs; [
    terminus_font
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    open-sans
    iosevka-comfy.comfy
    (nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  programs.hyprland.enable = true;
  programs.hyprland.package =
    inputs.hyprland.packages."${pkgs.system}".hyprland;
}
