{
  pkgs,
  config,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit pkgs config;};
  psrc = name: {
    inherit name;
    inherit (pkgs.fishPlugins."${name}") src;
  };
  exp = expansion: {
    inherit expansion;
    setCursor = true;
  };
in {
  stylix.targets.fish.enable = false;
  programs = {
    fish = {
      enable = true;
      plugins = [(psrc "autopair") (psrc "puffer")];
      interactiveShellInit = ''
        set -U fish_greeting
        set -U fish_cursor_insert line
        set -U fish_cursor_replace_one underscore
        set -U fish_cursor_replace underscore
        set -U com ${scripts.fzfComp}
      '';
      shellAbbrs = {
        fl = "nix flake";
        up = "nh os switch";
        del = "nh clean all --nogcroots";
        ss = "nh search";
        g = "git";
        rs = exp "nix run --impure nixpkgs#%";
        ts = exp "nix shell --impure nixpkgs#%";
        bs = exp "nix build --impure --print-out-paths nixpkgs#%";
      };
      shellAliases = {
        nv = "nvim";
        sr = "cd $(echo $NIX_PATH | cut -f2 -d=)";
        qq = "nvd list";
        im = "timg -p s";
        ns = "nsxiv";
        pm = "pulsemixer";
        s = "sudo systemctl";
        cat = "bat -p -P";
        rm = "rm -Ivr";
        mv = "mv -iv";
        cp = "xcp -vr";
        c = "clear";
        df = "duf -hide special";
        mkdir = "mkdir -pv";
        d = "sudo";
        du = "dust";
        setwall = "swww img -f Mitchell -t any --transition-fps 75 --transition-duration 2";
        f = "free -h";
        ko = "pkill";
      };
    };
    zsh = {
      enable = false;
      initExtra = ''
        function fzf-comp-widget() {
          local FZF_CTRL_T_COMMAND=${scripts.fzfComp}
          local FZF_CTRL_T_OPTS="--bind 'focus:jump' --bind 'space:jump,jump:accept' --tac"
          LBUFFER="''${LBUFFER}$(__fzf_select)"
          local ret=$?
          zle reset-prompt
          return $ret
        }
        zle -N fzf-comp-widget
        bindkey "^O" fzf-comp-widget
      '';
    };
    starship = {
      enable = true;
      settings = with config.lib.stylix.colors.withHashtag; {
        add_newline = false;
        character = {
          success_symbol = "[λ](${base0A})";
          error_symbol = "[λ](${base0C})";
          vimcmd_symbol = "[Λ](${base0A})";
        };

        directory = {
          style = base0B;
          truncation_length = 5;
          truncate_to_repo = false;
          read_only = "";
        };

        git_branch.format = "[$branch](${base0A})";
        git_state.style = base0D;
        git_status = {
          format = "[$all_status$ahead_behind](${base0B}) ";
          stashed = "";
        };

        nix_shell.format = "[$state](${base0F}) ";

        cmd_duration.format = "[$duration](${base08})";

        right_format = "$cmd_duration";
        format = "$directory$git_branch$git_state$git_status$nix_shell$character";
        scan_timeout = 10;
      };
    };
  };
}
