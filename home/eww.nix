{
  config,
  pkgs,
  lib,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit config lib pkgs;};
in {
  xdg.configFile."eww/eww.yuck".text = ''
    (defwindow lyrics
              :monitor 0
              :geometry (geometry
                :y "70px"
                :anchor "bottom center")
              :stacking "bg"
        (widget))

    (defwidget widget []
      (box
        (button :class "btn"
                :onclick "echo ''${text} | wl-copy"
                :onrightclick "echo ''${text} | wl-copy && setsid ${scripts.transLiner} -show-translation-phonetics N -show-alternatives N -show-prompt-message N -show-languages N -no-auto -no-init -no-ansi --verbose &"
                (label :text text))))

    (deflisten text "sptlrx pipe")
  '';
  xdg.configFile."eww/eww.scss".text = with config.lib.stylix.colors.withHashtag; ''
    * {
      all: unset;
      margin: 20px;
      background-color: rgba(0,0,0,0);
    }

    .btn {
      font-family: "Kaushan Script", "Rampart One";
      font-size: 46px;
      color: ${base0A};
      &:hover {
        font-size: 50px;
        color: ${base0B};
      }
    }
  '';
}
