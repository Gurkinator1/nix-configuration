{ config, modulesPath, inputs, lib, pkgs, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/core
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
  # TODO wayland & hyprland
  # TODO monitor setup
  # TODO hardware

}