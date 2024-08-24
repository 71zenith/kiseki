{
  lib,
  stdenv,
  fetchFromGitHub,
  nixName,
}:
stdenv.mkDerivation {
  pname = "yazi-plugins";
  version = "unstable-2024-07-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "06e5fe1c7a2a4009c483b28b298700590e7b6784";
    hash = "sha256-jg8+GDsHOSIh8QPYxCvMde1c1D9M78El0PljSerkLQc=";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r *.yazi $out/share
  '';

  meta = {
    description = "Place code snippets from docs into this monorepo, so that users can update more easily via package manager";
    homepage = "https://github.com/yazi-rs/plugins";
    maintainers = [nixName];
    mainProgram = "yazi-plugins";
    platforms = lib.platforms.all;
  };
}
