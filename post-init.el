;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;;; TODO

;; 2) If c compiler and build tools are available consider package vterm
;; 4) consider dired-omit-files esp. if there's a way to toggle the hidden files on/off
;; 5) there are various autosave mechanisms - do they conflict?
;; 6) consider elpaca package manager and/or straight.el
;; 7) figure out visual line mode and use it or not - see also visual-line-fringe-indicators (https://vlevit.org/en/blog/tech/visual-line-wrap)
;;    and whitespace-mode and auto-fill-mode
;; 9) bind `ibuffer` to a key to use it like bufed (^x^b in epsilon)



;;; package path manipulation - setup for my packages (so that they can be byte-compiled)

(let ((full-path (expand-file-name "my-packages" minimal-emacs-user-directory)))
  (if (file-directory-p full-path)
      (unless (member full-path load-path)
        (push full-path load-path))
    (message "Directory does not exist, skipping load: %s" full-path)))

(require 'bakin-init-my-packages)


;; ---------------------------------------------------------------------------

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



;; confirm before exiting - confirm if native comp running is done in bakin-compile-angel.el
;;(setq confirm-kill-emacs 'y-or-n-p)
;;(setq confirm-kill-processes t)

;; automatically apply verified safe file-local variables
(setq enable-local-variables :safe)



;; other vars to consider:
;; dired-compress-files-alist
;; grep-find-ignored-files
;; grep-find-ignored-directories
;; lpr-command                    ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Printing.html
;; lpr-header-switches            ;;   see also Printing Package https://www.gnu.org/software/emacs/manual/html_node/emacs/Printing-Package.html
;; lpr-switches                   ;;   see also https://www.gnu.org/software/emacs/manual/html_node/emacs/PostScript-Variables.html
;; printer-name
;; resize-mini-windows            ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Single-Shell.html
;; max-mini-window-height

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
