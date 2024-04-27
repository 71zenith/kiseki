{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [lolcat alejandra];

  shellHook = ''
    echo "initiating nix tooling..." | lolcat
  '';
}
