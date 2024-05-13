{pkgs, ...}: let
  build = pkgs.vimUtils.buildVimPlugin;
  fetch = pkgs.fetchFromGitHub;
in {
  lualine-so-fancy = build {
    name = "lualine-so-fancy";
    src = fetch {
      owner = "meuter";
      repo = "lualine-so-fancy.nvim";
      rev = "21284504fed2776668fdea8743a528774de5d2e1";
      hash = "sha256-JMz3Dv3poGoYQU+iq/jtgyHECZLx+6mLCvqUex/a0SY=";
    };
  };
  buffer-manager = build {
    name = "buffer-manager";
    src = fetch {
      owner = "j-morano";
      repo = "buffer_manager.nvim";
      rev = "fd36131b2b3e0f03fd6353ae2ffc88cf920b3bbb";
      hash = "sha256-abe9ZGmL7U9rC+LxC3LO5/bOn8lHke1FCKO0V3TZGs0=";
    };
  };
  nvim-paredit = build {
    name = "nvim-paredit";
    src = fetch {
      owner = "julienvincent";
      repo = "nvim-paredit";
      rev = "8dd4ffd6ee0d798026f9ad6cf04344560207b9f1";
      hash = "sha256-Zo40MOBSkLFSaK+x6iiNXhV9c/yNCi2jckl5VOpBDU8=";
    };
  };
  img-clip = build {
    name = "img-clip";
    src = fetch {
      owner = "HakonHarnes";
      repo = "img-clip.nvim";
      rev = "c55f988972be0027316889c57ffe49f2bf8f67fd";
      hash = "sha256-sl//iua0S4hdulopAjOOe7xh/iEuQeNRlNECxcc6rXk=";
    };
  };
}
