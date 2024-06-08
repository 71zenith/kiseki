{
  pkgs,
  config,
  inputs,
  pcName,
  myUserName,
  nur-no-pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./packages.nix
    ./stylix.nix
  ];

  options.vals = {
    pcName = lib.mkOption {
      default = pcName;
      type = lib.types.str;
    };
    myUserName = lib.mkOption {
      default = myUserName;
      type = lib.types.str;
    };
  };

  config = {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = ["/home/${config.vals.myUserName}/.ssh/id_ed25519"];
      secrets = {
        root_pass.neededForUsers = true;
        user_pass.neededForUsers = true;
        spot_username = {};
        spot_auth_data = {};
        vpn_private_jp = {};
        vpn_private_us = {};
        vpn_private_nl = {};
        cachix_token = {};
        discord_token = {owner = config.vals.myUserName;};
      };
      # TODO: move to home-manager after #529(https://github.com/Mic92/sops-nix/pull/529) is merged
      templates."credentials.json" = {
        owner = config.vals.myUserName;
        content = builtins.toJSON {
          username = config.sops.placeholder.spot_username;
          auth_type = 1;
          auth_data = config.sops.placeholder.spot_auth_data;
        };
        path = "/home/${config.vals.myUserName}/.cache/spotify-player/credentials.json";
      };
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

    networking.wg-quick.interfaces = {
      jp = {
        autostart = false;
        address = ["10.2.0.2/32"];
        dns = ["10.2.0.1"];
        privateKeyFile = config.sops.secrets.vpn_private_jp.path;
        peers = [
          {
            publicKey = "5fFhuzIQPu8C4tySJuCJYg/13g75APFtMnqn3oeCpxk=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "193.148.16.2:51820";
            persistentKeepalive = 25;
          }
        ];
      };
      us = {
        autostart = false;
        address = ["10.2.0.2/32"];
        dns = ["10.2.0.1"];
        privateKeyFile = config.sops.secrets.vpn_private_us.path;
        peers = [
          {
            publicKey = "ksK3faRBQlFLul2FcKPphBR9LYR+6/FbP1etg0T2liA=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "37.19.221.198:51820";
            persistentKeepalive = 25;
          }
        ];
      };
      nl = {
        autostart = false;
        address = ["10.2.0.2/32"];
        dns = ["10.2.0.1"];
        privateKeyFile = config.sops.secrets.vpn_private_nl.path;
        peers = [
          {
            publicKey = "jA3Pf5MWpHk8STrLXVPyM28aV3yAZgw9nEGoIFAyxiI=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "185.177.124.190:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };

    services = {
      cachix-watch-store = {
        enable = true;
        cacheName = "71zenith";
        cachixTokenFile = config.sops.secrets.cachix_token.path;
        compressionLevel = 16;
        verbose = true;
      };
      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${lib.getExe pkgs.hyprland}";
            user = config.vals.myUserName;
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
      hostName = config.vals.pcName;
      wireless.enable = false;
      useNetworkd = true;
    };

    security.sudo.extraRules = [
      {
        users = [config.vals.myUserName];
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

    boot.kernel.sysctl = {
      "kernel.sysrq" = 0;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
      packages = with pkgs; [terminus_font];
    };

    # NOTE: for systemd completion
    environment.pathsToLink = ["/share/zsh"];
    programs = {
      zsh.enable = true;

      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      nh = {
        enable = true;
        flake = "/home/${config.vals.myUserName}/nix";
      };

      nix-ld.enable = true;
    };

    users.users = {
      root = {
        hashedPasswordFile = config.sops.secrets.root_pass.path;
      };
      ${config.vals.myUserName} = {
        isNormalUser = true;
        description = "Mori Zen";
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets.user_pass.path;
        extraGroups = ["wheel" "libvirtd"];
      };
    };

    sound.enable = true;

    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit nur-no-pkgs;
      };
      users.${config.vals.myUserName} = import ../hm/home.nix;
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
        extraPackages = with pkgs; [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      nvidia = {
        modesetting.enable = true;
        open = true;
        powerManagement.enable = true;
        forceFullCompositionPipeline = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      cpu.amd.updateMicrocode = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "*";
    };

    nixpkgs.config = import ../hm/nixpkgs.nix;

    # NOTE: wacom fix
    # hardware.opentabletdriver.enable = true;

    # NOTE: virt-manager setup
    # virtualisation.libvirtd.enable = true;
    # programs.virt-manager.enable = true;

    system.stateVersion = "24.11";
  };
}
