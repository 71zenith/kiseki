{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "0x-proto";
  version = "2.201";

  src = fetchFromGitHub {
    owner = "0xType";
    repo = "0xProto";
    rev = finalAttrs.version;
    hash = "sha256-96y5WfESnxvbeW7uRCDIN3MegxNfd3r3IgFlFpJVz4M=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ fonts/*.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming font focused on source code legibility";
    homepage = "https://github.com/0xType/0xProto";
    changelog = "https://github.com/0xType/0xProto/blob/${src.rev}/CHANGELOG.md";
    license = licenses.ofl;
    maintainers = [maintainers._71zenith];
    mainProgram = "0x-proto";
    platforms = platforms.all;
  };
})
