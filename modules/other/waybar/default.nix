{ config, pkgs, lib, ... }: {
  home-manager.users.gurki.programs.waybar = {
    enable = true;
    style = (builtins.readFile ./style.css);
    #  environment.etc."xdg/waybar/config.json" = {
    #source = ./config.jsonc
    #};
  };
}
