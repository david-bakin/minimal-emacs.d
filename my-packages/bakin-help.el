;;; bakin-help.el --- Setup package helpful, a better Emacs help buffer -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Package helpful is an alternative to the built-in Emacs help that provides
;; much more contextual information.
;;   (See https://github.com/Wilfred/helpful)


;;; Code:

(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  (([remap describe-command] . helpful-command)
   ([remap describe-function] . helpful-callable)
   ([remap describe-key] . helpful-key)
   ([remap describe-symbol] . helpful-symbol)
   ([remap describe-variable] . helpful-variable)
   ("C-c C-d" . helpful-at-point))
  :custom
  (helpful-max-buffers 7))


(provide 'bakin-help)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-help.el ends here
