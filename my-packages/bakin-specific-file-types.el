;;; bakin-specific-file-types.el --- Set up for specific file types, e.g. YAML, CSV -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Support for git files (broken: signature problem loading package),
;; and CSV (broken: signature problem loading package)
;;
;; package git-modes (part of magit) (see https://github.com/magit/git-modes)


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
