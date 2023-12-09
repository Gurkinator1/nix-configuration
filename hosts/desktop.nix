{ config, modulesPath, inputs, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/core
    ../modules/other/dunst
    ../modules/other/waybar
    ../modules/other/hyprland
  ];

  system.stateVersion = "23.11";
  home-manager.users.gurki.home.stateVersion = "23.11";

  # user configuration
  networking.hostName = "gurki-desktop";
  users.users.gurki = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tailscale
      jetbrains.idea-community
      python3
      element-desktop
      temurin-jre-bin-17
      prismlauncher
    ];
  };

  programs.dconf.enable = true;

  # system configuration
  security.polkit.enable = true;

  # TODO monitor setup
  # dual boot
  #boot.loader.grub = {
  #  enable = true;
  #  device = "nodev";
  #  useOSProber = true;
  #};

  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ amdvlk ];
  hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  # hw config

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/829c018e-f7ba-4a46-9c4a-8e40a3eb888c";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A1A2-9DFF";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/c2347c5c-1f6d-42e5-867a-91a3e12bb7ab"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
