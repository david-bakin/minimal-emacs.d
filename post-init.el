;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;;; TODO

;; 1) Reconsider native compilation - binary apparently has it (see `system-configuration-features`) - needs libgccjit somewhere
;;    there are pages on the net that tell how to get it with an msys2 (on PATH) and its pacman package manager
;; 2) If c compiler and build tools are available consider package vterm
;; 3) emacs server is running but a) emacsclient can't connect to it and b) how do you _keep_ it running?
;; 4) consider dired-omit-files esp. if there's a way to toggle the hidden files on/off
;; 5) there are various autosave mechanisms - do they conflict?
;; 6) consider elpaca package manager
;; 7) figure out visual line mode and use it or not
;; 8) why don't the key bindings for eval-expression work? - this was win32 mode key registration stuff


;;; package path manipulation - setup for my packages
;; (so that they can be byte-compiled)
(let ((full-path (expand-file-name "my-packages" minimal-emacs-user-directory)))
  (if (file-directory-p full-path)
    (unless (member full-path load-path)
      (push full-path load-path))
    (message "Directory does not exist, skipping load: %s" full-path)))

(require 'bakin-init-my-packages)


;;; package savehist to preserve minibuffer history between sessions

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 300))

;; package saveplace to remember last location within file when reopening it

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;;; auto-save-mode and auto-save-visited-mode to prevent data los

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 60 seconds of idle time.
(setq auto-save-timeout 60)

;; When auto-save-visited-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.
;;
;; This is different from auto-save-mode: auto-save-mode periodically saves
;; all modified buffers, creating backup files, including those not associated
;; with a file, while auto-save-visited-mode only saves file-visiting buffers
;; after a period of idle time, directly saving to the file itself without
;; creating backup files.
(setq auto-save-visited-interval 10)   ; Save after 10 seconds of inactivity
(auto-save-visited-mode 1)

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

;;; package easysession - session manager that persists lots of things including windows/frames

