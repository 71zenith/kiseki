{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cmake,
  # deps for audio backends
  alsa-lib,
  libpulseaudio,
  portaudio,
  libjack2,
  SDL2,
  gst_all_1,
  dbus,
  fontconfig,
  libsixel,
  # build options
  withStreaming ? true,
  withDaemon ? true,
  withAudioBackend ? "rodio", # alsa, pulseaudio, rodio, portaudio, jackaudio, rodiojack, sdl
  withMediaControl ? true,
  withLyrics ? true,
  withImage ? true,
  withNotify ? true,
  withSixel ? true,
  withFuzzy ? true,
  stdenv,
  darwin,
  makeBinaryWrapper,
  nixName,
}:
assert lib.assertOneOf "withAudioBackend" withAudioBackend ["" "alsa" "pulseaudio" "rodio" "portaudio" "jackaudio" "rodiojack" "sdl" "gstreamer"];
  rustPlatform.buildRustPackage rec {
    pname = "spotify-player";
    version = "unstable-2024-08-04";

    src = fetchFromGitHub {
      owner = "aome510";
      repo = pname;
      rev = "84e5c29891593c9e3fd3e1ae5ec6aeacd4bddc92";
      hash = "sha256-ngM2AD3wvanvy+v+gSAr8gK0VRCk7cW8USGZT4+07G8=";
    };

    cargoHash = "sha256-X2Lwx5gI4E7zzawT9oS5BxNCH6HJudtb69u5HtRhKpY=";

    nativeBuildInputs =
      [
        pkg-config
        cmake
        rustPlatform.bindgenHook
      ]
      ++ lib.optionals stdenv.isDarwin [
        makeBinaryWrapper
      ];

    buildInputs =
      [
        openssl
        dbus
        fontconfig
      ]
      ++ lib.optionals withSixel [libsixel]
      ++ lib.optionals (withAudioBackend == "alsa") [alsa-lib]
      ++ lib.optionals (withAudioBackend == "pulseaudio") [libpulseaudio]
      ++ lib.optionals (withAudioBackend == "rodio" && stdenv.isLinux) [alsa-lib]
      ++ lib.optionals (withAudioBackend == "portaudio") [portaudio]
      ++ lib.optionals (withAudioBackend == "jackaudio") [libjack2]
      ++ lib.optionals (withAudioBackend == "rodiojack") [alsa-lib libjack2]
      ++ lib.optionals (withAudioBackend == "sdl") [SDL2]
      ++ lib.optionals (withAudioBackend == "gstreamer") [gst_all_1.gstreamer gst_all_1.gst-devtools gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good]
      ++ lib.optionals (stdenv.isDarwin && withMediaControl) [darwin.apple_sdk.frameworks.MediaPlayer]
      ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        AppKit
        AudioUnit
        Cocoa
      ]);

    buildNoDefaultFeatures = true;

    buildFeatures =
      lib.optionals (withAudioBackend != "") ["${withAudioBackend}-backend"]
      ++ lib.optionals withMediaControl ["media-control"]
      ++ lib.optionals withImage ["image"]
      ++ lib.optionals withLyrics ["lyric-finder"]
      ++ lib.optionals withDaemon ["daemon"]
      ++ lib.optionals withNotify ["notify"]
      ++ lib.optionals withStreaming ["streaming"]
      ++ lib.optionals withSixel ["sixel"]
      ++ lib.optionals withFuzzy ["fzf"];

    # sixel-sys is dynamically linked to libsixel
    postInstall = lib.optionals (stdenv.isDarwin && withSixel) ''
      wrapProgram $out/bin/spotify_player \
        --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [libsixel]}"
    '';

    meta = {
      description = "A terminal spotify player that has feature parity with the official client";
      homepage = "https://github.com/aome510/spotify-player";
      changelog = "https://github.com/aome510/spotify-player/releases/tag/v${version}";
      mainProgram = "spotify_player";
      license = lib.licenses.mit;
      maintainers = [nixName];
    };
  }
