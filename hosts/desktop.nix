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

  # system configuration
  security.polkit.enable = true;

  programs.dconf.enable = true;
  services = {
    xserver = {
      enable = true;
      layout = "de";
      xkbVariant = "";
      excludePackages = [ pkgs.xterm ];
      videoDrivers = [ "amdgpu" ];
      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
    tumbler.enable = true;
  };

  # TODO monitor setup

  # bootloader
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
    device = "/dev/disk/by-uuid/796c729b-3af7-4ed1-8c4a-ef5f008bd119";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2A56-2FBC";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/6b03a0f8-3c03-4cca-9cbf-115b0bf64c78"; }];

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
