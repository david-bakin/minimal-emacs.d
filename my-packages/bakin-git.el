;;; bakin-git.el --- Configure git and magit -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; package diff-hl to highlight git uncommitted changes in the window margin
;;   (see https://github.com/dgutov/diff-hl)
;; **TODO:** Later, configure magit


;;; Code:

(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)           ; Do not block Emacs while updating these marginal things
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))


(provide 'bakin-git)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-git.el ends here
