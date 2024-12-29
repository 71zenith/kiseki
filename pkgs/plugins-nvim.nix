{pkgs, ...}: let
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.vimUtils) buildVimPlugin;
in {
  lualine-so-fancy = buildVimPlugin {
    pname = "lualine-so-fancy";
    version = "latest";
    src = fetchFromGitHub {
      owner = "meuter";
      repo = "lualine-so-fancy.nvim";
      rev = "45197358e5274d301d98638bf079f3437d6eacf8";
      hash = "sha256-j6XI4cw1ouYEvSiKdam8RAqxefDqeLwe37Qir/UO+8g=";
    };
  };
  buffer-manager = buildVimPlugin {
    pname = "buffer-manager";
    version = "latest";
    src = fetchFromGitHub {
      owner = "j-morano";
      repo = "buffer_manager.nvim";
      rev = "fd36131b2b3e0f03fd6353ae2ffc88cf920b3bbb";
      hash = "sha256-abe9ZGmL7U9rC+LxC3LO5/bOn8lHke1FCKO0V3TZGs0=";
    };
  };
}
