{
  config,
  lib,
  pkgs,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit config lib pkgs;};
  genRomaji = pkgs.writeShellScript "genRomaji" ''
    sptlrx pipe | stdbuf -oL trans -show-translation N -show-translation-phonetics N -show-alternatives N -show-prompt-message N -show-languages N -no-auto -no-init -no-ansi | stdbuf -oL awk 'NR % 3 == 2 {printf "%s\\n\n", $0}'
  '';
in {
  xdg.configFile."eww/eww.yuck".text = with config.lib.stylix.colors.withHashtag; ''
    (defwindow lyrics
              :monitor 0
              :geometry (geometry :y "70px" :anchor "bottom center")
              :stacking "bg"
        (lyr))
    (defwindow romaji
              :monitor 0
              :geometry (geometry :y "20px" :anchor "bottom center")
              :stacking "bg"
        (rom))

    (defwidget lyr []
      (box :spacing 0
        (button :class "btn1"
                :onclick "echo ''${text} | wl-copy"
                :onrightclick "echo ''${text} | wl-copy && setsid ${scripts.transLiner} &"
                :css "button {color: ''${col}; &:hover {color: ${base0B};}}"
                (label :text text))))

    (defwidget rom []
      (box :spacing 0
        (button :class "btn2"
                (label :text romaji))))

    (defvar col "${base0A}")
    (deflisten text "sptlrx pipe")
    (deflisten romaji "${genRomaji}")
  '';
  xdg.configFile."eww/eww.scss".text = with config.lib.stylix.colors.withHashtag; ''
    * {
      all: unset;
      margin: 20px;
      background-color: rgba(0,0,0,0);
      font-family: "Kaushan Script", "Rampart One", "Typo_Deco", "Itim";
    }
    .btn1 {
      font-size: 46px;
      &:hover {
        font-size: 50px;
      }
    }
    .btn2 {
      font-size: 36px;
      color: ${base0F};
    }
  '';
}
