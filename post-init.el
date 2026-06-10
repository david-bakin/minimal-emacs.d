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
;; 9) bind `ibuffer` to a key to use it like bufed (^x^b in epsilon)


;;; package path manipulation - setup for my packages (so that they can be byte-compiled)

(let ((full-path (expand-file-name "my-packages" minimal-emacs-user-directory)))
  (if (file-directory-p full-path)
    (unless (member full-path load-path)
      (push full-path load-path))
    (message "Directory does not exist, skipping load: %s" full-path)))

(require 'bakin-init-my-packages)


;; ---------------------------------------------------------------------------


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

;;; package bufferfile.el has helper functions to delete, rename, or copy buffer files

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


;;; Other customizations



;; Typed text replaces selection (like in most editors)
(delete-selection-mode 1)



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

;; dired: constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; dired: omit some files (but toggle viewing them with `C-x M-o`
(setq dired-omit-files (concat "\`[.]\'"
                               "\|^\.DS_Store\'"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; dired: group directories first
(with-eval-after-load 'dired
  (setq dired-listing-switches "--group-directories-first -ahlv"))

;; confirm before exiting
;;(setq confirm-kill-emacs 'y-or-n-p)
;;(setq confirm-kill-processes t)

;; automatically apply verified safe file-local variables
(setq enable-local-variables :safe)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
