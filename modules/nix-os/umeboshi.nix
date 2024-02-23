{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "umeboshi";
  version = "0.1";

  src = fetchzip {
    url = "http://font.xxenxx.net/zip/umeboshifont.zip";
    hash = "sha256-A5K5RmDTNOoLDW+o7dAbFAG9k/E3R7nPhX+TRG/Sqf0=";
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