;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  (easysession-mode-line-misc-info t)  ; Display the session in the modeline
  (easysession-save-interval (* 3 60))  ; Save every 3 minutes

  :init
  ;; Key mappings
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (if (fboundp 'easysession-setup)
      ;; The `easysession-setup' function adds hooks:
      ;; - To enable automatic session loading during `emacs-startup-hook', or
      ;;   `server-after-make-frame-hook' when running in daemon mode.
      ;; - To automatically save the session at regular intervals, and when
      ;;   Emacs exits.
      (easysession-setup)
    ;; Legacy
    ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
    ;; session is loaded after all other packages. (Using 103/102 is
    ;; particularly useful for those using minimal-emacs.d, where some
    ;; optimizations restore `file-name-handler-alist` at depth 101 during
    ;; `emacs-startup-hook`.)
    (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
    (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))

;; from https://github.com/jamescherti/easysession.el#extension-easysession-magit-persist-and-restore-magit-buffers:
(with-eval-after-load 'easysession
  (require 'easysession-magit)
  (easysession-magit-mode 1))

;;; package markdown-mode and markdown-toc - for editing markdown **N.B.: need to test integration of pandoc and mdlook**

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :init
  (setq markdown-command '("C:\\Scoop\\Local\\apps\\pandoc\\current\\pandoc" "--from=markdown" "--to=html5"))    ;; (bakin)
  (setq markdown-open-command '("C:\\Users\\david\\AppData\\Local\\Programs\\MDLook\\MDLook.exe"))               ;; (bakin)
  (setq markdown-enable-math t)                                                                                  ;; (bakin)

  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . gfm-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))

;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))


;;; package kirigami for unified fold/unfold, with package outline for outline-minor-mode and hs-minor-mode, package outline-indent, and package treesit-fold

(use-package kirigami
  :commands (kirigami-open-fold
             kirigami-open-fold-rec
             kirigami-close-fold
             kirigami-toggle-fold
             kirigami-open-folds
             kirigami-close-folds-except-current
             kirigami-close-folds)

  :bind
  (("C-c z o" . kirigami-open-fold)          ; Open fold at point
   ("C-c z O" . kirigami-open-fold-rec)      ; Open fold recursively
   ("C-c z r" . kirigami-open-folds)         ; Open all folds
   ("C-c z c" . kirigami-close-fold)         ; Close fold at point
   ("C-c z m" . kirigami-close-folds)        ; Close all folds
   ("C-c z a" . kirigami-toggle-fold)))      ; Toggle fold at point

;; The built-in outline-minor-mode provides structured code folding in modes
;; such as Emacs Lisp and Python, allowing users to collapse and expand sections
;; based on headings or indentation levels. This feature enhances navigation and
;; improves the management of large files with hierarchical structures.
(use-package outline
  :ensure nil
  :commands outline-minor-mode
  :hook
  (;; Use " ▼" instead of the default ellipsis "..." for folded text to make
   ;; folds more visually distinctive and readable.
   (outline-minor-mode
    .
    (lambda()
      (let* ((display-table (or buffer-display-table (make-display-table)))
             (face-offset (* (face-id 'shadow) (ash 1 22)))
             (value (vconcat (mapcar (lambda (c) (+ face-offset c)) " ▼"))))
        (set-display-table-slot display-table 'selective-display value)
        (setq buffer-display-table display-table))))))

;; Enable the mode
(add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
(add-hook 'lisp-mode-hook #'outline-minor-mode)
(add-hook 'conf-mode-hook #'outline-minor-mode)
(add-hook 'markdown-mode-hook #'outline-minor-mode)
(add-hook 'diff-mode-hook #'outline-minor-mode)

(add-hook 'c-mode-hook #'hs-minor-mode)
(add-hook 'c++-mode-hook #'hs-minor-mode)
(add-hook 'java-mode-hook #'hs-minor-mode)
(add-hook 'sh-mode-hook #'hs-minor-mode)
(add-hook 'html-mode-hook #'hs-minor-mode)

;; The outline-indent Emacs package provides a minor mode that enables code
;; folding based on indentation levels.
;; In addition to code folding, outline-indent allows:
;; - Moving indented blocks up and down
;; - Indenting/unindenting to adjust indentation levels
;; - Inserting a new line with the same indentation level as the current line
;; - Move backward/forward to the indentation level of the current line
;; - and other features.
(use-package outline-indent
  :commands outline-indent-minor-mode
  :custom
  (outline-indent-ellipsis " ▼"))

;; Python
(add-hook 'python-mode-hook #'outline-indent-minor-mode)
(add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

;; Yaml
(add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
(add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)

;; Haskell
(add-hook 'haskell-mode-hook #'outline-indent-minor-mode)


;; Intelligent code folding by using the structural understanding of the
;; built-in tree-sitter parser. Unlike traditional folding methods that rely on
;; regular expressions or indentation, treesit-fold uses the actual syntax tree
;; of the code to accurately identify foldable regions such as functions,
;; classes, comments, and documentation strings. This allows for faster and more
;; precise folding behavior that respects the grammar of the programming
;; language, ensuring that fold boundaries are always syntactically correct even
;; in complex or nested code structures.
(use-package treesit-fold
  :load-path "/other-pkgs/treesit-fold"    ;; (bakin - git cloned package locally )
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)

  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ▼")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))

;; A few examples
(add-hook 'c-ts-mode-hook #'treesit-fold-mode)
(add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
(add-hook 'php-ts-mode-hook #'treesit-fold-mode)
(add-hook 'css-ts-mode-hook #'treesit-fold-mode)
(add-hook 'html-ts-mode-hook #'treesit-fold-mode)
(add-hook 'bash-ts-mode-hook #'treesit-fold-mode)


;;; package dumpjump to get _lightweight_ context-aware "go-to-definition"

(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register 'dumb-jump' as an xref backend so it integrates with
  ;; 'xref-find-definitions'. A priority of 90 ensures it is used only when no
  ;; more specific backend is available.
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90)

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

;;; package stripspace to automatically delete trailing whitespace

;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
(use-package stripspace
  :commands stripspace-local-mode

  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode)
         (markdown-mode . stripspace-local-mode)
         (gfm-mode . stripspace-local-mode))

  :custom
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (stripspace-restore-column t))

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

;;; package org-mode for organizing notes, etc. etc. etc. with simple markup syntax, with package org-appear

;; Org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))


;;; package auto-package-update will automate updating installed packages (weekly, but configurable)

;; This automates the process of updating installed packages
(use-package auto-package-update
  :custom
  ;; Set the number of days between automatic updates.
  ;; Here, packages will only be updated if at least 7 days have passed
  ;; since the last successful update.
  (auto-package-update-interval 7)

  ;; Suppress display of the *auto-package-update results* buffer after updates.
  ;; This keeps the user interface clean and avoids unnecessary interruptions.
  (auto-package-update-hide-results t)

  ;; Automatically delete old package versions after updates to reduce disk
  ;; usage and keep the package directory clean. This prevents the accumulation
  ;; of outdated files in Emacs's package directory, which consume
  ;; unnecessary disk space over time.
  (auto-package-update-delete-old-versions t)

  ;; Uncomment the following line to enable a confirmation prompt
  ;; before applying updates. This can be useful if you want manual control.
  (auto-package-update-prompt-before-update t)

  :config
  ;; Run package updates automatically at startup, but only if the configured
  ;; interval has elapsed.
  (auto-package-update-maybe)

  ;; Schedule a background update attempt daily at 10:00 AM.
  ;; This uses Emacs' internal timer system. If Emacs is running at that time,
  ;; the update will be triggered. Otherwise, the update is skipped for that
  ;; day. Note that this scheduled update is independent of
  ;; `auto-package-update-maybe` and can be used as a complementary or
  ;; alternative mechanism.
  (auto-package-update-at-time "10:00"))

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
