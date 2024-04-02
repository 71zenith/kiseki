{lib , ...}:
{
  programs.git = {
    enable = true;
    userName = "zen";
    userEmail = "71zenith@proton.me";
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
    url = {
      "https://github.com/".insteadOf = "github:";
      "ssh://git@github.com/".pushInsteadOf = "github:";
    };
  };
}
