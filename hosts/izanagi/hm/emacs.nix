{
  pkgs,
  nur-no-pkgs,
  config,
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
    startupTimer = true;
    usePackage = {
      magit.enable = true;
      fontaine = {
        enable = true;
        config = ''
          (setq fontaine-set-preset 'regular
           fontaine-presets
           '((regular)
             (t
              :default-family "${config.stylix.fonts.monospace.name}"
              :default-weight medium
              :default-height ${builtins.toString (config.stylix.fonts.sizes.terminal * 10)}
              :mode-line-active-family "${config.stylix.fonts.serif.name}"
              :mode-line-inactive-family "${config.stylix.fonts.serif.name}")))
          (fontaine-mode t)
          (fontaine-set-preset 'regular)
        '';
      };
      vertico.enable = true;
      marginalia.enable = true;
      orderless.enable = true;
      corfu.enable = true;
      consult.enable = true;
      embark.enable = true;
      embark-consult.enable = true;
      diminish.enable = true;
      eat.enable = true;
      capf-autosuggest.enable = true;
      eshell-syntax-highlighting.enable = true;
      popwin.enable = true;
      meow.enable = true;
      yasnippet.enable = true;
      undo-fu.enable = true;
      undo-fu-session.enable = true;
      spacious-padding.enable = true;
      envrc.enable = true;
      cider.enable = true;
      smartparens.enable = true;
      prism.enable = true;
      git-gutter.enable = true;
      which-key.enable = true;
      helpful.enable = true;

      #### Language support ####
      nix-mode.enable = true;
      zig-mode.enable = true;
      markdown-mode.enable = true;
      rust-mode.enable = true;
      clojure-mode.enable = true;
    };
  };
}
