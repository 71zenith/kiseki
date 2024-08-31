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
    mkdir -p $out/share/fcitx5/themes/FluentDark/
    cp -r FluentDark/* $out/share/fcitx5/themes/FluentDark/

    mkdir -p $out/share/fcitx5/themes/FluentDark-solid/
    cp -r FluentDark-solid/* $out/share/fcitx5/themes/FluentDark-solid/
  '';

  meta = {
    description = "Fcitx5 theme based on Fluent Dark Colors";
    homepage = "https://github.com/Reverier-Xu/FluentDark-fcitx5";
    maintainers = [lib.maintainers._71zenith];
    platforms = lib.platforms.all;
  };
})
