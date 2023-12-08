{ pkgs, lib, ... }: {
  imports =
    [
      ./nvim
      ./fonts.nix
      ./locale.nix
      ./zsh.nix
      ./networking.nix
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
