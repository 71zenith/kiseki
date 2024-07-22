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
      + hook "prog-mode-hook" "(eglot-ensure electric-indent-mode)";
    usePackage = {
      fontaine = {
        enable = true;
        config = setq {
          fontaine-set-preset = "'regular";
          fontaine-presets = ''
            '((regular)
              (t
                :default-family "${config.stylix.fonts.monospace.name}"
                :default-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.terminal * 1.1 * 10))}

                :variable-pitch-family "${config.stylix.fonts.serif.name}"

                :mode-line-active-family "${config.stylix.fonts.serif.name}"
                :mode-line-active-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}

                :mode-line-inactive-family "${config.stylix.fonts.serif.name}"
                :mode-line-inactive-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.applications * 1.3 * 10))}

                :line-number-height ${builtins.toString (builtins.floor (config.stylix.fonts.sizes.terminal * 1.2 * 10))})))
          '';
        };
        init = t ["fontaine-mode"];
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
      yasnippet-snippets.enable = true;
      yasnippet = {
        enable = true;
        config = hook "prog-mode-hook" "yas-minor-mode";
      };
      magit.enable = true;
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
      eglot = {
        enable = true;
        config = hook "prog-mode-hook" "eglot-ensure";
      };
      electric = {
        enable = true;
        config = hook "prog-mode-hook" "electric-indent-mode";
      };
      git-gutter = {
        enable = true;
        init = t ["global-git-gutter-mode"];
      };
      blamer = {
        enable = true;
        init = t ["global-blamer-mode"];
      };
      which-key = {
        enable = true;
        diminish = ["which-key-mode"];
        config = setq {
          which-key-idle-delay = "0.4";
          which-key-idle-secondary-delay = "0.05";
        };
        init = t ["which-key-mode"];
      };

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
