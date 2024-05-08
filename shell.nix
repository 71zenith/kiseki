{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [lolcat];
  # NOTE: fancy welcome
  shellHook = ''
    echo "1337 h4x0ring..." | lolcat
  '';
}
