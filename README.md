<h2 align="center">:snowflake: flakes with minimal abstraction :snowflake:</h2>

<p align="center">
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-24.11-informational.svg?style=for-the-badge&logo=nixos&color=161616&logoColor=42be65&labelColor=dde1e6"></a>
    <img src="https://img.shields.io/github/last-commit/71zenith/nis?style=for-the-badge&labelColor=dde1e6&color=161616"/>
    <img src="https://img.shields.io/github/repo-size/71zenith/nis?style=for-the-badge&labelColor=dde1e6&color=161616"/>
  </a>
</p>

*nis being a homophone of nix and the developer behind my favourite game franchise*[^1]


![](https://github.com/71zenith/walls/blob/master/screenshot/screenshot16.png?raw=true)

<details><summary><b>More screenshots(somewhat outdated)</b></summary>

![](https://github.com/71zenith/walls/blob/master/screenshot/workflow/1.png?raw=true)

![](https://github.com/71zenith/walls/blob/master/screenshot/workflow/2.png?raw=true)

![](https://github.com/71zenith/walls/blob/master/screenshot/workflow/3.png?raw=true)

![](https://github.com/71zenith/walls/blob/master/screenshot/workflow/4.png?raw=true)
</details>

previous iterations are in [assets/screenshot](https://github.com/71zenith/assets/tree/master/screenshot).

wallpapers are in [assets/active](https://github.com/71zenith/assets/tree/master/active).

## Highlights
- ⚙️  full [flakes](https://wiki.nixos.org/wiki/Flakes) setup with [nur](https://github.com/nix-community/NUR) for extra goodies
- 🎨 [oxocarbonified](https://github.com/nyoom-engineering/base16-oxocarbon) system with [stylix](https://github.com/danth/stylix)
- 🏠 custom [home-manager](https://github.com/nix-community/home-manager) modules for [satty](https://github.com/gabm/Satty), [neovide](https://github.com/neovide/neovide), [sptlrx](https://github.com/raitonoberu/sptlrx)
- 📝 nixified vim with [nixvim](https://github.com/nix-community/nixvim)
- 🔑 passwords with [sops-nix](https://github.com/Mic92/sops-nix)
- 🎼 [spotify-player](https://github.com/aome510/spotify-player) support with [waybar](https://github.com/Alexays/Waybar) cover image and progress bar and [hyprland](https://github.com/hyprwm/Hyprland) special workspaces
- 📊 [glava](https://github.com/jarcode-foss/glava) with on the fly color based on current song and synced lyrics support
- 🌐 [firefox](https://www.mozilla.org/en-US/firefox/) with declarative config
- 🚀 advanced [rofi](https://github.com/davatorium/rofi) scripts for vpn, calculations, sending files to discord, clipboard with images, wallpaper switcher
- 🈂️ niche scripts to open/download media from the internet, [OCR](https://github.com/tesseract-ocr/tesseract) and [translating text](https://github.com/soimort/translate-shell)
- 🐚 [zsh](http://www.zsh.org) and [foot](https://codeberg.org/dnkl/foot) setup to select command output, select files from output and navigate smartly.
- ▶️  [mpv](https://github.com/mpv-player/mpv) with upscaling, youtube helpers and fancy ui

<details><summary><b>Detailed Software usage</b></summary>

## Nix components
| Name                                                                   | Description                 |
|------------------------------------------------------------------------|-----------------------------|
| [flakes](https://wiki.nixos.org/wiki/Flakes)                           | channel manager             |
| [home-manager](https://github.com/nix-community/home-manager)          | manage dots                 |
| [stylix](https://github.com/danth/stylix)                              | auto themer                 |
| [nix-colors](https://github.com/Misterio77/nix-colors)                 | base 16 scheme              |
| [nixvim](https://github.com/nix-community/nixvim)                      | nvim config in nix          |
| [nur](https://github.com/nix-community/NUR)                            | nix user repository         |
| [nh](https://github.com/viperML/nh)                                    | nix helper                  |
| [sops-nix](https://github.com/Mic92/sops-nix)                          | secrets manager             |
| [nix-output-monitor](https://github.com/maralorn/nix-output-monitor)   | fancy nix output            |
| [direnv](https://github.com/nix-community/nix-direnv)                  | auto env switcher           |


## Programs
| Name                                                           | Description             |
|----------------------------------------------------------------|-------------------------|
| [hyprland](https://github.com/hyprwm/Hyprland)                 | compositor              |
| [firefox](https://www.mozilla.org/en-US/firefox/)              | web browser             |
| [neovide](https://github.com/neovide/neovide)                  | neovim gui              |
| [foot](https://codeberg.org/dnkl/foot)                         | terminal                |
| [zathura](https://pwmt.org/projects/zathura)                   | pdf/epub viewer         |
| [waybar](https://github.com/Alexays/Waybar)                    | status bar              |
| [mpv](https://github.com/mpv-player/mpv)                       | media player (da goat)  |
| [rofi](https://github.com/davatorium/rofi)                     | custom launcher         |
| [satty](https://github.com/gabm/Satty)                         | annotation tool         |
| [calibre](https://github.com/kovidgoyal/calibre)               | ebook manager           |
| [fcitx5](https://github.com/fcitx/fcitx5)                      | japanese input          |
| [mako](https://github.com/emersion/mako)                       | notification daemon     |
| [nautilus](https://gitlab.gnome.org/GNOME/nautilus)            | gui file manager        |
| [neovim](https://github.com/neovim/neovim)                     | main text editor        |
| [sptlrx](https://github.com/raitonoberu/sptlrx)                | lyrics tui              |
| [fzf](https://github.com/junegunn/fzf)                         | fuzzy finder            |
| [glava](https://github.com/jarcode-foss/glava)                 | audio visualizer        |
| [ani-cli](https://github.com/pystardust/ani-cli)               | anime tool              |
| [zsh](http://www.zsh.org)                                      | shell                   |
| [spotify-player](https://github.com/aome510/spotify-player)    | spotify tui (love it)   |
| [yazi](https://github.com/sxyazi/yazi)                         | tui file manager        |
| [btop](https://github.com/aristocratos/btop)                   | resource monitor        |


## Rusty tools
| Name                                               | Description    |
|----------------------------------------------------|----------------|
| [eza](https://github.com/eza-community/eza)        | ls alter       |
| [duf](https://github.com/muesli/duf)               | df alter       |
| [zoxide](https://github.com/ajeetdsouza/zoxide)    | smarter cd     |
| [dust](https://github.com/bootandy/dust)           | du alter       |
| [fd](https://github.com/sharkdp/fd)                | find alter     |
| [rg](https://github.com/BurstSushi/ripgrep)        | grep alter     |
| [sd](https://github.com/chmln/sd)                  | sed alter      |

</details>


## Standardised config
| Name                                                                    | Description                        |
|-------------------------------------------------------------------------|------------------------------------|
| [oxocarbon](https://github.com/nyoom-engineering/base16-oxocarbon)      | base16 theme                       |
| [miracode](https://github.com/IdreesInc/Miracode)                       | monospace font                     |
| [kollektif](https://unblast.com/kollektif-sans-typeface/)               | "everything else" font             |
| [mamelon](https://moji-waku.com/mamelon/index.html)                     | "everything else" font for weebs   |
| [noto-color-emoji](https://fonts.google.com/specimen/Noto+Color+Emoji)  | "everything else" font for normies |


## Resources
- standard nix stuff: [nixoswiki](https://wiki.nixos.org), [zero-to-nix](https://zero-to-nix.com), [discourse](https://discourse.nixos.org/).
- configs: [notashelf](https://github.com/notashelf/nyx), [diniamo](https://github.com/diniamo/niqs), [fufexan](https://github.com/fufexan/dotfiles), and anything that comes on [gh search](https://github.com/search?q=nix+dotfiles+lang%3ANix+&type=repositories).


[^1]: https://www.falcom.co.jp/kiseki
