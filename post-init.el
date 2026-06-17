;;; post-init.el --- customizations to run after Emacs + minimal Emacs init.el processing -*- no-byte-compile: t; lexical-binding: t; -*-

;;; TODO
;; backups don't seem to work
;; auto-save may not be saving correctly - e.g. save files name/location and also timeout 15s

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
  (uniquify-after-kill-buffer-p t)
  (uniquify-buffer-name-style 'post-forward-angle-brackets)
  (uniquify-separator "•")
  (uniquify-strip-common-suffix t)
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers)

;; automatically apply verified safe file-local variables
(setopt enable-local-variables :safe)

;; clipboard things
(setopt save-interprogram-paste-before-kill t
        kill-do-not-save-duplicates t)

;; proportional window resizing (good idea, or not?)
(setopt window-combination-resize t)

;; reversible `delete-other-windows` (see https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/)
;; (**N.B.:** See documentation on how it interacts - possibly badly! - with the tab bar,
;; and consider making this work with `tab-bar-history-mode`)
1(winner-mode 1)
(defun bakin-toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config"
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))
(global-set-key (kbd "C-x 1") #'bakin-toggle-delete-other-windows)

;; Get "(n/m)" in search prompt - you're at nth occurance of m matches
(setopt isearch-lazy-count t
        isearch-count-prefix-format "[%s of %s]")

;; control window splitting
(setq split-width-threshold 110   ;; split at 110 characters minimum
      split-height-threshold nil) ;; really avoid spliting top/bottom

;; comint-mode
(use-package comint
  :ensure nil
  :custom
  comint-buffer-maximum-size (* 6 1024)
  comint-eol-on-send t
  comint-input-ignoredups t
  comint-move-point-for-matching-input 'end-of-line
  comint-move-point-for-output t
  comint-scroll-show-maximum-output t
  comint-scroll-to-bottom-on-input t)

;; compile mode
(use-package compile
  :ensure nil
  :custom
  compilation-auto-jump-to-first-error 'if-location-known
  compilation-context-lines nil
  compilation-first-column 1
  compilation-window-height nil)

;; enable backup-files mode - all related vars are already set appropriately
(setq-default make-backup-files t)

;;;; fix syntax in re-builder (regexp builder - need to look into this!)
;;(use-package 're-builder
;;  :custom
;;  (reb-re-syntax 'string))

;; **TODO:** Look for more at https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/


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
;; minibuffer-regexp-mode
;; re-builder package


;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
