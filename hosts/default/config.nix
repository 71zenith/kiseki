{
  config,
  pkgs,
  inputs,
  ...
}: let
  fcitx5-fluent = pkgs.callPackage ../../modules/nix-os/fcitx-fluent.nix {};
in {
  imports = [
    ./hardware.nix
    ./packages.nix
    ./stylix.nix
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "zen";
      };
      default_session = initial_session;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  networking.hostName = "izanagi";
  networking.wireless.enable = false;

  networking.networkmanager.enable = true;

  security.sudo.extraRules = [
    {
      users = ["zen"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
    fcitx5.waylandFrontend = true;
  };

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

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = with pkgs; [terminus_font];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  users.users.zen = {
    isNormalUser = true;
    description = "Mori Zen";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
  };

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

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {"zen" = import ./hyprland.nix;};
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    forceFullCompositionPipeline = true;
    nvidiaSettings = true;
  };
  programs.nix-ld = {enable = true;};
  nixpkgs.config = {
    allowUnfree = true;
  };

  #virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  #hardware.opentabletdriver.enable = true;

  system.stateVersion = "24.05";
}
