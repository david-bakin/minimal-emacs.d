;;; bakin-init-my-packages.el --- Load all of my packages -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Load all of my packages.
;; TODO: Consider auto-loading everything in this directory (without having to list packages explicitly)

;;; Code:


;; Should be first to ensure everything else is byte-compiled
(require 'bakin-compile-angel)

(require 'bakin-auto-package-update)
(require 'bakin-autorevert)
(require 'bakin-dumb-jump)
(require 'bakin-easysession)
(require 'bakin-folding)
(require 'bakin-markdown-mode)
(require 'bakin-ordinary-file-editing)
(require 'bakin-org-mode)
(require 'bakin-recentf)
(require 'bakin-register-w32-hot-key)
(require 'bakin-save-stuff)
(require 'bakin-specific-file-types)
(require 'bakin-stripspace)
(require 'bakin-themes)
(require 'bakin-treemacs)


;; Just for the record, emit a message with all my loaded packages
(let* ((my-packages (sort (seq-filter #'(lambda (elt) (string-prefix-p "bakin-" (symbol-name elt))) features)))
      (wrapped (string-fill (string-trim (prin1-to-string my-packages) "[(]" "[)]") 100)))
  (message "⤋ ⤋ ⤋ ⤋ --- My packages loaded:\n%s\n⤊ ⤊ ⤊ ⤊" wrapped))


(provide 'bakin-init-my-packages)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-init-my-packages.el ends here
