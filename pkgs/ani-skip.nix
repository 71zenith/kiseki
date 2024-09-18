{
  lib,
  buildLua,
  fetchFromGitHub,
}:
buildLua (finalAttrs: {
  pname = "ani-skip";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "synacktraa";
    repo = "ani-skip";
    rev = finalAttrs.version;
    hash = "sha256-VEEG3d6rwTAS7/+gBKHFKIg9zFfBu5eBOu6Z23621gM=";
  };

  passthru.scriptName = "skip.lua";
  postInstall = ''
    install -Dm755 ani-skip $out/bin/ani-skip
  '';

  meta = {
    description = "Bypass anime opening and ending sequences";
    homepage = "https://github.com/synacktraa/ani-skip";
    maintainers = [lib.maintainers._71zenith];
    mainProgram = "ani-skip";
    platforms = lib.platforms.all;
  };
})
