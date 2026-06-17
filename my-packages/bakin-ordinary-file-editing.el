;;; bakin-ordinary-file-editing.el --- Change defaults for ordinary file editing -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Set up things the way I ordinarily like it during ordinary text editing.
;; Specifically: NO TABS! (at least for indenting)  And, always terminate files
;; with newline characters.  Set UTF-8 as default throughout.  Match parenthesis.
;; Some other stuff.

;;; Code:

(use-package emacs
  :custom
  (show-paren-mode 1)                        ; highlight parens ...
  (show-paren-style 'mixed)                  ; ... just the parens, unless the matching paren is not visible
  (setq show-paren-context-when-offscreen 'overlay) ; show the open paren context
  (setq-default indent-tabs-mode nil)        ; NO HARD TABS! (this doesn't strictly enforce that though it's generally sufficient)
  (setq require-final-newline t)             ; force files to end with newline (when saved)
  (delete-selection-mode 1)                  ; typed text replaces selection (like most editors)
  (set-language-environment 'utf-8)          ; set language/coding systems to default to UTF-8
  (set-default-coding-systems 'utf-8)        ;   these 4 lines suggested at from http://xahlee.info/emacs/emacs/emacs_file_encoding.html
  (set-keyboard-coding-system 'utf-8-unix)
  (set-terminal-coding-system 'utf-8-unix)   ; add this especially on Windows, else python output problem
  (which-key-mode)                           ; incomplete commands yield helpful popup - https://github.com/justbur/emacs-which-key
  (setq which-key-side-window-location '(right bottom)
        which-key-side-window-max-width 0.33
        which-key-side-window-max-height 0.25
        which-key-idle-delay 5.0
        which-key-idle-secondary-delay 0.25
        which-key-use-C-h-commands t)
  (set-scroll-bar-mode 'right)
  (horizontal-scroll-bar-mode t)
  )


(provide 'bakin-ordinary-file-editing)


;; Local variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-ordinary-file-editing.el ends here
