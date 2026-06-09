;;; bakin-init-my-packages.el --- Load all of my packages -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Load all of my packages.
;; TODO: Consider auto-loading everything in this directory

;;; Code:


;; Should be first to ensure everything else is byte-compiled
(require 'bakin-compile-angel)

(require 'bakin-autorevert)
(require 'bakin-ordinary-file-editing)
(require 'bakin-recentf)
(require 'bakin-register-w32-hot-key)
(require 'bakin-save-stuff)

;; Just for the record, emit a message with all my loaded packages
(let ((my-packages (sort (seq-filter '(lambda (elt) (string-prefix-p "bakin-" (symbol-name elt))) features))))
  (message "My packages loaded: %s" my-packages))


(provide 'bakin-init-my-packages)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-init-my-packages.el ends here
