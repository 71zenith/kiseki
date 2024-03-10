{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "fonts";
  version = "3";

  src = fetchzip {
    url = "https://github.com/71zenith/fonts/archive/refs/tags/3.zip";
    stripRoot = false;
    hash = "sha256-eHYpOqe/ptnB1ICIVRTcSswSLC+O4Vp6jqDx7QPMBZ8=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    install -Dm444 fonts-3/* $out/share/fonts/
  '';
  meta = with lib; {
    description = "Collection of fonts";
    homepage = "http://github.com/71zenith/fonts";
    platforms = platforms.unix;
    maintainers = with maintainers; [ zen ];
  };
}
