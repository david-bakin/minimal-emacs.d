;;; bakin-themes.el --- Set up themes (color schemes) -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; I just picked a theme I liked out of the build-in themes.  There are plenty of others.
;; Also, turn on the tab bar (but only when multiple tabs are open).  And use package
;; vim-tab-bar to give the tab bar the same theme as Emacs is using (and why isn't _that_
;; functionality built-in?)
;;
;; See https://github.com/jamescherti/vim-tab-bar.el for package vim-tab-bar.

;;; Code:


(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-operandi-deuteranopia t))

;;; Give Emacs tab-bar the same theme as Emacs itself

(use-package vim-tab-bar
  :commands vim-tab-bar-mode
  :hook (after-init . vim-tab-bar-mode))

;; (bakin) turn on tab-bar mode
(tab-bar-mode)
(setopt tab-bar-show 1)  ;; only show tab bar when multiple tabs are open


(provide 'bakin-themes)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-themes.el ends here
