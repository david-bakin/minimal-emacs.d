;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;;; TODO

;; 1) Reconsider native compilation - binary apparently has it (see `system-configuration-features`) - needs libgccjit somewhere
;;    there are pages on the net that tell how to get it with an msys2 (on PATH) and its pacman package manager
;; 2) If c compiler and build tools are available consider package vterm
;; 3) emacs server is running but a) emacsclient can't connect to it and b) how do you _keep_ it running?
;; 4) consider dired-omit-files esp. if there's a way to toggle the hidden files on/off
;; 5) there are various autosave mechanisms - do they conflict?
;; 6) consider elpaca package manager and/or straight.el
;; 7) figure out visual line mode and use it or not - see also visual-line-fringe-indicators (https://vlevit.org/en/blog/tech/visual-line-wrap)
;;    and whitespace-mode and auto-fill-mode
;; 8) why don't the key bindings for eval-expression work? - this was win32 mode key registration stuff


;;; package path manipulation - setup for my packages (so that they can be byte-compiled)

(let ((full-path (expand-file-name "my-packages" minimal-emacs-user-directory)))
  (if (file-directory-p full-path)
    (unless (member full-path load-path)
      (push full-path load-path))
    (message "Directory does not exist, skipping load: %s" full-path)))

(require 'bakin-init-my-packages)


;;; (color) themes

(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-operandi-deuteranopia t))

;;; Give Emacs tab-bar the same theme as Emacs itself

(use-package vim-tab-bar
  :commands vim-tab-bar-mode
  :hook (after-init . vim-tab-bar-mode))

;; (bakin) turn on tab-bar mode
(tab-bar-mode)
(setopt tab-bar-show 1)  ;; only show tab bar when multiple tabs are open




;;; package diff-hl to highlight git uncommitted changes in the window margin

(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))




;;; package buffer-terminator _automatically and safely kills buffers_

(use-package buffer-terminator
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose nil)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 10 60)) ; 10 minutes

  :config
  (buffer-terminator-mode 1))


;;; package treemacs - a file and project explorer with a visually structured tree layout

