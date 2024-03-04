{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "umeboshi";
  version = "0.1";

  src = fetchzip {
    url = "https://github.com/71zenith/umeboshi/archive/refs/tags/v1.0.zip";
    hash = "sha256-vry5OCtkvRqiVNZzXxPEnwUSI6T4hO+I3Wd28kPQ6NA=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/umeboshi
    install -Dm444 umeboshi_.ttf $out/share/fonts/umeboshi
  '';
  meta = with lib; {
    description = "Cute Japanese Font";
    homepage = "http://font.xxenxx.net/umeboshifont.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ zen ];
  };
}
