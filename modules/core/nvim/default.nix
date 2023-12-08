{ pkgs, ... }: {
  home-manager.users.gurki = {
    xdg.configFile = { "nvim/lua".source = ./lua; };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      #extraConfig = '''';
    };
  };
}