{lib}: self: super: let
  wrapElectron = packageName:
    super.${packageName}.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [super.makeWrapper];
      postFixup = ''
        ${oldAttrs.postFixup or ""}
        wrapProgram $out/bin/${packageName} \
          --add-flags "--disable-gpu-compositing"
      '';
    });
in {
  yazi-plugins = self.callPackage ./yazi-plugins.nix {};
  fcitx5-fluent = self.callPackage ./fcitx5-fluent.nix {};
  ani-cli = self.callPackage ./ani-cli.nix {};

  ani-skip = self.mpvScripts.callPackage ./ani-skip.nix {};
  mpv-youtube-search = self.mpvScripts.callPackage ./mpv-youtube-search.nix {};

  vesktop = wrapElectron "vesktop";
  spotify = wrapElectron "spotify";
  logseq = wrapElectron "logseq";

  dra-cla = (super.dra-cla.override {mpv = null;}).overrideAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "CoolnsX";
      repo = oldAttrs.pname;
      rev = "24d7eaa5d433bc2cbbba4f23552cd812506fefee";
      hash = "sha256-BmBQSkLSq+BaxkzXEy3hlI3qNq2NCIoGKDKt7gyDz+s=";
    };
  });

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

  _0xproto = super._0xproto.overrideAttrs (oldAttrs: {
    version = "2.201";
    src = super.fetchzip {
      url = "https://github.com/0xType/0xProto/releases/download/${oldAttrs.version}/0xProto_${builtins.replaceStrings ["."] ["_"] oldAttrs.version}.zip";
      hash = "sha256-hUQGCsktnun9924+k6ECQuQ1Ddl/qGmtuLWERh/vDpc=";
    };
  });

  spotify-player = super.spotify-player.overrideAttrs (oldAttrs: {
    version = "unstable-2024-09-27";
    src = super.fetchFromGitHub {
      owner = "aome510";
      repo = oldAttrs.pname;
      rev = "80006c62b5b80840819ec9afc7da1a7e4e75e98a";
      hash = "sha256-Fk0xltwE6eaQgwIli0EhvEUKUiBFHIhWIgNV0Q0nv+w=";
    };
  });

  sptlrx = super.sptlrx.overrideAttrs (oldAttrs: {
    version = "unstable-2024-07-23";
    src = super.fetchFromGitHub {
      owner = "raitonoberu";
      repo = oldAttrs.pname;
      rev = "c03f1cb220936a06dec44069bfb01bf66b72c3d4";
      hash = "sha256-6QaEx4pQnoELe6J/yukr+G0IhZxIjl4IF1cWzJYQVO4=";
    };
    vendorHash = "sha256-pExSQcYjqliZZg/91t52yk6UJ4QCbpToMpONIFUNkwc=";
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
  nitch = super.nitch.overrideAttrs {
    postPatch = ''
      substituteInPlace src/funcs/packages/getNixPkgs.nim \
        --replace-fail 'std/[strutils, osproc]' 'std/[strutils, osproc, os]' \
        --replace-fail '~/.nix-profile"' '/etc/profiles/per-user/" & getEnv("USER")'
    '';
  };
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
          ${lib.concatLines (lib.mapAttrsToList (old: new: "--replace-fail '${old}' '\\x${new}' \\") icons)}
      '';
    };
}
