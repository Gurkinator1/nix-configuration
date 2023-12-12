{ config, pkgs, lib, ... }: {
  
  home-manager.users.gurki = {
    programs.waybar = {
      enable = true;
      style = (builtins.readFile ./style.css);
      settings = {
        mainBar = {
          layer = "top";
	  position = "top";
	  height = 30;
	  output = ["DP-2" "HDMI-A-2"];
          modules-left = ["wlr/taskbar"];
	  modules-center = [];
	  modules-right = ["mpd" "temperature" "clock"];
        };
      };
    };
    services.mpd = {
      enable = true;
      musicDirectory = "${config.users.users.gurki.home}/music ";
    };
  };
}
