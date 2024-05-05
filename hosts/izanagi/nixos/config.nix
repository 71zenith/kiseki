{
  pkgs,
  inputs,
  ...
}: let
  myUserName = "zen";
in {
  imports = [
    ./hardware.nix
    ./packages.nix
    ./stylix.nix
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

  boot = {
    loader.systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_xanmod;
  };

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "${myUserName}";
        };
        default_session = initial_session;
      };
    };

    # NOTE: calibre drive detection
    udisks2.enable = true;

    # NOTE: nautilus trash support
    gvfs.enable = true;

    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    blueman.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver.videoDrivers = ["nvidia"];
  };

  networking = {
    hostName = "izanagi";
    wireless.enable = false;
    useNetworkd = true;
  };

  security.sudo.extraRules = [
    {
      users = ["${myUserName}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = with pkgs; [terminus_font];
  };

  programs = {
    zsh.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    nh.enable = true;
    nh.flake = "/home/${myUserName}/nix";

    nix-ld.enable = true;
  };

  users.users.${myUserName} = {
    isNormalUser = true;
    description = "Mori Zen";
    shell = pkgs.zsh;
    extraGroups = ["wheel" "libvirtd"];
  };

  sound.enable = true;

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
      inherit myUserName;
    };
    users = {"${myUserName}" = import ./home/home.nix;};
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
      forceFullCompositionPipeline = true;
      nvidiaSettings = true;
    };

    cpu.amd.updateMicrocode = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  #hardware.opentabletdriver.enable = true;

  # NOTE: QEMU Setup
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  system.stateVersion = "24.05";
}
