{
  config,
  pkgs,
  lib,
}: let
  inherit (pkgs) writeShellScriptBin writeShellScript wtype tesseract5 socat;
  _ = lib.getExe;
in {
  wlOcr = writeShellScript "wlOcr" ''
    grimblast save area - | ${_ tesseract5} -l eng+jpn+jpn_vert+kor+kor_vert+deu+rus - - | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  transLiner = writeShellScript "transLiner" ''
    wl-paste | trans -no-warn -no-autocorrect -b -t en | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  openMedia = writeShellScript "openMedia" ''
    trap 'rm -rf /tmp/mpvsocket' EXIT TERM KILL
    case "$(wl-paste --list-types)" in
      *text*)
        notify-send 'Opening URL'
        if [ -e "$(wl-paste)" ]; then
          wl-paste | xargs -0 xdg-open || notify-send 'Clipboard content is not media'
        else
          if [ -e /tmp/mpvsocket ]; then
            echo "loadfile $(wl-paste)" | ${_ socat} - /tmp/mpvsocket
          else
            mpv "$(wl-paste)" --title="mpvplay" --no-resume-playback --input-ipc-server="/tmp/mpvsocket" || notify-send "Not a valid URL !!"
          fi
        fi
        ;;
      *image*)
        notify-send 'Opening image'
        wl-paste | mpv -
        ;;
      *)
        wl-paste | xargs -0 xdg-open || notify-send 'Clipboard content is not media'
        exit 1
        ;;
    esac
  '';
  copyVid = writeShellScript "copyVid" ''
    url=$(wl-paste | sed 's/x.com/twitter.com/g')
    notify-send "Downloading..."
    ! yt-dlp -f "best[ext=mp4]" --embed-thumbnail --force-overwrites "$url" --paths "/tmp" --output send.mp4 && notify-send "Not a valid URL !!" && exit 1
    wl-copy -t text/uri-list "file:///tmp/send.mp4" && notify-send "Copied to clipboard"
  '';
  rofiGuard = writeShellScript "rofiGuard" ''
    build_rofi() {
      gv="$(systemctl list-unit-files --type=service --all | sed -nE 's/^(wg-quick.+).service.*/\1/p')"
      echo "$gv" | rofi -theme-str 'window { width: 300px; }' -dmenu -p "󰖂" -mesg "$1" -l "$(echo "$gv" | wc -l) -filter"
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
  _4khd = writeShellScriptBin "4khd" ''
    player=debug
    while [ $# -gt 0 ]; do
      case "$1" in
        -d | --download ) player=download ;;
        -p | --player )
          [ "$#" -lt 2 ] && printf "\033[2K\r\033[1;31m%s\033[0m\n" "missing argument!" && exit 1
          player=$2
          shift
          ;;
        -h | --help)
          printf "%s\n" "''${0##*/} -d | --download | -p | --player | -h | --help"
          exit 0
          ;;
        *) query="''${query} ''${1}";;
      esac
      shift
    done
    [ -z "$query" ] && printf "%s\n" "''${0##*/} -d | --download | -p | --player | -h | --help" && exit 1
    for i in $query; do
      html=$(curl -Ls "$i" | tr -d '\0')
      links=$(printf "%s" "$html" | sed -nE 's|^(<p>)?<a href="([^"]*)"><img .*loading="lazy".*|\2|p' | sed 's|.*/-|https://img.4khd.com/-|')
      if ! printf "%s" "$i" | grep -Eq '/[0-9]$' ; then
        pages=$(printf "%s" "$html" | sed -nE 's/<li class="numpages"><a class="page-numbers.*">([^<]*).*/\1/p')

        for j in $pages; do
          extra_links=$(curl -Ls "''${i}/''${j}" | sed -nE 's|^(<p>)?<a href="([^"]*)"><img .*loading="lazy".*|\2|p' | sed 's|.*/-|https://img.4khd.com/-|')
          links="''${links}
          ''${extra_links}"
        done
      fi
      links=$(printf "%s\n" "$links" | tr -d ' ')
      case "$player" in
        debug) printf "%s\n" "$links" ;;
        download) printf "%s\n" "$links" | xargs -n1 -P5 curl -O ;;
        mpv) printf "%s\n" "$links" | xargs mpv ;;
      esac
    done
  '';
  clipShow = writeShellScript "clipShow" ''
    cliphist-rofi-img | rofi -dmenu -i -p '' -theme preview -theme-str 'element { children: [element-text]; } icon-current-entry { enabled: true; size: 35%; } window { width: 1500px; } listview { lines: 15; spacing: 5px; }' | cliphist decode | wl-copy
  '';
  fzfComp = writeShellScript "fzfComp" ''
    rm -rf /tmp/console 2>&1 >/dev/null
    while [ -z $input ]; do
      ${_ wtype} -M ctrl -M shift f -m ctrl -m shift
      input="$(tr ' ' '\n' < /tmp/console | tr -d \' | tr -d \" | tr -d \[ | tr -d \] | tr -d \{ | tr -d \} | tr -d \( | tr -d \) | sed 's|=|\n|' | tr -s '\n')"
    done
    IFS="
    "
    for i in $input; do
        [ -e "$i" ] && echo "$i"
    done | uniq
  '';
  epubOpen = writeShellScript "epubOpen" ''
    epubs=$(fd -e=epub . ~/kindle/)
    IFS="
    "
    open() {
      file=$(cat -)
      [ -n "$file" ] && zathura "$file.epub"
    }
    for i in $epubs; do
      image="$(dirname "$i")/cover.jpg"
      echo -en "''${i%.epub}\0icon\x1f$image\n"
    done | rofi -i -dmenu -display-column-separator "/" -display-columns 7 -theme preview -p "" -theme-str 'icon-current-entry { size: 35%;}' | open
  '';
  glavaShow = writeShellScript "glavaShow" ''
    id=$(pulsemixer -l | grep glava | sed -nE 's/.*ID: (.+?), Name.*/\1/p')
    ([ -n "$id" ] && pulsemixer --id $id --toggle-mute) || (tail -f /tmp/cover.info 2>/dev/null | glava --pipe=fg)
  '';
  floatToggle = writeShellScript "floatToggle" ''
    if [ -e "/tmp/hypr.float" ]; then
      hyprctl keyword windowrulev2 "unset,class:.*" && rm -rf /tmp/hypr.float
    else
      hyprctl keyword windowrulev2 "float,class:.*" && touch /tmp/hypr.float
    fi
    pkill -RTMIN+11 waybar
  '';
  openVNC = writeShellScript "openVNC" ''
    set -e
    wayvnc 0.0.0.0 &
    notify-send "Starting VNC session"
    wait
    trap 'notify-send "Ending VNC session"' EXIT
  '';
  copyPalette = let
    colorsWithNames = builtins.concatStringsSep "\n" (
      map
      (colorName: let
        colorValue = config.stylix.base16Scheme.palette.${colorName};
      in "<span foreground='#${toString colorValue}' weight='heavy'>#${toString colorValue} (${builtins.substring 4 2 colorName})</span>")
      (builtins.attrNames config.stylix.base16Scheme.palette)
    );
  in
    writeShellScript "copyPalette" ''
      echo "${colorsWithNames}" | rofi -i -dmenu -theme-str 'listview { columns: 2; lines: 8; } window { width: 500px; }' -markup-rows -p "🎨" -mesg "Choose a color" | cut -d\' -f2 | wl-copy && ([ "$1" = "glava" ] && echo "fg = $(wl-paste)" > /tmp/cover.info || eww update col="$(wl-paste)")
    '';
}
