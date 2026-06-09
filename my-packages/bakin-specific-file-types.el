;;; bakin-specific-file-types.el --- Set up for specific file types, e.g. YAML, CSV -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Support for git files (broken: signature problem loading package), yaml, dockerfile, jinga2,
;; and CSV (broken: signature problem loading package)


;;; Code:

;; Git file support

;; 2026-06-09 - broken - Can't load due to some kind of PGP signature error
;; ;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
;; (use-package git-modes
;;   :commands (gitattributes-mode
;;              gitconfig-mode
;;              gitignore-mode)
;;   :mode (("/\\.gitignore\\'" . gitignore-mode)
;;          ("/info/exclude\\'" . gitignore-mode)
;;          ("/git/ignore\\'" . gitignore-mode)
;;          ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles
;; 
;;          ("/\\.gitconfig\\'" . gitconfig-mode)
;;          ("/\\.git/config\\'" . gitconfig-mode)
;;          ("/modules/.*/config\\'" . gitconfig-mode)
;;          ("/git/config\\'" . gitconfig-mode)
;;          ("/\\.gitmodules\\'" . gitconfig-mode)
;;          ("/etc/gitconfig\\'" . gitconfig-mode)
;; 
;;          ("/\\.gitattributes\\'" . gitattributes-mode)
;;          ("/info/attributes\\'" . gitattributes-mode)
;;          ("/git/attributes\\'" . gitattributes-mode)))

;; Support for YAML files.

;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;;; Support for Dockerfile files.

;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;;; Support for Jinja2 files

;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;;; Support for CSV files

;; 2026-06-09 - broken - Can't load due to some kind of PGP signature error
;; ;; CSV file support with automatic column alignment. This configuration enables
;; ;; csv-align-mode whenever a CSV file is opened, improving readability by
;; ;; keeping columns visually aligned according to a configurable maximum width
;; ;; and a set of recognized field separators.
;; (use-package csv-mode
;;   :commands (csv-mode
;;              csv-align-mode
;;              csv-guess-set-separator)
;;   :mode ("\\.csv\\'" . csv-mode)
;;   :hook ((csv-mode . csv-align-mode)
;;          (csv-mode . csv-guess-set-separator))
;;   :custom
;;   (csv-align-max-width 100)
;;   (csv-separators '("," ";" " " "|" "\t")))


(provide 'bakin-specific-file-types)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-specific-file-types.el ends here
