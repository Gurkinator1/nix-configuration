{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;

    fontconfig.defaultFonts = {
      serif = ["Noto Sans" "Noto Sans Korean"];
      sansSerif = ["Noto Sans" "Noto Sans Korean"];
      monospace = ["FiraCode Nerd Font" "Fira Code"];
      emoji = ["Noto Color Emoji"];
    };

    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "Hack" "Noto"];})
      fira-code
      fira-code-symbols
      inconsolata
      jetbrains-mono
      julia-mono
      material-icons
      material-design-icons
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      ubuntu_font_family
      cascadia-code
    ];
  };
}