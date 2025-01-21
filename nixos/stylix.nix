{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = "${pkgs.my-misc}/share/passive/oxocarbon.png";
    base16Scheme = {
      slug = "oxocarbon-dark";
      name = "Oxocarbon Dark";
      author = "shaunsingh/IBM";
      palette = {
        base00 = "161616";
        base01 = "262626";
        base02 = "393939";
        base03 = "525252";
        base04 = "dde1e6";
        base05 = "f2f4f8";
        base06 = "ffffff";
        base07 = "08bdba";
        base08 = "3ddbd9";
        base09 = "78a9ff";
        base0A = "ee5396";
        base0B = "33b1ff";
        base0C = "ff7eb6";
        base0D = "42be65";
        base0E = "be95ff";
        base0F = "82cfff";
      };
    };
    fonts = rec {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = serif;
      monospace = {
        package = pkgs.my-fonts;
        name = "Zenbones Proto";
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
      terminal = 0.90;
      popups = 0.85;
      desktop = 0.80;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
  fonts = {
    fontconfig.defaultFonts = rec {
      sansSerif = ["Yutapon coding Regular"];
      serif = sansSerif;
      monospace = ["Symbols Nerd Font Mono" "Yutapon coding Regular"];
    };
    packages = with pkgs; [
      my-fonts
      nerd-fonts.symbols-only
    ];
  };
}
