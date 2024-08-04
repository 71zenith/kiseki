<h2 align="center">:snowflake: flakes with minimal abstraction :snowflake:</h2>

<p align="center">
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-24.11-informational.svg?style=for-the-badge&logo=nixos&color=161616&logoColor=42be65&labelColor=dde1e6"></a>
    <img src="https://img.shields.io/github/last-commit/71zenith/nix-dots?style=for-the-badge&labelColor=dde1e6&color=161616"/>
    <img src="https://img.shields.io/github/repo-size/71zenith/nix-dots?style=for-the-badge&labelColor=dde1e6&color=161616"/>
  </a>
</p>

**BREAKING**
commits below [`b4000db`](https://github.com/71zenith/nix-dots/tree/b4000db955f1c73714f25b612128b5c3d2c2050f) shall not work due to moving of
wallpapers to separate repo.

**BREAKING**
commits after [`572bb57`](https://github.com/71zenith/nix-dots/tree/572bb5783334bc753c511c11b504746c8ed69ed5) have window borders removed
with dimming being a substitute.

![](https://github.com/71zenith/walls/blob/master/screenshot/screenshot14.png?raw=true)

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
- 🏠 custom [home-manager](https://github.com/nix-community/home-manager) modules for [iamb](https://github.com/ulyssa/iamb), [satty](https://github.com/gabm/Satty), [neovide](https://github.com/neovide/neovide)
- 📝 nixified vim with [nixvim](https://github.com/nix-community/nixvim)
- 🔑 passwords with [sops-nix](https://github.com/Mic92/sops-nix)
- 🎼 [spotify-player](https://github.com/aome510/spotify-player) support with [waybar](https://github.com/Alexays/Waybar) cover image and progress bar and [hyprland](https://github.com/hyprwm/Hyprland) special workspaces
- 📊 [glava](https://github.com/jarcode-foss/glava) with on the fly color based on current song
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
| [mpv](https://github.com/mpv-player/mpv)                       | media player (da goat)  |
| [rofi](https://github.com/davatorium/rofi)                     | custom launcher         |
| [satty](https://github.com/gabm/Satty)                         | annotation tool         |
| [calibre](https://github.com/kovidgoyal/calibre)               | ebook manager           |
| [fcitx5](https://github.com/fcitx/fcitx5)                      | japanese input          |
| [mako](https://github.com/emersion/mako)                       | notification daemon     |
| [nautilus](https://gitlab.gnome.org/GNOME/nautilus)            | gui file manager        |
| [neovim](https://github.com/neovim/neovim)                     | main text editor        |
| [iamb](https://github.com/ulyssa/iamb)                         | tui matrix client       |
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
| [geist-mono](https://vercel.com/font)                                   | monospace font                     |
| [kollektif](https://unblast.com/kollektif-sans-typeface/)               | "everything else" font             |
| [mamelon](https://moji-waku.com/mamelon/index.html)                     | "everything else" font for weebs   |
| [noto-color-emoji](https://fonts.google.com/specimen/Noto+Color+Emoji)  | "everything else" font for normies |
