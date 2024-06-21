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
    earlyInit = ''
      (setq inhibit-startup-screen t
            inhibit-startup-echo-area-message (user-login-name))

      (setq initial-major-mode 'fundamental-mode
            initial-scratch-message nil)
      (set-frame-parameter nil 'alpha-background 85)
      (add-to-list 'default-frame-alist '(alpha-background . 85))

      (setq use-dialog-box nil
            confirm-kill-emacs nil
            confirm-kill-processes nil
            use-short-answers t
            enable-recursive-minibuffers t
            completion-cycle-threshold 3
            ring-bell-function #'ignore
            file-name-handler-alist nil
            frame-inhibit-implied-resize t
            fast-but-imprecise-scrolling t
            idle-update-delay 1.0
            warning-minimum-level :error)

      (setq-default default-frame-alist
                    '((undecorated . t)
                      (vertical-scroll-bars . nil)
                      (horizontal-scroll-bars . nil)))
    '';
    postlude = ''
      (defadvice split-window (after split-window-after activate)
                              (other-window 1))
      (defun crm-indicator (args)
        (cons (format "[CRM%s] %s"
                    (replace-regexp-in-string
                    "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                    crm-separator)
                    (car args))
            (cdr args)))
      (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

      (setq make-backup-files nil
            create-lockfiles nil
            vc-make-backup-files nil
            auto-save-default nil)

      (setq tab-always-indent 'complete)

      (setq-default indent-tabs-mode nil
                    tab-width 4)
      (setq show-trailing-whitespace t)

      (prefer-coding-system 'utf-8)

      (setq scroll-step 1
            scroll-margin 3
            scroll-conservatively 100)

      (setq vc-follow-symlinks t
            find-filie-visit-truename t)

      (setq save-place-file (locate-user-emacs-file "places"))
      (save-place-mode t)

      (setq display-time-format "%a %d %b %H:%M"
            display-time-default-load-average nil)
      (display-time-mode t)

      (setq default-input-method "japanese")

      (setq recentf-max-saved-items 200)
      (recentf-mode t)

      (setq uniquify-buffer-name-style 'forward)

      (size-indication-mode t)
      (column-number-mode t)
      (auto-revert-mode t)
      (savehist-mode t)
    '';
    usePackage = {
      emacs = {
        hook = ["(prog-mode . display-line-numbers-mode)"];
      };
      magit.enable = true;
      format-all = {
        enable = true;
        hook = [
          "(prog-mode . format-all-mode)"
        ];
      };
      fontaine = {
        enable = true;
        config = ''
          (setq fontaine-set-preset 'regular
                fontaine-presets
                  '((regular)
                    (t
                      :default-family "${config.stylix.fonts.monospace.name}"
                      :default-weight medium
                      :default-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.terminal * 1.1 * 10))}
                      :variable-pitch-family "${config.stylix.fonts.serif.name}"
                      :mode-line-active-family "${config.stylix.fonts.serif.name}"
                      :mode-line-inactive-family "${config.stylix.fonts.serif.name}"
                      :mode-line-active-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}
                      :mode-line-inactive-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}
                      :line-number-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.terminal * 1.2 * 10))})))
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
            "[tab]" = "corfu-next";
            "[backtab]" = "corfu-previous";
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
      cape = {
        enable = true;
        config = ''
          (add-hook 'completion-at-point-functions #'cape-file)
          (add-hook 'completion-at-point-functions #'cape-dabbrev)
          (add-hook 'completion-at-point-functions #'cape-emoji)
          (add-hook 'completion-at-point-functions #'cape-keyword)
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
      embark = {
        enable = true;
        defer = true;
        config = ''
          (defun embark-which-key-indicator ()
           "An embark indicator that displays keymaps using which-key.
           The which-key help message will show the type and value of the
           current target followed by an ellipsis if there are further
           targets."
           (lambda (&optional keymap targets prefix)
            (if (null keymap)
             (which-key--hide-popup-ignore-command)
             (which-key--show-keymap
              (if (eq (plist-get (car targets) :type) 'embark-become)
               "Become"
               (format "Act on %s '%s'%s"
                (plist-get (car targets) :type)
                (embark--truncate-target (plist-get (car targets) :target))
                (if (cdr targets) "…" "")))
              (if prefix
               (pcase (lookup-key keymap prefix 'accept-default)
                ((and (pred keymapp) km) km)
                (_ (key-binding prefix 'accept-default)))
               keymap)
              nil nil t (lambda (binding)
                (not (string-suffix-p "-argument" (cdr binding))))))))

          (setq embark-indicators
           '(embark-which-key-indicator
             embark-highlight-indicator
             embark-isearch-highlight-indicator))

            (defun embark-hide-which-key-indicator (fn &rest args)
             "Hide the which-key indicator immediately when using the completing-read prompter."
             (which-key--hide-popup-ignore-command)
             (let ((embark-indicators
                    (remq #'embark-which-key-indicator embark-indicators)))
              (apply fn args)))

            (advice-add #'embark-completing-read-prompter
             :around #'embark-hide-which-key-indicator)
        '';
      };
      embark-consult = {
        enable = true;
        defer = true;
        after = ["embark" "consult"];
        hook = ["(embark-collect-mode . consult-preview-at-point-mode)"];
      };
      eat = {
        enable = true;
        hook = ["(eat-mode . eat-char-mode)"];
      };
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
        config = ''
          (setq evil-undo-system 'undo-fu
                evil-want-keybinding nil)
          (evil-global-set-key 'normal (kbd "SPC SPC") 'execute-extended-command)
          (evil-global-set-key 'visual (kbd "SPC SPC") 'execute-extended-command)
        '';
        init = ''
          (evil-mode t)
        '';
      };
      evil-collection = {
        enable = true;
        config = ''
          (evil-collection-init)
        '';
      };
      evil-commentary = {
        enable = true;
        after = ["evil"];
        config = ''
          (evil-commentary-mode t)
        '';
      };
      evil-snipe = {
        config = ''
          (evil-snipe-override-mode t)
        '';
      };
      evil-surround = {
        enable = true;
        after = ["evil"];
        config = ''
          (global-evil-surround-mode t)
        '';
      };
      yasnippet-snippets.enable = true;
      yasnippet = {
        enable = true;
        hook = ["(prog-mode . yas-minor-mode)"];
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
        init = "(envrc-global-mode t)";
      };
      treesit-auto = {
        enable = true;
        config = ''
          (setq treesit-auto-install t)
          (treesit-auto-add-to-auto-mode-alist 'all)
          (global-treesit-auto-mode)
        '';
      };
      eglot = {
        enable = true;
        hook = ["(prog-mode . eglot-ensure)"];
      };
      electric = {
        enable = true;
        hook = ["(prog-mode . (electric-indent-mode electric-pair-mode))"];
      };
      smartparens.enable = false;
      rainbow-delimiters = {
        enable = true;
        hook = ["(prog-mode . rainbow-delimiters-mode)"];
      };
      git-gutter = {
        enable = true;
        config = ''
          (global-git-gutter-mode t)
          (custom-set-variables
           '(git-gutter:modified-sign "● ")
           '(git-gutter:added-sign "▶ ")
           '(git-gutter:deleted-sign "▼ "))
        '';
      };
      blamer = {
        enable = true;
        config = "(global-blamer-mode t)";
      };
      which-key = {
        enable = true;
        diminish = ["which-key-mode"];
        config = ''
          (setq which-key-idle-delay 0.4
                which-key-idle-secondary-delay 0.05)
          (which-key-setup-minibuffer)
          (which-key-mode)
        '';
      };
      helpful.enable = true;

      #### Language support ####
      nix-mode.enable = true;
      zig-mode.enable = true;
      markdown-mode.enable = true;
      rust-mode.enable = true;
      clojure-mode.enable = true;
      cider.enable = true;
    };
  };
}
