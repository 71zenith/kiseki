{
  config,
  pkgs,
  lib,
}: let
  inherit (pkgs) writeShellScriptBin writeShellScript grim slurp wtype tesseract5 socat htmlq;
  _ = lib.getExe;
in {
  wlOcr = writeShellScript "wlOcr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} -l eng+jpn+jpn_vert+kor+kor_vert+deu+rus - - | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  transLiner = writeShellScript "transLiner" ''
    wl-paste | trans -no-warn -no-autocorrect -b $* | wl-copy
    echo "$(wl-paste)"
    notify-send -- "$(wl-paste)"
  '';
  openMedia = writeShellScript "openMedia" ''
    case "$(wl-paste --list-types)" in
      *text*)
        notify-send 'Opening URL'
        if [ -e /tmp/mpvsocket ]; then
          echo "loadfile $(wl-paste)" | ${_ socat} - /tmp/mpvsocket
        else
          mpv "$(wl-paste)" --title="mpvplay" --no-resume-playback --input-ipc-server="/tmp/mpvsocket" || notify-send "Not a valid URL !!"
          rm -rf /tmp/mpvsocket
        fi
        ;;
      *image*)
        notify-send 'Opening image'
        wl-paste | mpv -
        ;;
      *)
        wl-paste | xdg-open || notify-send 'Clipboard content is not media'
        exit 1
        ;;
    esac
  '';
  copyTwit = writeShellScript "copyTwit" ''
    url=$(wl-paste | sed 's/x.com/twitter.com/g')
    notify-send "Downloading..."
    ! yt-dlp -f "best[ext=mp4]" --embed-thumbnail --force-overwrites "$url" --paths "/tmp" --output send.mp4 && notify-send "Not a valid URL !!" && exit 1
    wl-copy -t text/uri-list "file:///tmp/send.mp4" && notify-send "Copied to clipboard"
  '';
  rofiGuard = writeShellScript "rofiGuard" ''
    build_rofi() {
      gv="$(systemctl list-unit-files --type=service --all | sed -nE 's/^(wg-quick.+).service.*/\1/p')"
      echo "$gv" | rofi -dmenu -p "󰖂" -mesg "$1" -l "$(echo "$gv" | wc -l) -filter"
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
        download) printf "%s\n" "$links" | xargs -n1 -P5 curl -O  ;;
        mpv) printf "%s\n" "$links" | xargs mpv ;;
      esac
    done
  '';
  clipShow = writeShellScript "clipShow" ''
    tmp_dir="/tmp/cliphist"
    rm -rf "$tmp_dir"
    mkdir -p "$tmp_dir"

    read -r -d "" prog <<EOF
    /^[0-9]+\s<meta http-equiv=/ { next }
    match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
        system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
        print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
        next
    }
    1
    EOF
    cliphist list | gawk "$prog" | rofi -dmenu -i -p '' -theme preview -theme-str 'element { children: [element-text]; } icon-current-entry { enabled: true; size: 35%; } window { width: 1200px; } listview { lines: 15; spacing: 4px; }' | cliphist decode | wl-copy
  '';
  fzfComp = writeShellScript "fzfComp" ''
    rm -rf /tmp/comsole 2>&1 >/dev/null
    while [ -z $input ]; do
      ${_ wtype} -M ctrl -M shift f -m ctrl -m shift
      input="$(tr ' ' '\n' < /tmp/comsole | tr -d \' | tr -d \" | tr -d \[ | tr -d \] | tr -d \{ | tr -d \} | tr -d \( | tr -d \) | tr -s '\n')"
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
  changeCover = writeShellScript "changeCover" ''
    playerctl metadata --format '{{playerName}} {{mpris:artUrl}}' -F  --ignore-player firefox | while read -r player url; do
      if ([ "$player" = "mpv" ] || [ "$player" = "spotify_player" ]) && [ -n "$url" ]; then
        curl "$url" > /tmp/cover.jpg
        pkill -RTMIN+8 waybar
        magick /tmp/cover.jpg -resize 1x1\! -format "fg = #%[hex:u]\n" info: 2>/dev/null > /tmp/cover.info
      fi
    done
  '';
  openFoot = writeShellScript "openFoot" ''
    size=$1
    shift
    run=$*
    footclient -o "main.font=${config.stylix.fonts.monospace.name}:size=$size" $run
  '';
  torMpv = writeShellScript "torMpv" ''
    [ -z "$*" ] && query=$(rofi -dmenu -l 0 -p "" -mesg "Enter your search" | tr ' ' '+') || query=$(printf "%s" "$*" | tr ' ' '+')
    [ -z "$query" ] && exit 1
    srch="https://nyaa.land/?q=$query&f=0&c=1_0"
    notify-send "Searching nyaa"
    data=$(curl -Ls "$srch")
    title=$(echo "$data" | ${_ htmlq} tr 'td[colspan]' -r 'a[class]' a -a title)
    magnet=$(echo "$data" | ${_ htmlq} tr td a -a href | grep "^magnet:")
    details=$(echo "$data" | ${_ htmlq} tr 'td[class="text-center"]' -r 'td[data-timestamp]' -r a -w -t | grep -v '^$' | paste - - - - -d / | cut -d/ -f1,2,3 | sed -nE 's|([^/]+)/([^/]+)/([^/]+)$|[\1/\2/\3]|p')
    [ -z "$title" ] && notify-send "No search results" && exit 1
    paste <(echo "$title") <(echo "$details") <(echo "$magnet") -d '\t' | grep -v '/0/' \
      | rofi -i -no-custom -dmenu -theme-str 'window { width: 1000px; } element { children: [element-text];} listview { lines: 12;}' \
        -ellipsize-mode middle -p "" -matching glob \
        -display-column-separator "\t" -display-columns 1,2 | while read -r entry; do
      notify-send "Opening $(echo "$entry" | cut -f1)"
      setsid mpv "$(echo "$entry" | cut -f3)"
      exit 0
    done
    notify-send "No search results" && exit 1
  '';
}
