;;; bakin-compile-angel.el --- Set up package compile-angel to ensure all elisp code is byte-compiled -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Native compilation enhances Emacs performance by converting Elisp code into
;; native machine code, resulting in faster execution and improved
;; responsiveness.
;;
;; (In fact, GNU Emacs for Windows does not seem to have native compilation
;; support.  But byte-compilation still works.
;;
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.

;;; Code:


(use-package compile-angel
  :demand t
  :config
  ;; The following disables compilation of packages during installation;
  ;; compile-angel will handle it.
  (setq package-native-compile nil)

  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (push "/var/history" compile-angel-excluded-files)            ;; savehist
  (push "/var/persist-text-scale" compile-angel-excluded-files) ;; persist-text-scaling
  (push "/var/recentf" compile-angel-excluded-files)            ;; recentf
  (push "/var/saveplace" compile-angel-excluded-files)          ;; saveplace
  (push "/my-packages/bakin-init-my-packages.el" compile-angel-excluded-files) ;; always causes a native compile hang!!

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1)

  ;; Ensure that quitting only occurs once Emacs finishes native compiling,
  ;; preventing incomplete or leftover compilation files in `/tmp`.
  (setq native-comp-async-query-on-exit t)
  (setq confirm-kill-processes t)

  ;; Enable compilation of packages during installation - compile-angel will
  ;; handle it.
  (setq package-native-compile t)
  )


(provide 'bakin-compile-angel)


;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-compile-angel.el ends here
