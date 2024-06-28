{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yazi-plugins";
  version = "unstable-2024-06-27";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "8d1aa6c7839b868973e34f6160055d824bb8c399";
    hash = "sha256-EuXkiK80a1roD6ZJs5KEvXELcQhhBtAH5VyfW9YFRc8=";
  };
  installPhase = ''
    mkdir -p $out/share
    cp -r *.yazi $out/share
  '';

  meta = with lib; {
    description = "Place code snippets from docs into this monorepo, so that users can update more easily via package manager";
    homepage = "https://github.com/yazi-rs/plugins";
    maintainers = with maintainers; [zen];
    mainProgram = "yazi-plugins";
    platforms = platforms.all;
  };
}
