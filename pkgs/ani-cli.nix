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
  installShellFiles,
}:
assert withMpv || withVlc || withIina;
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ani-cli";
    version = "2024-09-14";

    src = fetchFromGitHub {
      owner = "pystardust";
      repo = finalAttrs.pname;
      rev = "b9c6eb9e90a2e881208363b49c93271eeb2df8c7";
      hash = "sha256-cOkT2p1CeY41fNi5X9c+avCmptB8ZFzDsGWPlqZEFBo=";
    };

    nativeBuildInputs = [makeWrapper installShellFiles];
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
      installManPage ani-cli.1

      installShellCompletion --cmd ani-cli \
        --bash _ani-cli-bash \
        --zsh _ani-cli-zsh

      runHook postInstall
    '';
    meta = {
      homepage = "https://github.com/pystardust/ani-cli";
      description = "A cli tool to browse and play anime";
      license = lib.licenses.gpl3Plus;
      maintainers = [lib.maintainers._71zenith];
      platforms = lib.platforms.unix;
      mainProgram = "ani-cli";
    };
  })
