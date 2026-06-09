;;; bakin-ordinary-file-editing.el --- Change defaults for ordinary file editing -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Set up things the way I ordinarily like it during ordinary text editing.
;; Specifically: NO TABS! (at least for indenting)  And, always terminate files
;; with newline characters

;;; Code:

(setq-default indent-tabs-mode nil)
(setq require-final-newline t)

(provide 'bakin-ordinary-file-editing)


;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-ordinary-file-editing.el ends here
