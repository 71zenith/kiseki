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
}:
assert withMpv || withVlc || withIina;
  stdenvNoCC.mkDerivation rec {
    pname = "ani-cli";
    version = "unstable-2024-07-29";

    src = fetchFromGitHub {
      owner = "pystardust";
      repo = pname;
      rev = "267880fc936d8c2eccfb81944ec4854a7ea79a5a";
      hash = "sha256-DGy2zC2MAH4JHqqpDYyG84jlow5XBx73hM6QSDlUvVo=";
    };

    nativeBuildInputs = [makeWrapper];
    buildInputs =
      lib.optional withMpv mpv
      ++ lib.optional withVlc vlc
      ++ lib.optional withIina iina;
    runtimeDependencies =
      [gnugrep gnused curl fzf ffmpeg aria2]
      ++ lib.optional chromecastSupport catt
      ++ lib.optional syncSupport syncplay;
    installPhase = ''
      runHook preInstall

      install -Dm755 ani-cli $out/bin/ani-cli

      wrapProgram $out/bin/ani-cli \
        --prefix PATH : ${lib.makeBinPath runtimeDependencies}

      mkdir -p "$out/share/man/man1/"
      cp *1 "$out/share/man/man1/"

      runHook postInstall
    '';
    meta = with lib; {
      homepage = "https://github.com/pystardust/ani-cli";
      description = "A cli tool to browse and play anime";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [_71zenith];
      platforms = platforms.unix;
      mainProgram = "ani-cli";
    };
  }
