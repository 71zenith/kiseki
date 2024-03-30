{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      initExtra = ''
        precmd() {
          print -Pn "\e]133;A\e\\"
        }
        function precmd {
          if ! builtin zle; then
          print -n "\e]133;D\e\\"
          fi
        }
        function preexec {
          print -n "\e]133;C\e\\"
        }
        function preexec {
          print -n '\e[5 q'
        }
        function osc7-pwd() {
          emulate -L zsh # also sets localoptions for us
          setopt extendedglob
          local LC_ALL=C
        }
        function chpwd-osc7-pwd() {
          (( ZSH_SUBSHELL )) || osc7-pwd
        }
        add-zsh-hook -Uz chpwd chpwd-osc7-pwd
        function preexec {
          print -n "\e]133;C\e\\"
        }
        zstyle ':completion:*' menu select
        bindkey '^[[Z' reverse-menu-complete
        bindkey '^?' backward-delete-char
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        export DIRENV_LOG_FORMAT=
        eval "$(direnv hook zsh)"
        eval "$(spotify_player generate zsh)"
      '';
      syntaxHighlighting = {enable = true;};
      historySubstringSearch = {enable = true;};
      history.size = 10000000;
      plugins = [
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
          file = "share/zsh/zsh-autopair/autopair.zsh";
        }
        {
          name = "zsh-powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      shellAliases = {
        up = "sudo nixos-rebuild switch --flake ~/nix#default";
        del = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
        pm = "pulsemixer";
        cat = "bat -p -P";
        g = "git";
        rm = "rm -Ivr";
        v = "emacs -nw";
        mv = "mv -iv";
        cp = "cp -ivr";
        c = "clear";
        df = "duf";
        mkdir = "mkdir -pv";
        d = "sudo";
        du = "dust";
        cd = "z";
        f = "free -h";
        ko = "pkill";
      };
      autocd = true;
      defaultKeymap = "viins";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {enable = true;};

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  home.file = {
    ".p10k.zsh".text = ''
      'builtin' 'local' '-a' 'p10k_config_opts'
      [[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
      [[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
      [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
      'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

      () {
        emulate -L zsh -o extended_glob

        unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

        [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

        local grey='242'
        local red='#FF5C57'
        local yellow='#F3F99D'
        local blue='#57C7FF'
        local magenta='#FF6AC1'
        local cyan='#9AEDFE'
        local white='#F1F1F0'

        typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
          dir                       # current directory
          vcs                       # git status
          prompt_char               # prompt symbol
                    )

        typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
          command_execution_time    # previous command duration
          virtualenv                # python virtual environment
          context                   # user@host
                                                     )

        typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
        typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
        typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
        typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol
        typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # no segment icons

        typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

        typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=$magenta
        typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=$red
        typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='λ'
        typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='Λ'
        typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='Λ'
        typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

        typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$grey
        typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
        typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

        typeset -g POWERLEVEL9K_DIR_FOREGROUND=$blue

        typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$white}%n%f%F{$grey}@%m%f"
        typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{$grey}%n@%m%f"
        typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

        typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
        typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
        typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
        typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow
        typeset -g POWERLEVEL9K_VCS_FOREGROUND=$grey

        typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=

        typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

        typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$cyan
        typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
        typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
        typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
        typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_ICON=
        typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
        typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
        typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
        typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
        typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION=''${''${''${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }

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
  };
}
