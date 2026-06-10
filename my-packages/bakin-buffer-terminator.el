;;; bakin-buffer-terminator.el --- Set up package buffer-terminator to automatically and safely kill buffers  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; package buffer-terminator _automatically and safely kills buffers_
;;   (see https://github.com/jamescherti/buffer-terminator.el)

;;; Code:

(use-package buffer-terminator
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose t)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 60 60))

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 20 60))

  :config
  (buffer-terminator-mode 1))


(provide 'bakin-buffer-terminator)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-buffer-terminator.el ends here
