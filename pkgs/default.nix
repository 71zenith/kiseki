self: super: {
  spotify-player = self.callPackage ./spotify-player.nix {};
  yazi-plugins = self.callPackage ./yazi-plugins.nix {};
  fcitx5-fluent = self.callPackage ./fcitx5-fluent.nix {};
  ani-cli = self.callPackage ./ani-cli.nix {};
}
