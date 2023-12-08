{ pkgs, lib, ... }: {
  imports =
    [
      ./nvim
      ./fonts.nix
      ./locale.nix
      ./zsh.nix
      ./networking.nix
    ];

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
    ];

    environment = {
      pathsToLink = ["/share/zsh"];
      systemPackages = with pkgs; [
        libusb
        qrencode
        home-manager
      ];
    };
}
