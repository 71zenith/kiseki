{ pkgs, ... }: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtra =
        "bindkey '^H' backward-delete-char;bindkey '^?' backward-delete-char;source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme; [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
      syntaxHighlighting = { enable = true; };
      historySubstringSearch = { enable = true; };
      history.size = 10000000;
      shellAliases = {
        up = "sudo nixos-rebuild switch --flake ~/nix#default";
        del = "sudo nix-collect-garbage --delete-old";
        pm = "pulsemixer";
        rm = "rm -Ivr";
        mv = "mv -iv";
        cp = "cp -ivr";
        c = "clear";
        df = "duf";
        "d" = "sudo";
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

    bat = { enable = true; };

    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
