{
  disabledModules = ["programs/spotify-player.nix"];
  imports = [
    ./satty.nix
    ./sptlrx.nix
    ./neovide.nix
    ./spotify-player.nix
  ];
}
