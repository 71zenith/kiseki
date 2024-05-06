{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [lolcat];
  # NOTE: fancy welcome
  shellHook = ''
    echo "initiating nix tooling..." | lolcat
  '';
}
