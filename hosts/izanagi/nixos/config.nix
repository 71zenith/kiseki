{
  pkgs,
  config,
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

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/home/${myUserName}/.ssh/id_ed25519"];
    secrets = {
      root_pass.neededForUsers = true;
      user_pass.neededForUsers = true;
      # username = {};
      # auth_data = {};
      # auth_type = {};
    };
    # templates."credentials.json" = {
    #   path = "/home/${myUserName}/.cache/spotify-player/credentials.json";
    #   owner = "${myUserName}";
    #   content = ''
    #     {
    #       "username": "${config.sops.placeholder.username}",
    #       "auth_type": "${config.sops.placeholder.auth_type}",
    #     }
    #   '';
    # };
  };

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

  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets.root_pass.path;
    };
    ${myUserName} = {
      isNormalUser = true;
      description = "Mori Zen";
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.user_pass.path;
      extraGroups = ["wheel" "libvirtd"];
    };
  };

  sound.enable = true;

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
      inherit myUserName;
    };
    users = {"${myUserName}" = import ../home/home.nix;};
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

  # NOTE: wacom fix
  # hardware.opentabletdriver.enable = true;

  # NOTE: virt-manager setup
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  system.stateVersion = "24.05";
}
