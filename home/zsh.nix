{
  pkgs,
  config,
  lib,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit pkgs lib;};
in {
  programs = {
    zsh = {
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
          print -n '\e[5 q'
          print -Pn "\e]0;''${(q)1}\e\\"
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

        function fzf-comp-widget() {
          local FZF_CTRL_T_COMMAND=${scripts.fzfComp}
          local FZF_CTRL_T_OPTS="--bind 'focus:jump' --bind 'space:jump,jump:accept,jump-cancel:abort' --tac"
          LBUFFER="''${LBUFFER}$(__fzf_select)"
          local ret=$?
          zle reset-prompt
          return $ret
        }
        zle -N fzf-comp-widget
        bindkey "^O" fzf-comp-widget
        setopt interactive_comments nomatch
        unsetopt beep extendedglob notify
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list "m:{a-z0A-Z}={A-Za-z}"
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' completer _complete _ignored _approximate
        zstyle ':completion:*' verbose true
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
        zstyle ':completion:*' use-cache on
        _comp_options+=(globdots)
        [[ ! -f "''${ZDOTDIR}/p10k.zsh" ]] || source "''${ZDOTDIR}/p10k.zsh"
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
          name = "zsh-powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      shellAliases = {
        nv = "nvim";
        up = "nh os switch";
        del = "nh clean all --nogcroots";
        ss = "nh search";
        ts = "nix-shell --run zsh -p";
        nn = "nom build";
        qq = "nvd list";
        fl = "nix flake";
        pm = "pulsemixer";
        s = "sudo systemctl";
        cat = "bat -p -P";
        g = "git";
        rm = "rm -Ivr";
        mv = "mv -iv";
        cp = "cp -ivr";
        c = "clear";
        df = "duf";
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = ["--hyperlink"];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  xdg.configFile."zsh/p10k.zsh".text = ''
    'builtin' 'local' '-a' 'p10k_config_opts'
    [[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
    [[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
    [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
    'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

    () {
      emulate -L zsh -o extended_glob

      unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

      [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

      local grey='#525252'
      local red='#EE5396'
      local yellow='#42b65'
      local blue='#33B1FF'
      local magenta='#FF5C57'
      local cyan='#3DDBD9'
      local white='#F2F4F8'

      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        dir
        vcs
        nix_shell
        prompt_char
      )

      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        command_execution_time
        context
      )

      typeset -g POWERLEVEL9K_BACKGROUND=
      typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
      typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
      typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
      typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

      typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=$red
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=$magenta
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='λ'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='Λ'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='Λ'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

      typeset -g POWERLEVEL9K_DIR_FOREGROUND=$blue

      typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=$cyan

      typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$white}%n%f%F{$grey}@%m%f"
      typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{$grey}%n@%m%f"
      typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow

      typeset -g POWERLEVEL9K_VCS_FOREGROUND=$grey

      typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=

      typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

      typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$cyan
      typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
      typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
      typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
      typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED}_ICON=
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
      typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
      typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
      typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
      typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
      typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='​''${''${''${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }'

      typeset -g POWERLEVEL9K_TIME_FOREGROUND=$grey
      typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
      typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
      typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

      typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

      (( ! $+functions[p10k] )) || p10k reload
      }

      typeset -g POWERLEVEL9K_CONFIG_FILE=''${''${(%):-%x}:a}

      (( ''${#p10k_config_opts} )) && setopt ''${p10k_config_opts[@]}
      'builtin' 'unset' 'p10k_config_opts'
  '';
}
