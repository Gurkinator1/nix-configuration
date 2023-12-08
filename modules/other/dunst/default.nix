{ pkgs, ... }: {
  home-manager.users.gurki.services.dunst = {
    enable = true;
    configFile = ./dunstrc;
  };
}
