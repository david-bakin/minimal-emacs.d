;;; register-w32-hot-key.el --- Set up hot keys for win32 (that are normally eaten by the OS) -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Register certain M- (meta key) combinations in order to bypass Window's own processing of them
;; see https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows-Keyboard.html
;; also see http://xahlee.info/emacs/emacs/emacs_windows_meta_key.html


;;; Code:

(setq w32-alt-is-meta t)
(w32-register-hot-key [M-:]) ;; 'eval-expression

(provide 'bakin-register-w32-hot-key)


;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; register-w32-hot-key.el ends here
