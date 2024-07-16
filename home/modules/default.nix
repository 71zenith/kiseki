{
  disabledModules = ["programs/spotify-player.nix"];
  imports = [
    ./iamb.nix
    ./satty.nix
    ./neovide.nix
    ./spotify-player.nix
  ];
}
