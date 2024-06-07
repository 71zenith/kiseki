{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fonts";
  version = "9";
  src = fetchFromGitHub {
    owner = "71zenith";
    repo = "fonts";
    rev = finalAttrs.version;
    hash = "sha256-YdZugI2K+gyuUWKSyeEK/Qes6sgFmF7jFGL/PbLM81o=";
  };
  installPhase = ''
    mkdir -p $out/share/fonts
    install -Dm444 * $out/share/fonts/
  '';
  meta = with lib; {
    description = "Collection of fonts";
    homepage = "http://github.com/71zenith/fonts";
    platforms = platforms.unix;
    maintainers = with maintainers; [zen];
  };
})
