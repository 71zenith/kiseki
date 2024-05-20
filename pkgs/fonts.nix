{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fonts";
  version = "3";
  src = fetchFromGitHub {
    owner = "71zenith";
    repo = "fonts";
    rev = finalAttrs.version;
    hash = "sha256-ZLGRkbnJGgMademXXJX0tecuFkXyNZnstFY3cWnrZp0=";
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
