{
  pkgs,
  pkgs-stable,
  config,
  inputs,
  lib,
  pcName,
  myUserName,
  mailId,
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
    age.sshKeyPaths = ["${home myUserName}/.ssh/id_ed25519"];
    secrets = {
      root_pass.neededForUsers = true;
      user_pass.neededForUsers = true;
      ssh_public = {};
      vpn_private_jp = {};
      vpn_private_us = {};
      vpn_private_nl = {};
    };
  };

  networking = {
    stevenBlackHosts.enable = true;
    # NOTE: VNC server
    firewall.allowedTCPPorts = [5900];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
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
      package = pkgs.mysql84;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.getExe pkgs.hyprland;
          user = myUserName;
        };
      };
    };

    audiobookshelf = {
      enable = true;
      openFirewall = true;
      group = "users";
    };

    # NOTE: calibre drive detection
    udisks2.enable = true;

    # NOTE: nautilus trash support
    gvfs.enable = true;
  };

  systemd.coredump.extraConfig = "Storage=none";

  environment = {
    pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

    # NOTE: font stem darkening
    variables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    extraLocaleSettings = {
      LC_NUMERIC = "en_US.UTF-8";
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    useXkbConfig = true;
  };

  programs = {
    # NOTE: completions/integration/root access
    fish.enable = true;
    foot.enable = true;
    hyprland.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      protontricks.package = pkgs-stable.protontricks;
      platformOptimizations.enable = true;
    };

    gamemode.enable = true;

    nh = {
      enable = true;
      flake = "${home myUserName}/kiseki";
    };

    nix-ld.enable = true;
  };

  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets.root_pass.path;
    };
    ${myUserName} = {
      isNormalUser = true;
      shell = pkgs.fish;
      homeMode = "770";
      openssh.authorizedKeys.keyFiles = [config.sops.secrets.ssh_public.path];
      hashedPasswordFile = config.sops.secrets.user_pass.path;
      extraGroups = ["wheel" "libvirtd" "input"];
    };
  };

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs-stable;
      inherit pcName myUserName mailId;
    };
    users.${myUserName} = import ../home;
  };

  nixpkgs.config = import ../home/nixpkgs.nix;

  # NOTE: virt-manager setup
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  system.stateVersion = "25.05";
}
