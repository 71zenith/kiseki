{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fonts";
  version = "8";
  src = fetchFromGitHub {
    owner = "71zenith";
    repo = "fonts";
    rev = finalAttrs.version;
    hash = "sha256-TG0e0tgwMAHrOBSM5LxWbve2CW2zJSawbZ8Ou1nYbfI=";
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
