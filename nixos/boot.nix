{
  lib,
  modulesPath,
  myUserName,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a712d0ab-a784-4a07-bcfa-c538173722c2";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/43BE-E69D";
      fsType = "vfat";
    };

    "/home/${myUserName}/mnt" = {
      device = "/dev/disk/by-uuid/d574db64-7098-4a82-8837-3f4f43f3b003";
      fsType = "ext4";
      options = ["noauto"];
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/9ff583e8-b9bb-46f3-a68d-0883d3f71fe6";}];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
  };
}
