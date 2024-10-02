{
  pkgs,
  config,
  lib,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit pkgs lib config;};
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    initExtra = ''
      function precmd() {
        print -Pn "\e]133;A\e\\"
        if ! builtin zle; then
        print -n "\e]133;D\e\\"
        fi
      }
      function preexec {
        print -n "\e]133;C\e\\"
      }
      function osc7-pwd() {
        emulate -L zsh
        setopt extendedglob
        local LC_ALL=C
        printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
      }
      function chpwd-osc7-pwd() {
        (( ZSH_SUBSHELL )) || osc7-pwd
      }
      add-zsh-hook -Uz chpwd chpwd-osc7-pwd

      bindkey '^[[Z' reverse-menu-complete
      bindkey "^?" autopair-delete
      bindkey '^H' backward-delete-word

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      function ,() {
        com=$1 && shift
        nix run nixpkgs#$com -- $*
      }

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

      unsetopt beep extendedglob notify
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list "m:{a-z0A-Z}={A-Za-z}"
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' verbose true
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      zstyle ':completion:*' use-cache on

    '';
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern"];
      patterns = {"rm -rf *" = "fg=0,bg=3";};
      styles = {
        default = "fg=4";
        double-hyphen-option = "fg=6";
        single-hyphen-option = "fg=6";
        assign = "fg=10,bold";
      };
    };
    historySubstringSearch.enable = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    history.size = 10000000;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      PROMPT_EOL_MARK = "󱞥";
    };
    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    shellAliases = {
      nv = "nvim";
      v = "emacs -nw";
      sr = "cd $(echo $NIX_PATH | cut -f2 -d=)";
      up = "nh os switch";
      del = "nh clean all --nogcroots";
      ss = "nh search";
      ts = "nix-shell --run zsh -p";
      qq = "nvd list";
      fl = "nix flake";
      im = "timg -p s";
      ns = "nsxiv";
      pm = "pulsemixer";
      s = "sudo systemctl";
      cat = "bat -p -P";
      g = "git";
      rm = "rm -Ivr";
      mv = "mv -iv";
      cp = "cp -ivr";
      c = "clear";
      df = "duf -hide special";
      mkdir = "mkdir -pv";
      d = "sudo";
      du = "dust";
      cd = "z";
      setwall = "swww img -f Mitchell -t any --transition-fps 75 --transition-duration 2";
      f = "free -h";
      ko = "pkill";
    };
    autocd = true;
  };
  programs.starship = {
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
}
