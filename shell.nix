let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      nil
      alejandra
      lolcat
    ];
    shellHook = ''
      echo "initiating nix tooling..." | lolcat
    '';
  }
