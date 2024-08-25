{nixName, ...}: self: super: {
  yazi-plugins = self.callPackage ./yazi-plugins.nix {inherit nixName;};
  fcitx5-fluent = self.callPackage ./fcitx5-fluent.nix {inherit nixName;};
  ani-cli = self.callPackage ./ani-cli.nix {inherit nixName;};
  mpv-youtube-search = self.callPackage ./mpv-youtube-search.nix {inherit (super.mpvScripts) buildLua nixName;};

  spotify-player = super.spotify-player.overrideAttrs {
    version = "unstable-2024-08-25";
    src = super.fetchFromGitHub {
      owner = "aome510";
      repo = super.spotify-player.pname;
      rev = "9c47701cd6adc45c2d61721ccbdfae54ba67a523";
      hash = "sha256-FLOM8RKm8lWSqZSZm4nJwIJm/zbDQ8A7FoR7AJ+tkpc=";
    };
  };
  #NOTE: fuck glava; version below has --pipe and **actually** builds (fuck meson too)
  glava = super.glava.overrideAttrs {
    version = "unstable-no-meson";
    src = super.fetchFromGitHub {
      owner = "wacossusca34";
      repo = super.glava.pname;
      rev = "c766c574a6e952aff96920f66892d0503281f8aa";
      sha256 = "sha256-Ay9p75z/bc2/2p6GkPiVGag0iMj/7w4loyr34iX98Z4=";
    };
  };
}
