{ config, modulesPath, inputs, lib, pkgs, ...}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/core
  ];

  system.stateVersion = "23.11";
  home-manager.users.gurki.home.stateVersion = "23.11";
  
  # user configuration
  networking.hostName = "gurki-laptop";
  users.users.gurki = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "plugdev" ];
    packages = with pkgs; [
      discord
      vscode
      tailscale
      jetbrains.idea-community
      rnote
      python3
      element-desktop
      geogebra
      temurin-jre-bin-17
      prismlauncher
      krita
    ];
  };

  ## tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # system configuration
  ## Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  ## Enable the X11 windowing system.
  services.xserver.enable = true;

  ## Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  ## Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ac2d0630-d5b1-4ce6-9f95-654ced7cebed";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7621-D076";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/281c2c2b-3bcb-47d9-81da-1565e4dbcba5"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
