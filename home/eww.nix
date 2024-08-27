{config, ...}: {
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
      font-size: 48px;
      color: ${base0A};
      &:hover {
        color: ${base0B};
      }
    }
  '';
}
