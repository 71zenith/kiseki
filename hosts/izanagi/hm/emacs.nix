{
  pkgs,
  nur-no-pkgs,
  ...
}: {
  imports = [
    nur-no-pkgs.repos.rycee.hmModules.emacs-init
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;
    # package = pkgs.emacs29-pgtk;
    # extraPackages = epkgs:
    #   with epkgs; [
    #     magit
    #     vertico
    #     marginalia
    #     orderless
    #     corfu
    #     consult
    #     embark
    #     embark-consult
    #     diminish
    #     eat
    #     capf-autosuggest
    #     eshell-syntax-highlighting
    #     popwin
    #     meow
    #     yasnippet
    #     undo-fu
    #     undo-fu-session
    #     spacious-padding
    #     envrc
    #     nix-mode
    #     markdown-mode
    #     rust-mode
    #     clojure-mode
    #     cider
    #     smartparens
    #     prism
    #     git-gutter
    #     which-key
    #     helpful
    #   ];
  };
}
