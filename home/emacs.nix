{
  pkgs,
  nurNoPkgs,
  config,
  ...
}: let
  setq = configSet:
    builtins.concatStringsSep "\n" (
      map (key: "(setq ${key} ${builtins.getAttr key configSet})") (builtins.attrNames configSet)
    );
  t = modeNames: ''
    ${builtins.concatStringsSep " " (map (name: "(${name} t)") modeNames)}
  '';
  hook = mode: func: "(add-hook '" + mode + " '" + func + ")";
in {
  imports = [nurNoPkgs.repos.rycee.hmModules.emacs-init];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;
    startupTimer = true;
    earlyInit = setq {
      inhibit-startup-screen = "t";
      inhibit-startup-echo-area-message = "(user-login-name)";
      load-prefer-newer = "t";
      inhibit-compacting-font-caches = "t";
      highlight-nonselected-windows = "nil";
      vc-handled-backends = "nil";
      initial-major-mode = "'fundamental-mode";
      initial-scratch-message = "nil";
      use-dialog-box = "nil";
      confirm-kill-emacs = "nil";
      confirm-kill-processes = "nil";
      use-short-answers = "t";
      enable-recursive-minibuffers = "t";
      completion-cycle-threshold = "3";
      ring-bell-function = "#'ignore";
      file-name-handler-alist = "nil";
      frame-inhibit-implied-resize = "t";
      fast-but-imprecise-scrolling = "t";
      idle-update-delay = "1.0";
      warning-minimum-level = ":error";
      default-frame-alist = "'(
          (tool-bar-lines . 0)
          (menu-bar-lines . 0)
          (undecorated . t)
          (vertical-scroll-bars . nil)
          (horizontal-scroll-bars . nil)
      )";
    };
    postlude =
      setq {
        make-backup-files = "nil";
        create-lockfiles = "nil";
        vc-make-backup-files = "nil";
        auto-save-default = "nil";
        tab-always-indent = "'complete";

        indent-tabs-mode = "nil";
        tab-width = "4";
        show-trailing-whitespace = "t";

        scroll-step = "1";
        scroll-margin = "3";
        scroll-conservatively = "100";

        vc-follow-symlinks = "t";
        find-file-visit-truename = "t";

        save-place-file = ''(locate-user-emacs-file "places")'';

        display-time-format = ''"%a %d %b %H:%M"'';
        display-time-default-load-average = "nil";

        # default-input-method = "japanese";

        recentf-max-saved-items = "200";

        uniquify-buffer-name-style = "'forward";
        uniquify-separator = "/";
        uniquify-after-kill-buffer-p = "t";
        uniquify-ignore-buffers-re = "^\\*";
      }
      + t [
        "save-place-mode"
        "size-indication-mode"
        "column-number-mode"
        "auto-revert-mode"
        "savehist-mode"
        "display-time-mode"
        "recentf-mode"
        "display-line-numbers-mode"
      ]
      + ''
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
        (load-theme 'base16-oxocarbon-dark t)
      '';
    usePackage = {
      magit.enable = true;
      format-all = {
        enable = true;
        config = hook "prog-mode-hook" "format-all-mode";
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
                      :mode-line-active-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}

                      :mode-line-inactive-family "${config.stylix.fonts.serif.name}"
                      :mode-line-inactive-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}

                      :line-number-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.terminal * 1.2 * 10))})))
          (fontaine-mode t)
          (fontaine-set-preset 'regular)
        '';
      };
      vertico = {
        enable = true;
        bindLocal.vertico-map = {
          "C-h" = "left-char";
          "C-l" = "right-char";
          "C-j" = "vertico-next";
          "C-k" = "vertico-previous";
        };

        config = setq {
          vertico-resize = "nil";
          vertico-cycle = "t";
        };
        init = t ["vertico-mode"];
      };
      marginalia = {
        enable = true;
        config =
          setq {marginalia-annotators = "'(marginalia-annotators-heavy marginalia-annotators-light nil)";}
          + t ["marginalia-mode"];
      };
      orderless = {
        enable = true;
        config = setq {
          completion-ignore-case = "t";
          read-buffer-completion-ignore-case = "t";
          echo-keystrokes = "0.25";
          kill-ring-max = "60";
          read-file-name-completion-ignore-case = "t";
          completion-styles = "'(orderless basic)";
          completion-category-defaults = "nil";
          completion-category-overrides = "'((file (styles partial-completion)))";
        };
      };
      corfu = {
        enable = true;
        bindLocal.corfu-map = {
          "[tab]" = "corfu-next";
          "[backtab]" = "corfu-previous";
        };
        config = setq {
          corfu-cycle = "t";
          corfu-auto = "t";
          corfu-preview-current = "'insert";
          corfu-separator = "?\s";
          corfu-quit-at-boundary = "nil";
          corfu-quit-no-match = "nil";
          corfu-preselect = "'prompt";
          corfu-on-exact-match = "nil";
          corfu-scroll-margin = "5";
          corfu-popupinfo-delay = "nil";
        };
        init = t [
          "global-corfu-mode"
          "corfu-history-mode"
          "corfu-popupinfo-mode"
        ];
      };
      cape = {
        enable = true;
        config =
          hook "completion-at-point-functions" "#'cape-file"
          + hook "completion-at-point-functions" "#'cape-dabbrev"
          + hook "completion-at-point-functions" "#'cape-emoji"
          + hook "completion-at-point-functions" "#'cape-line"
          + hook "completion-at-point-functions" "#'cape-keyword";
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
        config = hook "embark-collect-mode-hook" "consult-preview-at-point-mode";
      };
      eat = {
        enable = true;
        config = hook "eat-mode-hook" "eat-char-mode";
      };
      popwin = {
        enable = true;
        config = ''
          (push '("*helpful*" :height 7) popwin:special-display-config)
          (push '("*Help*" :height 7) popwin:special-display-config)
          (push '("*Occur*" :height 7) popwin:special-display-config)
          (push '("*tree-sit*" :height 7 :noselect t) popwin:special-display-config)
          (push '("*eldoc*" :height 7) popwin:special-display-config)
          (push '("*compilation*" :height 7) popwin:special-display-config)
        '';
        init = t ["popwin-mode"];
      };
      evil = {
        enable = true;
        config = ''
          (evil-global-set-key 'normal (kbd "SPC SPC") 'execute-extended-command)
          (evil-global-set-key 'visual (kbd "SPC SPC") 'execute-extended-command)
        '';
        init =
          t ["evil-mode"]
          + setq {
            evil-undo-system = "'undo-fu";
            evil-want-keybinding = "nil";
            evil-want-integration = "t";
          };
      };
      # evil-collection = {
      #   enable = true;
      #   after = ["evil"];
      #   config = "(evil-collection-init)";
      # };
      evil-commentary = {
        enable = true;
        after = ["evil"];
        init = t ["evil-commentary-mode"];
      };
      evil-snipe = {
        after = ["evil"];
        init = t ["evil-snipe-override-mode"];
      };
      evil-surround = {
        enable = true;
        after = ["evil"];
        init = t ["global-evil-surround-mode"];
      };
      yasnippet-snippets.enable = true;
      yasnippet = {
        enable = true;
        config = hook "prog-mode-hook" "yas-minor-mode";
      };
      undo-fu.enable = true;
      undo-fu-session = {
        enable = true;
        init = t ["undo-fu-session-global-mode"];
      };
      spacious-padding = {
        enable = true;
        config =
          setq {
            spacious-padding-widths = ''
              '(:internal-border-width 10
                :header-line-width 2
                :mode-line-width 1
                :tab-width 4
                :right-divider-width 30
                :scroll-bar-width 2)
            '';
          }
          + t ["spacious-padding-mode"];
      };
      envrc = {
        enable = true;
        init = t ["envrc-global-mode"];
      };
      treesit-auto = {
        enable = true;
        config =
          setq {treesit-auto-install = "t";}
          + t ["global-treesit-auto-mode"]
          + "(treesit-auto-add-to-auto-mode-alist 'all)";
      };
      eglot = {
        enable = true;
        config = hook "prog-mode-hook" "eglot-ensure";
      };
      electric = {
        enable = true;
        config = hook "prog-mode-hook" "(electric-indent-mode electric-pair-mode)";
      };
      rainbow-delimiters = {
        enable = true;
        config = hook "prog-mode-hook" "rainbow-delimiters-mode";
      };
      git-gutter = {
        enable = true;
        config =
          t ["global-git-gutter-mode"]
          + ''
            (custom-set-variables
              '(git-gutter:modified-sign "● ")
              '(git-gutter:added-sign "▶ ")
              '(git-gutter:deleted-sign "▼ "))'';
      };
      blamer = {
        enable = true;
        config = t ["global-blamer-mode"];
      };
      which-key = {
        enable = true;
        diminish = ["which-key-mode"];
        config =
          setq {
            which-key-idle-delay = "0.4";
            which-key-idle-secondary-delay = "0.05";
          }
          + t ["which-key-mode"]
          + "(which-key-setup-minibuffer)";
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
