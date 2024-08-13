{
  pkgs,
  config,
  inputs,
  lib,
  pcName,
  myUserName,
  myName,
  mailId,
  nurNoPkgs,
  ...
}: let
  home = user: "/home/${user}";
in {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./packages.nix
    ./stylix.nix
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["${home myUserName}/.ssh/id_ed25519"];
    secrets = {
      root_pass.neededForUsers = true;
      user_pass.neededForUsers = true;
      spot_username = {};
      spot_auth_data = {};
      vpn_private_jp = {};
      vpn_private_us = {};
      vpn_private_nl = {};
      discord_token = {owner = myUserName;};
    };
    # TODO: move to home-manager after #529(https://github.com/Mic92/sops-nix/pull/529) is merged
    templates."credentials.json" = {
      owner = myUserName;
      content = builtins.toJSON {
        username = config.sops.placeholder.spot_username;
        auth_type = 1;
        auth_data = config.sops.placeholder.spot_auth_data;
      };
      path = "${home myUserName}/.cache/spotify-player/credentials.json";
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
      trusted-users = ["root" "@wheel"];
      log-lines = 30;
      http-connections = 50;
    };
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    registry.nixpkgs.flake = inputs.nixpkgs;
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
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod;
  };

  documentation = {
    enable = true;
    dev.enable = true;
  };

  services = {
    mysql = {
      enable = false;
      package = pkgs.mariadb-embedded;
      user = myUserName;
    };

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${lib.getExe pkgs.hyprland}";
          user = myUserName;
        };
        default_session = initial_session;
      };
    };

    # NOTE: calibre drive detection
    udisks2.enable = true;

    # NOTE: nautilus trash support
    gvfs.enable = true;
  };

  security = {
    sudo.extraRules = [
      {
        users = [myUserName];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

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
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    useXkbConfig = true;
  };

  programs = {
    zsh.enable = true;

    hyprland.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      platformOptimizations.enable = true;
    };

    gamemode.enable = true;

    nh = {
      enable = true;
      flake = "${home myUserName}/nis";
    };

    nix-ld.enable = true;
  };

  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets.root_pass.path;
    };
    ${myUserName} = {
      isNormalUser = true;
      description = myName;
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.user_pass.path;
      extraGroups = ["wheel" "libvirtd" "input"];
    };
  };

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs nurNoPkgs;
      inherit pcName myUserName myName mailId;
    };
    users.${myUserName} = import ../home;
  };

  nixpkgs.config = import ../home/nixpkgs.nix;

  # NOTE: virt-manager setup
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  system.stateVersion = "24.11";
}
