;;; post-init.el --- customizations to run after Emacs + minimal Emacs init.el processing -*- no-byte-compile: t; lexical-binding: t; -*-

;;; TODO

;; --

;;; package path manipulation - setup for my packages (so that they can be byte-compiled)

(let ((full-path (expand-file-name "my-packages" minimal-emacs-user-directory)))
  (if (file-directory-p full-path)
      (unless (member full-path load-path)
        (push full-path load-path))
    (message "Directory does not exist, skipping load: %s" full-path)))

(require 'bakin-init-my-packages)


;;; package server - use emacs as a server for emacsclient

;; The Emacs server allows external programs such as `emacsclient' to connect to
;; a single running instance of Emacs. This makes it possible to open files in
;; the existing session rather than starting a new Emacs process each time.
;;
;; Once the server is running, the `emacsclient' command can be used in the
;; terminal to open files in the active Emacs session. For example, running the
;; following command opens the file in the existing Emacs frame without blocking
;; the terminal process.
;;   emacsclient -n --server-file="%USERPROFILE%\.emacs.d\var\server\minimal" filename.txt
;;

(setq bakin--server-name "minimal")

(use-package server
  :ensure nil
  :if (not (daemonp))
  :commands (server-running-p
             server-start)
  :hook (after-init . my-server-start)
  :preface
  (defun my-server-start ()
    "Start the Emacs server if no server process is currently active, given a specific name for it"
    (unless (server-running-p)
      (setq server-use-tcp t)
      (setq server-name bakin--server-name)
      (message "Starting server as '%s'\n" server-name)
      (server-start))))



;;; Other customizations (not sufficiently distinct - or large - enough to find a package for them)


;; Set max level of syntax highlighting for tree-sitter modes
(setq treesit-font-lock-level 4)

;; ensure unique buffer names
(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name 'forward)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers)

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
