{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "google-sans";
  version = "4.8";

  src = fetchzip {
    url = "https://flutter.googlesource.com/gallery-assets/+archive/refs/heads/master/lib/fonts.tar.gz" ;
    hash = "sha256-Q879GxbRa+E6KSqG9BcNHH5M2I6RBwnzeeH6F1J1Cv4=";
    stripRoot = false;
  };

  installPhase = ''
      mkdir -p $out/share/fonts/google-sans
      install -Dm444 * $out/share/fonts/google-sans
  '';
  meta = with lib; {
    description = "Very Secret Font";
    homepage = "https://www.google.com/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ zen ];
  };
}
