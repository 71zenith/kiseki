self: super: {
  fcitx5-fluent = self.callPackage ./fcitx5-fluent.nix {};
  yuzu = self.callPackage ./yuzu.nix {};
  mpv-youtube-search = self.mpvScripts.callPackage ./mpv-youtube-search.nix {};

  librewolf = super.librewolf.override {
    extraPrefs = ''
      pref("devtools.source-map.client-service.enabled", false);
      pref("librewolf.console.logging_disabled", true)
      pref("devtools.toolbox.host", "window");
      pref("privacy.resistFingerprinting", false);
      pref("webgl.disabled", false);
      pref("librewolf.debugger.force_detach", true);
    '';
  };

  onscripter-en = super.onscripter-en.overrideAttrs (oldAttrs: {
    version = "unstable-2024-07-21";
    src = super.fetchFromGitHub {
      owner = "Galladite27";
      repo = oldAttrs.pname;
      rev = "398b0328efe1e060301e7f8bfd2623c202646dd3";
      hash = "sha256-AqvKiqRzA5ICu1BT3PW7PCSwsgzFsg1DunNErKi4SoI=";
    };
  });

  sptlrx = super.sptlrx.overrideAttrs (oldAttrs: {
    version = "unstable-2024-10-27";
    src = super.fetchFromGitHub {
      owner = "raitonoberu";
      repo = oldAttrs.pname;
      rev = "be71eb5defec847b467f5d69d10f0037e71fdfbe";
      hash = "sha256-8dq7cxihrjSrJeOga7Jgzv5k4lbhavYJRi4uv60GkGc=";
    };
    vendorHash = "sha256-N02+B8btheskAAhWnPpFN/E/aarCxmCi07sYnfsYDmY=";
    checkPhase = null;
  });

  # NOTE: fuck glava; version below has --pipe and **actually** builds (fuck meson too)
  glava = super.glava.overrideAttrs (oldAttrs: {
    version = "unstable-no-meson";
    src = super.fetchFromGitHub {
      owner = "wacossusca34";
      repo = oldAttrs.pname;
      rev = "c766c574a6e952aff96920f66892d0503281f8aa";
      sha256 = "sha256-Ay9p75z/bc2/2p6GkPiVGag0iMj/7w4loyr34iX98Z4=";
    };
    postPatch = ''
      substituteInPlace shaders/bars.glsl \
        --replace-fail "#define BAR_WIDTH 5" "#define BAR_WIDTH 8" \
        --replace-fail "#define BAR_GAP 1" "#define BAR_GAP 2"
    '';
  });

  nix-output-monitor = let
    icons = {
      "↑" = "f062";
      "↓" = "f063";
      "⏱" = "f520";
      "⏵" = "f04b";
      "✔" = "f00c";
      "⏸" = "f04c";
      "⚠" = "f071";
      "∅" = "f1da";
      "∑" = "f04a0";
    };
  in
    super.nix-output-monitor.overrideAttrs {
      postPatch = ''
        substituteInPlace lib/NOM/Print.hs \
          ${super.lib.concatLines (super.lib.mapAttrsToList (old: new: "--replace-fail '${old}' '\\x${new}' \\") icons)}
      '';
    };
}
