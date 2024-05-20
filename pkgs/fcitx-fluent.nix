{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-fluentdark";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "FluentDark-fcitx5";
    rev = finalAttrs.version;
    hash = "sha256-wefleY3dMM3rk1/cZn36n2WWLuRF9dTi3aeDDNiR6NU=";
  };

  installPhase = ''
    install -Dm644 FluentDark/arrow.png $out/share/fcitx5/themes/FluentDark/arrow.png
    install -Dm644 FluentDark/back.png $out/share/fcitx5/themes/FluentDark/back.png
    install -Dm644 FluentDark/next.png $out/share/fcitx5/themes/FluentDark/next.png
    install -Dm644 FluentDark/panel.png $out/share/fcitx5/themes/FluentDark/panel.png
    install -Dm644 FluentDark/radio.png $out/share/fcitx5/themes/FluentDark/radio.png
    install -Dm644 FluentDark/theme.conf $out/share/fcitx5/themes/FluentDark/theme.conf

    # FluentDark-solid
    install -Dm644 FluentDark-solid/arrow.png $out/share/fcitx5/themes/FluentDark-solid/arrow.png
    install -Dm644 FluentDark-solid/back.png $out/share/fcitx5/themes/FluentDark-solid/back.png
    install -Dm644 FluentDark-solid/next.png $out/share/fcitx5/themes/FluentDark-solid/next.png
    install -Dm644 FluentDark-solid/panel.png $out/share/fcitx5/themes/FluentDark-solid/panel.png
    install -Dm644 FluentDark-solid/radio.png $out/share/fcitx5/themes/FluentDark-solid/radio.png
    install -Dm644 FluentDark-solid/theme.conf $out/share/fcitx5/themes/FluentDark-solid/theme.conf
  '';

  meta = with lib; {
    description = "Fcitx5 theme based on Fluent Dark Colors";
    homepage = "https://github.com/Reverier-Xu/FluentDark-fcitx5";
    maintainers = with maintainers; [zen];
    platforms = platforms.all;
  };
})
