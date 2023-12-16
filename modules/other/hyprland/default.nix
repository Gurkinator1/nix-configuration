{ pkgs, ... }: {
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  home-manager.users.gurki.wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = (builtins.readFile ./hyprland.conf);

  };

  users.users.gurki.packages = with pkgs; [
    hyprland
    wofi
    dolphin
    kitty
    xwaylandvideobridge
    grim
    slurp
    wl-clipboard
    hyprpaper
  ];
}
