{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "fonts";
  version = "1";

  src = fetchzip {
    url = "https://github.com/71zenith/fonts/archive/refs/tags/1.zip";
    hash = "sha256-R+PlIjkqGvcyMopi4Yl5kGTeo2Tes35ZKxwYDruI7dA=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    install -Dm444 fonts-1/* $out/share/fonts/
  '';
  meta = with lib; {
    description = "Collection of fonts";
    homepage = "http://github.com/71zenith/fonts";
    platforms = platforms.unix;
    maintainers = with maintainers; [ zen ];
  };
}
