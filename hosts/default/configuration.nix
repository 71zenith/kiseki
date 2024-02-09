{ config, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "izanagi";
  networking.wireless.enable = false;

  networking.networkmanager.enable = true;


  security.sudo.extraRules = [
    { users = [ "zen" ];
      commands = [
        { command = "ALL" ;
	  options = ["NOPASSWD" ];
         }
      ];
    }
  ];

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  programs.zsh.enable = true;

  users.users.zen = {
    isNormalUser = true;
    description = "Mori Zen";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    eza
    duf
    du-dust
    zoxide
    fd
    fzf
    ripgrep
    wget
    bat
    curl
    firefox
    mako
    xdg-utils
    aria2
    btop
    calibre
    cliphist
    swww
    pulsemixer
    foot
    waybar
    blueman
    mpv
    zathura
    fcitx5
    neofetch
    git
    inputs.hyprland-contrib.packages."${pkgs.system}".grimblast
  ];


  home-manager = {
    extraSpecialArgs = { inherit inputs ; };
    users = {
      "zen" = import ./home.nix ;
    };
  };


  fonts.packages = with pkgs; [
    monaspace
    noto-fonts
    noto-fonts-cjk-sans
    (nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;


  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };


  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  xdg.portal.wlr.enable = true;


  system.stateVersion = "24.05";
}
