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
;; When auto-save-visited-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.
;;
;; This is different from auto-save-mode: auto-save-mode periodically saves
;; all modified buffers, creating backup files, including those not associated
;; with a file, while auto-save-visited-mode only saves file-visiting buffers
;; after a period of idle time, directly saving to the file itself without
;; creating backup files.
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


(setq auto-save-default t
      auto-save-interval 300           ; Trigger an auto-save after 300 keystrokes
      auto-save-timeout 60            ; Trigger an auto-save 60 seconds of idle time
      auto-save-visited-interval 10)   ; Save after 10 seconds of inactivity
(auto-save-visited-mode 1)

(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))

(use-package buffer-guardian
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  (buffer-guardian-save-all-buffers-idle 60)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :hook
  (after-init . buffer-guardian-mode))


(provide 'bakin-save-stuff)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-save-stuff.el ends here
