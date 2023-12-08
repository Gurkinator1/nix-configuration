{pkgs, ...}: {
  # We need to enable zsh system-wide even when it's managed
  # by home-manager as some files will not be sourced otherwise.
  programs.zsh.enable = true;

  # Configure zsh as the global shell for all users since there's
  # not really a point in using other shells alongside it anyway.
  users.defaultUserShell = pkgs.zsh;

  home-manager.users.gurki = {
    programs.zsh.oh-my-zsh = {
      enable = true;
    plugins = with pkgs; [
      "sudo"
      "git"
      (zshPlugin zsh-syntax-highlighting)
      (zshPlugin zsh-history-substring-search)
    ];
      theme = "af-magic";

      shellAliases = with pkgs; {
        cat = "${pkgs.bat.outPath}/bin/bat";
        diff = "diff --color=auto";
        rebuild = "sudo nixos-rebuild switch";
      };
    };
  };

}
