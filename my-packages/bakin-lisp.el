;;; bakin-lisp.el --- Better elisp development 'experience' (with multiple packages) -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; package aggressive-indent - a minor mode that keeps your code _always_ indented, intenting after every change
;;   see https://github.com/Malabarba/aggressive-indent-mode
;;   (can be used in any programming mode; see README there for how to make it work nicer for c++)

;; package highlight-defined - a minor mode that highlights defined elisp symbols
;;   see https://github.com/Fanael/highlight-defined
;;   (see README there for how to customized faces)

;; package paredit - parenthetical editing in emacs - prevents parenthesis imbalance via structural editing
;; **N.B.:** Seems too "strong" for me - demands use of its keys to open/close parenthesized expressions
;; in S-expressions.  Does _not_ work well when just typing parens yourself.  You need to go full in.
;;   see https://paredit.org/ 
;;   and also see "Paredit's Keybinding Conflicts" https://emacsredux.com/blog/2026/03/27/paredit-keybinding-conflicts/
;;   and also consider package smartparens https://github.com/Fuco1/smartparens

;; package page-break-lines - display horizontal rule instead of "^L", if you use "^L" for force page breaks
;; in source code (I didn't know anyone else but me did that ...)
;;   see https://github.com/purcell/page-break-lines
;; Plus remember emacs has jumping around between page breaks with "C-x [" (backward-page) and "C-x ]" (forward-page).

;;; Better elisp development "experience" - with packages paredit, page-break-lines, elisp-refs

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; ;; Prevent parenthesis imbalance
;; (use-package paredit
;;   :commands paredit-mode
;;   :hook
;;   (emacs-lisp-mode . paredit-mode)
;;   :config
;;   (define-key paredit-mode-map (kbd "RET") nil))

;; Displays visible indicators for page breaks
(use-package page-break-lines
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;;; Code:





(provide 'bakin-lisp)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-lisp.el ends here
