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

  (let ((no-native-compile-files '("/init.el"
                                   "/early-init.el"
                                   "/pre-init.el"
                                   "/post-init.el"
                                   "/pre-early-init.el"
                                   "/post-early-init.el"
                                   "/var/history"            ;; savehist
                                   "/var/persist-text-scale" ;; persist-text-scaling
                                   "/var/recentf"            ;; recentf
                                   "/var/saveplace"          ;; saveplace
                                   "/my-packages/bakin-init-my-packages.el")))  ;; this one always causes a native compile hang!
    (dolist (file no-native-compile-files)
      (push file compile-angel-excluded-files)))

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1)

  ;; Ensure that quitting only occurs once Emacs finishes native compiling,
  ;; preventing incomplete or leftover compilation files in `/tmp`.
  (setq native-comp-async-query-on-exit t
        confirm-kill-processes t
        confirm-kill-emacs 'y-or-n-p)

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
