{
  disabledModules = ["programs/spotify-player.nix"];
  imports = [
    ./satty.nix
    ./sptlrx.nix
    ./spotify-player.nix
  ];
}
