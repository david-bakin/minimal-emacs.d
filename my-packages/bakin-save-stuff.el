;;; bakin-save-stuff.el --- Set up packages related to saving various things over sessions -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; savehist - preserves minibuffer history between sessions
;; saveplace - remembers the last location within a file when reopening it
;; auto-save-mode, auto-save-visited-mode enabled
;; persist-text-scale - ensure text size in each buffer is consistent after restart
;; buffer-guardian - automatically saves buffers when they lose focus, emacs is idle, etc.
;;
;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.  (Built-in package)
;;
;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off. (Built-in package)
;;
;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
;;
;; When auto-save-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.  This will save off to a special file in
;; `/var/autosave`.  (By contrast auto-save-visited-mode saves files over
;; themselves.)
;;
;; Package persist-text-scale to ensure text size in each buffer remains consistent
;; even after restarting Emacs.
;;   (See https://github.com/jamescherti/persist-text-scale.el)
;;
;; Package buffer-guardian - "Automatically save Emacs buffers without manual
;; intervention (when buffers lose focus, regularly, or after emacs is idle)."
;;   (See https://github.com/jamescherti/buffer-guardian.el)


;;; Code:

(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300
        savehist-autosave-interval 300))

(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))
;; and from https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/:
(advice-add 'save-place-find-file-hook :after
            #'(lambda (&rest _)
                (when buffer-file-name (ignore-errors (recenter)))))


;; Configure built-in auto-saving of modified buffers
(setq auto-save-default t
      auto-save-interval 500           ; Trigger an auto-save after 500 keystrokes
      auto-save-no-message nil         ; No message printed on an auto-save
      auto-save-timeout 30)            ; Trigger an auto-save 120 seconds of idle time
(auto-save-mode 1) ;; NOT `auto-save-visited-mode`
;; ... add "X:" and "//" prefixes to the second regexp to match Windows drive-letter and UNC
;;     filenames
(setq auto-save-file-name-transforms
      `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
         ,(file-name-concat auto-save-list-file-prefix "tramp-\\2-") sha1)
        ("\\`\\(/\\|[a-zA-Z]:/\\|//\\)\\([^/]+/\\)*\\([^/]+\\)\\'"
         ,(file-name-concat auto-save-list-file-prefix "\\3") sha1)))

;; As is, with above transforms, and specifying a hash algorithm (sha1) the save file
;; will be `.emacs.d/var/autosave/#hash#` and you have to look in the auto-save-list-file
;; to find the actual mapping (and/or use `M-x recover-file`).  But the following function,
;; modified from `files--transform-file-name` of Emacs' `files.el` will make it be
;; `.emacs.d/var/autosave/#filename#hash` - this function is "installed" via an `:override`
;; advice.
(defun bakin-files--transform-file-name (filename transforms prefix suffix)
  "Transform FILENAME according to TRANSFORMS.
See `auto-save-file-name-transforms' for the format of
TRANSFORMS.  PREFIX is prepended to the non-directory portion of
the resulting file name, and SUFFIX is appended."
  ;;(message ">> bakin-files--transform-file-name %S %S %S" filename prefix suffix)
  (save-match-data
    (let (result uniq)
      ;; Apply user-specified translations to the file name.
      (while (and transforms (not result))
        (if (string-match (car (car transforms)) filename)
            (setq result (replace-match (cadr (car transforms)) t nil
                                        filename)
                  uniq (car (cddr (car transforms)))))
        (setq transforms (cdr transforms)))
      (when result
        (setq filename
              (cond
               ((memq uniq (secure-hash-algorithms))
                (concat
                 (file-name-directory result)
                 (file-name-nondirectory result)
                 "#"
                 (secure-hash uniq filename)))
               (uniq
                (concat
                 (file-name-directory result)
                 (subst-char-in-string
                  ?/ ?!
                  (string-replace
                   "!" "!!" filename))))
               (t result))))
      (setq result
            (if (and (eq system-type 'ms-dos)
                     (not (msdos-long-file-names)))
                ;; We truncate the file name to DOS 8+3 limits before
                ;; doing anything else, because the regexp passed to
                ;; string-match below cannot handle extensions longer
                ;; than 3 characters, multiple dots, and other
                ;; atrocities.
                (let ((fn (dos-8+3-filename
                           (file-name-nondirectory buffer-file-name))))
                  (string-match
                   "\\`\\([^.]+\\)\\(\\.\\(..?\\)?.?\\|\\)\\'"
                   fn)
                  (concat (file-name-directory buffer-file-name)
                          prefix (match-string 1 fn)
                          "." (match-string 3 fn) suffix))
              (concat (file-name-directory filename)
                      prefix
                      (file-name-nondirectory filename)
                      suffix)))
      ;;(message "--bakin-files-transform-file-name %S" result)
      ;; Make sure auto-save file names don't contain characters
      ;; invalid for the underlying filesystem.
      (expand-file-name
       (if (and (memq system-type '(ms-dos windows-nt cygwin))
                ;; Don't modify remote filenames
                (not (file-remote-p result)))
           (convert-standard-filename result)
         result)))))
(advice-add 'files--transform-file-name :override 'bakin-files--transform-file-name)


;; This small feature persists the text scaling parameter currently in use, and when
;; restarting Emacs will ensure all buffers (recreated by saving them) use that text
;; scaling.  Otherwise they could have mixed sizes.
(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))

;; (use-package buffer-guardian
;;   :custom
;;   ;; DO NOT save remote files in the auto-save process
;;   (buffer-guardian-inhibit-saving-remote-files t)
;;
;;   ;; DO NOT save buffers visiting nonexistent files
;;   (buffer-guardian-inhibit-saving-nonexistent-files t)
;;
;;   ;; Do NOT save the buffer on windows focus loss
;;   (buffer-guardian-save-on-focus-loss nil)
;;
;;   ;; Do NOT save the buffer when minibuffer opens
;;   (buffer-guardian-save-on-minibuffer-setup nil)
;;
;;   ;; Do NOT save on buffer switch
;;   (buffer-guardian-save-on-buffer-switch nil)
;;
;;   ;; Do NOT save on window selection change
;;   (buffer-guardian-save-on-window-selection-change nil)
;;
;;   ;; Do NOT save on window configuration change
;;   (buffer-guardian-save-on-window-configuration-change nil)
;;
;;   ;; Save the buffer even if the window change results in the same buffer
;;   (buffer-guardian-save-on-same-buffer-window-change nil)
;;
;;   ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
;;   (buffer-guardian-verbose t)
;;
;;   ;; Interval to save all buffers after N seconds (disabled by default)
;;   (buffer-guardian-save-all-buffers-interval nil)
;;
;;   ;; Save all buffers after N seconds of user idle time. (Disabled by default)
;;   (buffer-guardian-save-all-buffers-idle nil))
;;
;;   :hook
;;   (after-init . buffer-guardian-mode))


(provide 'bakin-save-stuff)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-save-stuff.el ends here
