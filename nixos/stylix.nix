{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = "${pkgs.my-walls}/share/wallpapers/oxocarbon.png";
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = rec {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = serif;
      monospace = {
        package = pkgs._0x-proto;
        name = "0xProto";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 15;
      };
    };
    opacity = {
      terminal = 0.87;
      popups = 0.87;
      desktop = 0.87;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
  fonts = {
    fontconfig.defaultFonts = rec {
      sansSerif = [config.stylix.fonts.serif.name "Mamelon"];
      serif = sansSerif;
      monospace = [config.stylix.fonts.monospace.name "Fantasque Sans Mono"];
    };
    packages = with pkgs; [
      my-fonts
      fantasque-sans-mono
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
