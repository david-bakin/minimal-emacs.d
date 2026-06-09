;;; bakin-dumb-jump.el --- Set up package dumb jump, lightweight, general, context-aware "go to definition" -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Package Dumb Jump - see https://github.com/jacktasia/dumb-jump
;;
;; "Dumb Jump is an Emacs "jump to definition" and "find references" package with support
;; for 60+ programming languages that favors "just working". This means minimal -- and
;; ideally zero -- configuration with absolutely no stored indexes (TAGS) or persistent
;; background processes.

;;; Code:

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

(provide 'bakin-dumb-jump)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-dumb-jump.el ends here
