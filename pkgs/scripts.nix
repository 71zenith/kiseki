{
  pkgs,
  lib,
  args ? "-no-warn -no-autocorrect -b",
  langs ? "eng+jpn+jpn_vert+kor+kor_vert+deu+rus",
}: let
  inherit (pkgs) writeShellScriptBin writeShellScript grim slurp wtype tesseract5;
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
        mpv $(wl-paste) || notify-send "Not a valid URL !!"
        ;;
      *image*)
        notify-send 'Opening image'
        wl-paste | mpv -
        ;;
      *)
        notify-send 'Clipboard content is not media'
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
  disSend = writeShellScript "disSend" ''
    DISCORD_URL='https://discord.com/api/v10'
    DISCORD_SERVER_ID=931186431215435807
    DISCORD_TOKEN=$(cat /run/secrets/discord_token)
    send() {
      curl -s "$DISCORD_URL/channels/$chan_id/messages" -H "Authorization: $DISCORD_TOKEN" -H "Accept: application/json" -H "Content-Type: multipart/form-data" -X POST -F "$1"
    }
    selchan() {
      chans=$(curl -s "$DISCORD_URL/guilds/$DISCORD_SERVER_ID/channels" -H "Authorization: $DISCORD_TOKEN" | tr '{}' '\n' | sed -nE 's|.*"id":"([^"]*)".*type":0.*last_message_id.*"name":"([^"]*)".*|\1 \2|p' )
      chan=$(echo "$chans" | cut -d' ' -f2 | rofi -dmenu -i -p "Select Channel" -filter 2>/dev/null)
      chan_id=$(printf "%s" "$chans" | grep "$chan" | cut -d' ' -f1)
    }
    f=$(rofi -show filebrowser -filebrowser-command 'echo' -filebrowser-directory ~/. -selected-row 1 2>/dev/null)
    test -d "$f" && f=$(nsxiv -top "$f")
    [ -z "$f" ] && notify-send "Exiting!!!" && exit 1
    selchan
    IFS="
    "
    [ -n "$f" ] && for i in $f; do send "file=@$i"; done && notify-send "Uploaded $f to Discord in $chan" && exit 0
    notify-send "Exiting!!!" && exit 1
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
    export CLIP=true
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
    cliphist list | gawk "$prog" | rofi -dmenu -i -p '' -theme preview | cliphist decode | wl-copy
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
    export EPUB=true
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
    done | rofi -i -dmenu -display-column-separator "/" -display-columns 7 -theme preview -p "" | open
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
}
