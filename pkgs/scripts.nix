{
  pkgs,
  lib,
  args ? "-no-warn -no-autocorrect -b",
  langs ? "eng+jpn+jpn_vert+kor+kor_vert+deu+rus",
}: let
  inherit (pkgs) writeShellScript grim libnotify slurp tesseract5 translate-shell wl-clipboard;
  _ = lib.getExe;
in {
  wlOcr = writeShellScript "wlOcr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} -l ${langs} - - | ${wl-clipboard}/bin/wl-copy
    echo "$(${wl-clipboard}/bin/wl-paste)"
    ${_ libnotify} -- "$(${wl-clipboard}/bin/wl-paste)"
  '';
  transLiner = writeShellScript "transLiner" ''
    ${wl-clipboard}/bin/wl-paste | ${_ translate-shell} ${args} | ${wl-clipboard}/bin/wl-copy
    echo "$(${wl-clipboard}/bin/wl-paste)"
    ${_ libnotify} -- "$(${wl-clipboard}/bin/wl-paste)"
  '';
  openMedia = writeShellScript "openMedia" ''
    case "$(${wl-clipboard}/bin/wl-paste --list-types)" in
      *text*)
        ${_ libnotify} 'Opening URL'
        mpv $(${wl-clipboard}/bin/wl-paste)
        ;;
      *image*)
        ${_ libnotify} 'Opening image'
        ${wl-clipboard}/bin/wl-paste | mpv -
        ;;
      *)
        ${_ libnotify} 'Clipboard content is not an image'
        exit 1
        ;;
        esac
  '';
}
