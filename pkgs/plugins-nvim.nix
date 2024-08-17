{pkgs, ...}: let
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.vimUtils) buildVimPlugin;
in {
  lualine-so-fancy = buildVimPlugin {
    name = "lualine-so-fancy";
    src = fetchFromGitHub {
      owner = "meuter";
      repo = "lualine-so-fancy.nvim";
      rev = "45197358e5274d301d98638bf079f3437d6eacf8";
      hash = "sha256-j6XI4cw1ouYEvSiKdam8RAqxefDqeLwe37Qir/UO+8g=";
    };
  };
  buffer-manager = buildVimPlugin {
    name = "buffer-manager";
    src = fetchFromGitHub {
      owner = "j-morano";
      repo = "buffer_manager.nvim";
      rev = "fd36131b2b3e0f03fd6353ae2ffc88cf920b3bbb";
      hash = "sha256-abe9ZGmL7U9rC+LxC3LO5/bOn8lHke1FCKO0V3TZGs0=";
    };
  };
  org-bullets = buildVimPlugin {
    name = "org-bullets";
    src = fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "3623e86e0fa6d07f45042f7207fc333c014bf167";
      hash = "sha256-aIEe1dgUmDzu9kl33JCNcgyfp8DymURltH0HcZfph0Y=";
    };
  };
  img-clip = buildVimPlugin {
    name = "img-clip";
    src = fetchFromGitHub {
      owner = "HakonHarnes";
      repo = "img-clip.nvim";
      rev = "c55f988972be0027316889c57ffe49f2bf8f67fd";
      hash = "sha256-sl//iua0S4hdulopAjOOe7xh/iEuQeNRlNECxcc6rXk=";
    };
  };
  incline-nvim = buildVimPlugin {
    name = "incline-nvim";
    src = fetchFromGitHub {
      owner = "b0o";
      repo = "incline.nvim";
      rev = "16fc9c073e3ea4175b66ad94375df6d73fc114c0";
      hash = "sha256-5DoIvIdAZV7ZgmQO2XmbM3G+nNn4tAumsShoN3rDGrs=";
    };
  };
}
