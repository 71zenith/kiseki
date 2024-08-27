{
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,
  lib,
  gnugrep,
  gnused,
  curl,
  catt,
  syncplay,
  ffmpeg,
  fzf,
  aria2,
  withMpv ? true,
  mpv,
  withVlc ? false,
  vlc,
  withIina ? false,
  iina,
  chromecastSupport ? false,
  syncSupport ? false,
  nixName,
}:
assert withMpv || withVlc || withIina;
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ani-cli";
    version = "4.9";

    src = fetchFromGitHub {
      owner = "pystardust";
      repo = finalAttrs.pname;
      rev = "v${finalAttrs.version}";
      hash = "sha256-7zuepWTtrFp9RW3zTSjPzyJ9e+09PdKgwcnV+DqPEUY=";
    };

    nativeBuildInputs = [makeWrapper];
    buildInputs = [] ++ lib.optional withMpv mpv;

    runtimeDependencies = let
      player =
        []
        ++ lib.optional withVlc vlc
        ++ lib.optional withIina iina;
    in
      [gnugrep gnused curl fzf ffmpeg aria2]
      ++ player
      ++ lib.optional chromecastSupport catt
      ++ lib.optional syncSupport syncplay;

    installPhase = ''
      runHook preInstall

      install -Dm755 ani-cli $out/bin/ani-cli
      wrapProgram $out/bin/ani-cli \
        --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDependencies}
      mkdir -p "$out/share/man/man1/"
      cp *1 "$out/share/man/man1/"

      runHook postInstall
    '';
    meta = {
      homepage = "https://github.com/pystardust/ani-cli";
      description = "A cli tool to browse and play anime";
      license = lib.licenses.gpl3Plus;
      maintainers = [nixName];
      platforms = lib.platforms.unix;
      mainProgram = "ani-cli";
    };
  })
