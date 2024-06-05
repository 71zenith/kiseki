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
    postlude = ''

    '';
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
      vertico = {
        enable = true;
        bindLocal = {
          vertico-map = {
            "C-h" = "left-char";
            "C-l" = "right-char";
            "C-j" = "vertico-next";
            "C-k" = "vertico-previous";
          };
        };
        config = ''
          (setq vertico-resize nil
                vertico-cycle t)
        '';
        init = ''
          (vertico-mode t)
        '';
      };
      marginalia = {
        enable = true;
        config = ''
          (setq marginalia-annotators
                  '(marginalia-annotators-heavy marginalia-annotators-light nil))
        '';
        init = ''
          (marginalia-mode t)
        '';
      };
      orderless = {
        enable = true;
        config = ''
          (setq completion-ignore-case t
                read-buffer-completion-ignore-case t
                echo-keystrokes 0.25
                kill-ring-max 60
                read-file-name-completion-ignore-case t
                completion-styles '(orderless basic)
                completion-category-defaults nil
                completion-category-overrides '((file (styles partial-completion))))
        '';
      };
      corfu = {
        enable = true;
        bindLocal = {
          corfu-map = {
            "TAB" = "corfu-next";
            "S-TAB" = "corfu-previous";
          };
        };
        hook = ["(prog-mode . corfu-mode)"];
        config = ''
          (setq corfu-cycle t
                corfu-auto t
                corfu-preview-current 'insert
                corfu-separator ?\s
                corfu-quit-at-boundary nil
                corfu-quit-no-match nil
                corfu-preselect 'prompt
                corfu-on-exact-match nil
                corfu-scroll-margin 5
                corfu-popupinfo-delay nil)
        '';
        init = ''
          (global-corfu-mode t)
          (corfu-history-mode t)
          (corfu-popupinfo-mode t)
        '';
      };
      consult = {
        enable = true;
        defer = true;
        after = ["vertico"];
        config = ''
          (setq xref-show-xrefs-function #'consult-xref
                xref-show-definitions-function #'consult-xref)
          (global-set-key [remap switch-to-buffer] 'consult-buffer)
          (global-set-key [remap yank-pop] 'consult-yank-pop)
          (global-set-key [remap Info-search] 'consult-info)
          (global-set-key [remap bookmark-jump] 'consult-bookmark)
          (global-set-key [remap switch-to-buffer-other-tab] 'consult-buffer-other-tab)
          (global-set-key [remap recentf] 'consult-recent-file)
          (global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
          (global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
          (global-set-key [remap project-switch-to-buffer] 'consult-project-buffer)
          (global-set-key [remap isearch-forward] 'consult-line)
          (global-set-key [remap isearch-backward] 'consult-line)
        '';
      };
      # embark = {
      #   enable = false;
      #   defer = true;
      #   config = ''
      #       (defun embark-which-key-indicator ()
      #         "An embark indicator that displays keymaps using which-key.
      #     The which-key help message will show the type and value of the
      #     current target followed by an ellipsis if there are further
      #     targets."
      #         (lambda (&optional keymap targets prefix)
      #           (if (null keymap)
      #               (which-key--hide-popup-ignore-command)
      #             (which-key--show-keymap
      #             (if (eq (plist-get (car targets) :type) 'embark-become)
      #                 "Become"
      #               (format "Act on %s '%s'%s"
      #                       (plist-get (car targets) :type)
      #                       (embark--truncate-target (plist-get (car targets) :target))
      #                       (if (cdr targets) "…" "")))
      #             (if prefix
      #                 (pcase (lookup-key keymap prefix 'accept-default)
      #                   ((and (pred keymapp) km) km)
      #                   (_ (key-binding prefix 'accept-default)))
      #               keymap)
      #             nil nil t (lambda (binding)
      #                         (not (string-suffix-p "-argument" (cdr binding))))))))
      #
      #       (setq embark-indicators
      #             '(embark-which-key-indicator
      #               embark-highlight-indicator
      #               embark-isearch-highlight-indicator))
      #
      #       (defun embark-hide-which-key-indicator (fn &rest args)
      #         "Hide the which-key indicator immediately when using the completing-read prompter."
      #         (which-key--hide-popup-ignore-command)
      #         (let ((embark-indicators
      #               (remq #'embark-which-key-indicator embark-indicators)))
      #           (apply fn args)))
      #
      #       (advice-add #'embark-completing-read-prompter
      #                   :around #'embark-hide-which-key-indicator)
      #   '';
      # };
      # embark-consult = {
      #   enable = false;
      #   # defer = true;
      #   after = ["embark" "consult"];
      #   hook = ["(embark-collect-mode . consult-preview-at-point-mode)"];
      # };
      eat.enable = true;
      popwin = {
        enable = true;
        config = ''
          (popwin-mode 1)
          (push '("*helpful*" :height 7) popwin:special-display-config)
          (push '("*Help*" :height 7) popwin:special-display-config)
          (push '("*Occur*" :height 7) popwin:special-display-config)
          (push '("*tree-sit*" :height 7 :noselect t) popwin:special-display-config)
          (push '("*eldoc*" :height 7) popwin:special-display-config)
          (push '("*compilation*" :height 7) popwin:special-display-config)
        '';
      };
      evil = {
        enable = true;
        init = ''
          (evil-mode t)
        '';
      };
      yasnippet = {
        enable = true;
        hook = ["((prog-mode org-mode) . yas-minor-mode)"];
      };
      undo-fu.enable = true;
      undo-fu-session = {
        enable = true;
        init = ''
          (undo-fu-session-global-mode t)
        '';
      };
      spacious-padding = {
        enable = true;
        config = ''
          (setq spacious-padding-widths
                  '(:internal-border-width 10
                    :header-line-width 2
                    :mode-line-width 1
                    :tab-width 4
                    :right-divider-width 30
                    :scroll-bar-width 2))
        '';
        init = ''
          (spacious-padding-mode t)
        '';
      };
      envrc = {
        enable = true;
        hook = ["(prog-mode . envrc-global-mode)"];
      };
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
