{
  pkgs,
  config,
  inputs,
  pcName,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  console.useXkbConfig = true;

  services = {
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
      xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
      videoDrivers = ["nvidia"];
    };

    blueman.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      lowLatency.enable = true;
    };
  };

  security.rtkit.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs; [
        pkgsi686Linux.mesa.drivers
      ];
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

    # NOTE: wacom fix
    # opentabletdriver.enable = true;
  };

  networking = {
    hostName = pcName;
    wireless.enable = false;
    useNetworkd = true;

    wg-quick.interfaces = {
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
}
