{ config, pkgs, stylix, ... }:

{
  stylix = {
    polarity = "dark";
    image = ../../resources/blue-blossom.jpg;
    base16Scheme = {
      base00 = "161616"; base01 = "262626"; base02 = "393939"; base03 = "525252";
      base04 = "dde1e6"; base05 = "f2f4f8"; base06 = "ffffff"; base07 = "08bdba";
      base08 = "3ddbd9"; base09 = "78a9ff"; base0A = "ee5396"; base0B = "33b1ff";
      base0C = "ff7eb6"; base0D = "42be65"; base0E = "be95ff"; base0F = "82cfff";
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.monaspace;
        name = "Monaspace Radon";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 14;
      };
    };

    opacity.terminal = 0.85;
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
}
