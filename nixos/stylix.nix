{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = "${pkgs.my-misc}/share/passive/oxocarbon.png";
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = rec {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = serif;
      monospace = {
        package = pkgs._0xproto;
        name = "0xProto";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 14;
        terminal = 15;
      };
    };
    opacity = {
      terminal = 0.8;
      popups = 0.8;
      desktop = 0.8;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
  fonts = {
    fontconfig.defaultFonts = rec {
      sansSerif = ["Mamelon 4 Hi"];
      serif = sansSerif;
      monospace = ["Geist Mono" "Symbols Nerd Font Mono" "Mamelon 4 Hi"];
    };
    packages = with pkgs; [
      my-fonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
