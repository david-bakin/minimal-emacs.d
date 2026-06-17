;;; bakin-whitespace.el --- Set up package stripspace to automatically delete trailing whitespace -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; The (built-in) whitespace package provides [global-]whitespace-mode, a minor
;; mode that highlights whitespace, empty lines, etc. in a configurable way.
;;
;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
;;   (See https://github.com/jamescherti/whitespace.el)
;;
;; Set up the fill-column indicator to warn of "long lines"
;;
;; And ... not sure if it belongs in this file ... but set up the text cursor color and the
;; selection color.

;;; Code:

(setq fill-column 80)

(use-package whitespace
  :custom
  (show-trailing-whitespace t)
  (indicate-empty-lines t)
  (whitespace-line-column 100)
  (whitespace-style '(face
                      empty
                      lines-tail
                      missing-newline-at-eof
                      newline-mark
                      page-delimiters
                      tab-mark
                      tabs
                      trailing
                      ))
  (whitespace-display-mappings '((newline-mark 10 [182 10]) ;; ¶ (PILCROW SIGN)
                                 (tab-mark 9 [9655 9])))    ;; ▷ (WHITE RIGHT-POINTING TRIANGLE)
  :config
  (set-face-attribute 'whitespace-line nil :foreground "black" :background "salmon")
  (global-whitespace-mode 1))


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


;; Fill-column-indicator will show the boundary where lines are "too long"
(setq-default display-fill-column-indicator-column 100
              display-fill-column-indicator-character ?▏)
(global-display-fill-column-indicator-mode t)
(set-face-attribute 'fill-column-indicator nil :foreground "#E8B200" :background "white")
(setq-default indicate-buffer-boundaries 'left)


;; setting cursor and selection colors - not sure how this relates to themes
;; (perhaps it should be _done_ by themes?)
(set-face-attribute 'cursor nil :background "chartreuse")
(set-face-attribute 'region nil :background "deep sky blue" :foreground "white")


;; don't draw cursors in non-selected windows, or highlight selections either
(setopt cursor-in-non-selected-windows nil
        highlight-nonselected-windows nil)

(provide 'bakin-whitespace)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-whitespace.el ends here
