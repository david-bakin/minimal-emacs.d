;;; post-early-init.el --- run by minimal-emacs.d _after_ early-init.el -*- no-byte-compile: t; lexical-binding: t; -*-

(setq native-comp-async-report-warnings-errors 'silent) ;; report but do not display - https://doc.emacsen.de/30.2/var/native-comp-async-report-warnings-errors.html
(setq native-comp-async-warnings-errors-kind 'all) ;; https://doc.emacsen.de/30.2/var/native-comp-async-warnings-errors-kind.html
(setq native-comp-async-jobs-number 2) ;; https://doc.emacsen.de/30.2/var/native-comp-async-jobs-number.html
(add-hook 'native-comp-async-all-done-hook
          #'(lambda () (message "[post-early-init] Native compilation completed.")) 30)
(setq inhibit-startup-buffer-menu nil) ;; show buffer list when >2 files loaded -  https://doc.emacsen.de/30.2/var/inhibit-startup-buffer-menu.html
