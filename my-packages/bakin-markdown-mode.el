;;; bakin-markdown-mode.el --- Set up markdown mode -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;;; package markdown-mode and markdown-toc - for editing markdown 
;;  **N.B.: need to test integration of pandoc and mdlook**

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).


;;; Code:

(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :init
  (setq markdown-command '("C:\\Scoop\\Local\\apps\\pandoc\\current\\pandoc" "--from=markdown" "--to=html5"))    ;; (bakin)
  (setq markdown-open-command '("C:\\Users\\david\\AppData\\Local\\Programs\\MDLook\\MDLook.exe"))               ;; (bakin)
  (setq markdown-enable-math t)                                                                                  ;; (bakin)

  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . gfm-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))

;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Contents**"))


(provide 'bakin-markdown-mode)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-markdown-mode.el ends here
