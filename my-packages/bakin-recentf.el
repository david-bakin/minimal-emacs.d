;;; bakin-recentf.el --- Setup package recentf to maintain (persistently) a list of recently accessed files -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.


;;; Code:

(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\.tar$" "\.tbz2$" "\.tbz$" "\.tgz$" "\.bz2$"
              "\.bz$" "\.gz$" "\.gzip$" "\.xz$" "\.zip$"
              "\.7z$" "\.rar$"
              "COMMIT_EDITMSG\'"
              "\.\(?:gz\|gif\|svg\|png\|jpe?g\|bmp\|xpm\)$"
              "-autoloads\.el$" "autoload\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))


(provide 'bakin-recentf)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-recentf.el ends here
