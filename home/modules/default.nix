{
  disabledModules = ["programs/spotify-player.nix"];
  imports = [
    ./iamb.nix
    ./satty.nix
    ./sptlrx.nix
    ./neovide.nix
    ./spotify-player.nix
  ];
}
