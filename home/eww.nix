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
  xdg.configFile."eww/eww.yuck".text = ''
    (defwindow lyrics
              :monitor 0
              :geometry (geometry :y "70px" :anchor "bottom center")
              :stacking "bg"
        (wid :raw text :class "btn1"))
    (defwindow romaji
              :monitor 0
              :geometry (geometry :y "20px" :anchor "bottom center")
              :stacking "bg"
        (wid :raw romaji :class "btn2"))

    (defwidget wid [raw class]
      (box :spacing 0
        (button :class class
                :onclick "echo ''${raw} | wl-copy"
                :onrightclick "echo ''${raw} | wl-copy && setsid ${scripts.transLiner} &"
                (label :text raw))))

    (deflisten text "sptlrx pipe")
    (deflisten romaji "${genRomaji}")
  '';
  xdg.configFile."eww/eww.scss".text = with config.lib.stylix.colors.withHashtag; ''
    * {
      all: unset;
      margin: 20px;
      background-color: rgba(0,0,0,0);
      font-family: "Kaushan Script", "Rampart One";
    }
    .btn1 {
      font-size: 46px;
      color: ${base0A};
      &:hover {
        font-size: 50px;
        color: ${base0B};
      }
    }
    .btn2 {
      font-size: 36px;
      color: ${base0F};
    }
  '';
}
