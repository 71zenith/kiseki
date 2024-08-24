{nixName, ...}: self: super: {
  spotify-player = self.callPackage ./spotify-player.nix {inherit nixName;};
  yazi-plugins = self.callPackage ./yazi-plugins.nix {inherit nixName;};
  fcitx5-fluent = self.callPackage ./fcitx5-fluent.nix {inherit nixName;};
  ani-cli = self.callPackage ./ani-cli.nix {inherit nixName;};
  mpv-youtube-search = self.callPackage ./mpv-youtube-search.nix {inherit (super.mpvScripts) buildLua nixName;};

  #NOTE: fuck glava; version below has --pipe and **actually** builds (fuck meson too)
  glava = super.glava.overrideAttrs {
    src = super.fetchFromGitHub {
      owner = "wacossusca34";
      repo = "glava";
      rev = "c766c574a6e952aff96920f66892d0503281f8aa";
      sha256 = "sha256-Ay9p75z/bc2/2p6GkPiVGag0iMj/7w4loyr34iX98Z4=";
    };
  };
}
