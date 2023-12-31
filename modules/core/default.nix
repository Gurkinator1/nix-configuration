{ pkgs, lib, ... }: {
  imports = [
    ./nvim
    ./fonts.nix
    ./locale.nix
    ./zsh.nix
    ./git.nix
    ./sound.nix
    ./networking.nix
  ];

  programs.direnv.enable = true;

  users.users.gurki.packages = with pkgs; [
    firefox
    libreoffice-fresh
    thunderbird
    obsidian
    gimp
    zip
    unzip
    drawio
    discord
    vscode
    htop
    neofetch
    killall
  ];

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [ libusb qrencode home-manager os-prober ];
  };
}
