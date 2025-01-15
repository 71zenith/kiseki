{
  pkgs,
  config,
  ...
}: {
  programs.mpv = {
    enable = true;
    config = {
      osc = "no";
      osd-bar = "no";
      profile = "gpu-hq";
      vo = "gpu";
      loop-file = "inf";
      hwdec = "vaapi";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      save-position-on-quit = "yes";
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "oversample";
      slang = "en,eng";
      alang = "ja,jp,jpn,en,eng";
      image-display-duration = "inf";
      osd-font = config.stylix.fonts.monospace.name;
      cache = "yes";
      demuxer-max-bytes = "300MiB";
      demuxer-max-back-bytes = "50MiB";
      demuxer-readahead-secs = "60";
      border = "no";
      keepaspect-window = "no";
      screenshot-directory = config.xdg.userDirs.pictures;
    };
    scriptOpts = {
      webtorrent.path = "${config.xdg.cacheHome}/mpv";
      youtube-search = {
        key_youtube_search_replace = "CTRL+SHIFT+s";
        key_youtube_music_search_replace = "";
        key_youtube_search_append = "";
        key_youtube_music_search_append = "";
        key_search_results_update = "";
        search_results = 1;
        osd_message_duration = 0;
      };
    };
    bindings = {
      "l" = "seek 5";
      "h" = "seek -5";
      "a" = "add chapter -1";
      "d" = "add chapter 1";
      "k" = "seek 60";
      "j" = "seek -60";
      "]" = "add speed 0.1";
      "[" = "add speed -0.1";
      "w" = "cycle-values speed 1 1.5 2";
      "g" = "script-binding memo-history";
      "tab" = "script-binding uosc/toggle-ui";
      "c" = "script-binding uosc/chapters";
      "q" = "script-binding uosc/stream-quality";
      "t" = "script-binding uosc/audio";
      "shift+f" = "script-binding uosc/keybinds";
      "shift+p" = "script-binding uosc/items";
      "s" = "script-binding uosc/subtitles";
      "u" = "script-message-to youtube_upnext menu";
      "shift+s" = "async screenshot";
      "CTRL+1" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
      "CTRL+2" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
      "CTRL+3" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
      "CTRL+4" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
      "CTRL+5" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
      "CTRL+6" = ''
        no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
      "CTRL+0" = ''
        no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
    };
    scripts = with pkgs.mpvScripts;
      [
        mpris
        # autoload
        youtube-upnext
        memo
        uosc
        webtorrent-mpv-hook
        # thumbfast
        sponsorblock
      ]
      ++ (with pkgs; [mpv-youtube-search]);
  };
}
