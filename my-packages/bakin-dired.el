;;; bakin-dired.el --- Set up customizations for dired -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Customizations for (built-in) dired-mode (and associated dired-x file)


;;; Code:

(require 'dired)
(require 'dired-x)

;; dired will always start in omit-files mode
(add-hook 'dired-mode-hook #'(lambda () (dired-omit-mode 1)))

;; omit some files (but toggle viewing them with "C-x M-o")
;;    see https://www.gnu.org/software/emacs/manual/html_node/dired-x/Omitting-Variables.html
(setq dired-omit-files (concat "\`[.]\'"
                               "\`desktop.ini\'"
                               "\'thumbs.db\'"
                               "\|^\.DS_Store\'"))

;; set up the ls-lisp `ls` utility emulation (for Windows)
(setq ls-lisp-dirs-first t                ;; sort all directories before files
      ls-lisp-ignore-case t               ;; case-insensitive sort order
      ls-lisp-support-shell-wildcards t   ;; use shell globbing if t, otherwise regexp if nil
      ls-lisp-UCA-like-collation t        ;; ensure Unicode Collation Algorithm (UCA), not clear whether this is just for UTF-8 locale or not
      ls-lisp-verbosity '(links uid gid)) ;; show #hard links, uid, and gid

;; set default listing switchs (not sure how this related to individual dired
;; variables above)
(setq dired-listing-switches "--group-directories-first -ahlv")

;; constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; do NOT delete directories recursively
(setq dired-recursive-deletes nil)

;; don't bother with "trash", just delete files permanently
(setq delete-by-moving-to-trash nil)

;; kill current dired buffer when moving to a new one (only 1 dired buffer ever)
(setq dired-kill-when-opening-new-dired-buffer t)

;; create non-existent directories during copy/move, and create the destination
;; dir if it ends with a `/`
(setq dired-create-destination-dirs 'always
      dired-create-destination-dirs-on-trailing-dirsep t)

;; keep modification time of old file in the copy, when copying
(setq dired-copy-preserve-time t)

;; ask user if should copy directories recursively
(setq dired-recursive-copies 'ask)

;; rename files using underlying VCS command (if in a repo)
(setq dired-vc-rename-file t)

;; revert (i.e., refresh) dired buffer every time you visit it
(setq dired-auto-revert-buffer t)


(provide 'bakin-dired)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-dired.el ends here
