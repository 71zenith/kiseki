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
  rofiGuard = writeShellScript "rofiGuard" ''
    get_status() {
      [ -z "$(sudo wg)" ] && return 1;
      return 0;
    }
    notify() {
      notify-send "Switched $1" "$2"
    }
    get_vpns() {
      systemctl list-unit-files --type=service --all | sed -nE 's/^(wg-quick.+).service.*/\1/p'
    }
    get_active() {
      systemctl list-units --type=service | sed -nE 's/(wg-quick.+).service.*/\1/p' | tr -d ' '
    }
    build_rofi() {
      gv="$(get_vpns)"
      echo "$gv" | rofi -dmenu -p "󰖂" -mesg "$1" -l "$(echo "$gv" | wc -l)"
    }
    act_on_rofi() {
      [ -z "$1" ] && exit 1
      ga=$(get_active)
      [ "$1" = "$ga" ] && sudo systemctl stop "$1" && notify "OFF" "$1" && exit 0
      [ -n "$ga" ] && sudo systemctl stop "$ga" && notify "OFF" "$ga"
      sudo systemctl start "$1" && notify "ON" "$1" && exit 0
    }
    if get_status; then
      act_on_rofi "$(build_rofi "STATUS: <b>ON</b> <i>$(get_active)</i>")"
    else
      act_on_rofi "$(build_rofi "STATUS: <b>OFF</b>")"
    fi
  '';
}