;; A file and project explorer for Emacs that displays a structured tree
;; layout, similar to file browsers in modern IDEs. It functions as a sidebar
;; in the left window, providing a persistent view of files, projects, and
;; other elements.
(use-package treemacs
  :commands (treemacs
             treemacs-select-window
             treemacs-delete-other-windows
             treemacs-select-directory
             treemacs-bookmark
             treemacs-find-file
             treemacs-find-tag)

  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))

  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

  :config
  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay        0.5
        treemacs-directory-name-transformer      #'identity
        treemacs-display-in-side-window          t
        treemacs-eldoc-display                   'simple
        treemacs-file-event-delay                2000
        treemacs-file-extension-regex            treemacs-last-period-regex-value
        treemacs-file-follow-delay               0.2
        treemacs-file-name-transformer           #'identity
        treemacs-follow-after-init               t
        treemacs-expand-after-init               t
        treemacs-find-workspace-method           'find-for-file-or-pick-first
        treemacs-git-command-pipe                ""
        treemacs-goto-tag-strategy               'refetch-index
        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory          nil
        treemacs-indentation                     2
        treemacs-indentation-string              " "
        treemacs-is-never-other-window           nil
        treemacs-max-git-entries                 5000
        treemacs-missing-project-action          'ask
        treemacs-move-files-by-mouse-dragging    t
        treemacs-move-forward-on-expand          nil
        treemacs-no-png-images                   nil
        treemacs-no-delete-other-windows         t
        treemacs-project-follow-cleanup          nil
        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position                        'left
        treemacs-read-string-input               'from-child-frame
        treemacs-recenter-distance               0.1
        treemacs-recenter-after-file-follow      nil
        treemacs-recenter-after-tag-follow       nil
        treemacs-recenter-after-project-jump     'always
        treemacs-recenter-after-project-expand   'on-distance
        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        treemacs-project-follow-into-home        nil
        treemacs-show-cursor                     nil
        treemacs-show-hidden-files               t
        treemacs-silent-filewatch                nil
        treemacs-silent-refresh                  nil
        treemacs-sorting                         'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes        t
        treemacs-tag-follow-cleanup              t
        treemacs-tag-follow-delay                1.5
        treemacs-text-scale                      nil
        treemacs-user-mode-line-format           nil
        treemacs-user-header-line-format         nil
        treemacs-wide-toggle-width               70
        treemacs-width                           35
        treemacs-width-increment                 1
        treemacs-width-is-initially-locked       t
        treemacs-workspace-switch-cleanup        nil)

  ;; The default width and height of the icons is 22 pixels. If you are
  ;; using a Hi-DPI display, uncomment this to double the icon size.
  (treemacs-resize-icons 44)

  (treemacs-follow-mode t)
  (treemacs-filewatch -mode t)
  (treemacs-fringe-indicator-mode 'always)

  ;;(when treemacs-python-executable
  ;;  (treemacs-git-commit-diff-mode t))

  (pcase (cons (not (null (executable-find "git")))
               (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))

  (treemacs-hide-gitignored-files-mode nil))

;; (use-package treemacs-icons-dired
;;   :hook (dired-mode . treemacs-icons-dired-enable-once)
;;
(use-package treemacs-tab-bar  ; treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :config (treemacs-set-scope-type 'Tabs))
;; (treemacs-start-on-boot)

;;; package helpful - a better Emacs help buffer

;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :custom
  (helpful-max-buffers 7))

;;; package bufferfile.el has helperfunction to delete, rename, or copy buffer files

(use-package bufferfile
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :custom
  ;; If non-nil, display messages during file renaming operations
  (bufferfile-verbose nil)

  ;; If non-nil, enable using version control (VC) when available
  (bufferfile-use-vc nil)

  ;; Specifies the action taken after deleting a file and killing its buffer.
  (bufferfile-delete-switch-to 'parent-directory))

;;; Better elisp development "experience" - with packages aggressive-indent, highlight-defined, paredit, page-break-lines, elisp-refs

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; Prevent parenthesis imbalance
(use-package paredit
  :commands paredit-mode
  :hook
  (emacs-lisp-mode . paredit-mode)
  :config
  (define-key paredit-mode-map (kbd "RET") nil))

;; Displays visible indicators for page breaks
(use-package page-break-lines
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;;; Set default font (face)

;; Set the default font to DejaVu Sans Mono with specific size and weight
(set-face-attribute 'default nil
                    :height 130 :weight 'normal :family "PragmataPro Mono")


;;; package persist-text-scale to ensure text size in each buffer remains consistent even after restarting Emacs

(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))


;;; package buffer-guardian for autosave when switching buffers, frames, etc.

(use-package buffer-guardian
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :hook
  (after-init . buffer-guardian-mode))

;;; package server use emacs as a server for emacsclient

;; The Emacs server allows external programs such as `emacsclient' to connect to
;; a single running instance of Emacs. This makes it possible to open files in
;; the existing session rather than starting a new Emacs process each time.
;;
;; Once the server is running, the `emacsclient' command can be used in the
;; terminal to open files in the active Emacs session. For example, running the
;; following command opens the file in the existing Emacs frame without blocking
;; the terminal process.
;;   emacsclient -n filename.txt
;;
(use-package server
  :ensure nil
  :if (not (daemonp))
  :commands (server-running-p
             server-start)
  :hook (after-init . my-server-start)
  :preface
  (defun my-server-start ()
    "Start the Emacs server if no server process is currently active."
    (unless (server-running-p)
      (setq server-use-tcp t)
      (setq server-name "minimal")
      (server-start))))


;;; Git file support

;; 2026-06-07 can't load due to some kind of PGP signature error
;; ;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
;; (use-package git-modes
;;   :commands (gitattributes-mode
;;              gitconfig-mode
;;              gitignore-mode)
;;   :mode (("/\\.gitignore\\'" . gitignore-mode)
;;          ("/info/exclude\\'" . gitignore-mode)
;;          ("/git/ignore\\'" . gitignore-mode)
;;          ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles
;;
;;          ("/\\.gitconfig\\'" . gitconfig-mode)
;;          ("/\\.git/config\\'" . gitconfig-mode)
;;          ("/modules/.*/config\\'" . gitconfig-mode)
;;          ("/git/config\\'" . gitconfig-mode)
;;          ("/\\.gitmodules\\'" . gitconfig-mode)
;;          ("/etc/gitconfig\\'" . gitconfig-mode)
;;
;;          ("/\\.gitattributes\\'" . gitattributes-mode)
;;          ("/info/attributes\\'" . gitattributes-mode)
;;          ("/git/attributes\\'" . gitattributes-mode)))

;;; Support for YAML files.

;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;;; Support for Dockerfile files.

;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;;; Support for Jinja2 files

;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;;; Support for CSV files

;; Can't load due to some kind of signature error
;; ;; CSV file support with automatic column alignment. This configuration enables
;; ;; csv-align-mode whenever a CSV file is opened, improving readability by
;; ;; keeping columns visually aligned according to a configurable maximum width
;; ;; and a set of recognized field separators.
;; (use-package csv-mode
;;   :commands (csv-mode
;;              csv-align-mode
;;              csv-guess-set-separator)
;;   :mode ("\\.csv\\'" . csv-mode)
;;   :hook ((csv-mode . csv-align-mode)
;;          (csv-mode . csv-guess-set-separator))
;;   :custom
;;   (csv-align-max-width 100)
;;   (csv-separators '("," ";" " " "|" "\t")))


;;; Other customizations

;; Set fringes to match pixel width of a character
(fringe-mode (frame-char-width))

;; Typed text replaces selection (like in most editors)
(delete-selection-mode 1)

;; Display line/col numbers in mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))
(setq-default display-line-numbers-type t)
(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set max level of syntax highlighting for tree-sitter modes
(setq treesit-font-lock-level 4)

;; Turn on which-key-mode
(which-key-mode)
(which-key-setup-side-window-right) ;; can also be -bottom or -right-bottom

;; paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

;; ensure unique buffer names
(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name 'forward)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

;; add movable windows dividers
(add-hook 'after-init-hook #'window-divider-mode)

;; dired: constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; dired: omit some files (but toggle viewing them with `C-x M-o`
(setq dired-omit-files (concat "\`[.]\'"
                               "\|^\.DS_Store\'"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; dired: group directories first
(with-eval-after-load 'dired
  (setq dired-listing-switches "--group-directories-first -ahlv"))

;; enable visual indication of minibuffer recursion depth
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;; confirm before exiting
;;(setq confirm-kill-emacs 'y-or-n-p)
;;(setq confirm-kill-processes t)

;; fixups for tooltip mode (so there's a delay)
(setq tooltip-hide-delay 20)    ;; seconds, before it disappears
(setq tooltip-delay 0.4)        ;; delay after mouse move
(setq tooltip-short-delay 0.08) ;; delay before a short tooltip
(tooltip-mode 1)

;; automatically apply verified safe file-local variables
(setq enable-local-variables :safe)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
