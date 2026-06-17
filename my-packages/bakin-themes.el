;;; bakin-themes.el --- Set up themes (color schemes) and default font and some other random visual stuff -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; I just picked a theme I liked out of the build-in themes.  There are plenty of others.
;; Also, turn on the tab bar (but only when multiple tabs are open).  And use package
;; vim-tab-bar to give the tab bar the same theme as Emacs is using (and why isn't _that_
;; functionality built-in?)
;;
;; Also choose PragmataPro Mono as default font.
;;
;; See https://github.com/jamescherti/vim-tab-bar.el for package vim-tab-bar.
;;
;; Also:
;; - Set width of "fringes"
;; - line/col#s in mode line
;; - mouse-moveable window dividers
;; - visible indication of minibuffer recursion depth
;; - tooltip delays
;;
;; (It would be sweet to support ligatures - https://github.com/mickeynp/ligature.el - but
;; the standard version of Gnu Emacs is apparently not built with Cairo on Windows.)  (BUT
;; wait a second!  The installation directory contains `libcairo-2.dll` ... so why does
;; `C-h v cairo-version-string` not work?) (Anyway, should at least test ligatures
;; package ...)

;;; Code:


(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-operandi-deuteranopia t))

;; Set the default font to DejaVu Sans Mono with specific size and weight
(set-face-attribute 'default nil
                    :height 130 :weight 'normal :family "PragmataPro Mono")

;; Give Emacs tab-bar the same theme as Emacs itself

(use-package vim-tab-bar
  :commands vim-tab-bar-mode
  :hook (after-init . vim-tab-bar-mode))

;; (bakin) turn on tab-bar mode
(tab-bar-mode)
(setopt tab-bar-show 1)  ;; only show tab bar when multiple tabs are open

;; Set fringes to match pixel width of a character
(fringe-mode (frame-char-width))

;; Display line/col numbers in mode line
(setq line-number-mode t
      column-number-mode t
      mode-line-position-column-line-format '("%l:%c"))

;; And display line numbers in buffer for prog-mode buffers
(setopt display-line-numbers-grow-only t    ;; only let them get wider
        display-line-numbers-type t         ;; absolute line numbers
        display-line-numbers-width-start t) ;; initially size line numbers to buffer's needs
(setq-default display-line-numbers-widen t  ;; line numbers even when buffer's narrowed
              display-line-numbers-width 4) ;; initially start with 4 columns, even if not needed

(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; add movable windows dividers
(add-hook 'after-init-hook #'window-divider-mode)

;; enable visual indication of minibuffer recursion depth
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)
;; **TODO:** use variable `recursion-depth` to indicate general editor recursion
;; in mode line

;; fixups for tooltip mode (so there's a delay)
(setq tooltip-hide-delay 20    ;; seconds, before it disappears
      tooltip-delay 0.4        ;; delay after mouse move
      tooltip-short-delay 0.08 ;; delay before a short tooltip
      tooltip-x-offset 5
      tooltip-y-offset 25)
(tooltip-mode 1)


(provide 'bakin-themes)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-themes.el ends here
