{
  pkgs,
  lib,
  args ? "-no-warn -no-autocorrect -b",
  langs ? "eng+jpn+jpn_vert+kor+kor_vert+deu+rus",
}: let
  inherit (pkgs) writeShellScript grim slurp tesseract5;
  _ = lib.getExe;
in {
  wlOcr = writeShellScript "wlOcr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} -l ${langs} - - | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  transLiner = writeShellScript "transLiner" ''
    wl-paste | trans ${args} | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  openMedia = writeShellScript "openMedia" ''
    case "$(wl-paste --list-types)" in
      *text*)
        notify-send 'Opening URL'
        mpv $(wl-paste)
        ;;
      *image*)
        notify-send 'Opening image'
        wl-paste | mpv -
        ;;
      *)
        notify-send 'Clipboard content is not an image'
        exit 1
        ;;
        esac
  '';
  copyTwit = writeShellScript "copyTwit" ''
    url=$(wl-paste | sed 's/x.com/twitter.com/g')
    notify-send "Downloading..."
    ! yt-dlp -f "best[ext=mp4]" --force-overwrites "$url" --paths "/tmp" --output send.mp4 && notify-send "Not a valid URL !!" && exit 1
    wl-copy -t text/uri-list "file:///tmp/send.mp4" && notify-send "Copied to clipboard"
  '';
  rofiGuard = writeShellScript "rofiGuard" ''
    build_rofi() {
      gv="$(systemctl list-unit-files --type=service --all | sed -nE 's/^(wg-quick.+).service.*/\1/p')"
      echo "$gv" | rofi -filter -dmenu -p "󰖂" -mesg "$1" -l "$(echo "$gv" | wc -l)"
    }
    act_on_rofi() {
      [ -z "$1" ] && exit 1
      [ "$1" = "$2" ] && sudo systemctl stop "$1" && notify-send "Switched OFF" "$1" && exit 0
      [ -n "$2" ] && sudo systemctl stop "$2" && notify-send "Switched OFF" "$2"
      sudo systemctl start "$1" && notify "ON" "$1" && exit 0
    }
    if [ -z "$(sudo wg)" ]; then
      act_on_rofi "$(build_rofi "STATUS: <b>OFF</b>")"
    else
      ga=$(systemctl list-units --type=service | sed -nE 's/(wg-quick.+).service.*/\1/p' | tr -d ' ')
      act_on_rofi "$(build_rofi "STATUS: <b>ON</b> <i>$ga</i>")" "$ga"
    fi
  '';
}
