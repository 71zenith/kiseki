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
  ani-skip,
  withVlc ? false,
  vlc,
  chromecastSupport ? false,
  syncSupport ? false,
  skipSupport ? true,
  installShellFiles,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ani-cli";
  version = "2024-09-19";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = finalAttrs.pname;
    rev = "5daa876a3c88544ee7a21aac4704e14be519c25a";
    hash = "sha256-4+iy4Y2FpNMx0jc6IUf179lxHSXg28btdjj37wthJRI=";
  };

  nativeBuildInputs = [makeWrapper installShellFiles];

  runtimeDependencies =
    [gnugrep gnused curl fzf ffmpeg aria2]
    ++ lib.optional withVlc vlc
    ++ lib.optional skipSupport ani-skip
    ++ lib.optional chromecastSupport catt
    ++ lib.optional syncSupport syncplay;

  installPhase = ''
    runHook preInstall

    install -Dm755 ani-cli $out/bin/ani-cli
    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDependencies}
    installManPage ani-cli.1

    installShellCompletion --cmd ani-cli \
      --zsh _ani-cli-zsh \
      --bash _ani-cli-bash

    runHook postInstall
  '';
  meta = with lib; {
    homepage = "https://github.com/pystardust/ani-cli";
    description = "A cli tool to browse and play anime";
    license = licenses.gpl3Plus;
    maintainers = [maintainers._71zenith];
    platforms = platforms.unix;
    mainProgram = "ani-cli";
  };
})
