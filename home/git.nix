{
  pkgs,
  myUserName,
  mailId,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = myUserName;
    userEmail = mailId;
    aliases = {
      co = "checkout";
      cd = "clone --depth=1";
      c = "commit -m";
      w = "switch";
      ca = "commit --amend";
      cn = "commit --amend --no-edit";
      a = "add -v";
      r = "restore";
      v = "revert";
      va = "revert --abort";
      pl = "pull --rebase";
      l = "log";
      cm = "checkout master";
      f = "reset --hard";
      rs = "restore --staged";
      lp = "log -p";
      ls = "log --stat";
      s = "status";
      q = "stash";
      qa = "stash apply";
      qc = "stash clear";
      p = "push -v";
      pf = "push -v --force";
      d = "diff";
      dc = "diff --cached";
      b = "rebase";
      ba = "rebase --abort";
      bc = "rebase --continue";
      cl = "clone";
    };
    difftastic = {
      enable = true;
      background = "dark";
      display = "inline";
    };
    ignores = [
      "*~"
      "*.swp"
      "*result*"
      ".direnv"
      "tmp"
    ];
    extraConfig = {
      core = {
        whitespace = "trailing-space,space-before-tab";
      };
      pull.ff = "only";
      branch.autoSetupMerge = true;
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
        followTags = true;
      };
      url = {
        "https://github.com/".insteadOf = "github:";
        "ssh://git@github.com/".pushInsteadOf = "github:";
      };
    };
  };
}
