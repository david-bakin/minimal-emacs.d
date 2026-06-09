;;; bakin-auto-package-update.el --- Set up package auto-package-update to automate updating installed packages -*- lexical-binding: t; -*-

;; Copyright (C) 2026 David Bakin

;; Author: David Bakin <david@bakins-bits.com>
;; Created: 09 Jun 2026

;;; Commentary:

;; Package auto-package-update will automate updating installed packages. Interval
;; is configurable, but is weekly below.

;;; Code:

;; This automates the process of updating installed packages
(use-package auto-package-update
  :custom
  ;; Set the number of days between automatic updates.
  ;; Here, packages will only be updated if at least 7 days have passed
  ;; since the last successful update.
  (auto-package-update-interval 7)

  ;; Suppress display of the *auto-package-update results* buffer after updates.
  ;; This keeps the user interface clean and avoids unnecessary interruptions.
  (auto-package-update-hide-results t)

  ;; Automatically delete old package versions after updates to reduce disk
  ;; usage and keep the package directory clean. This prevents the accumulation
  ;; of outdated files in Emacs's package directory, which consume
  ;; unnecessary disk space over time.
  (auto-package-update-delete-old-versions t)

  ;; Uncomment the following line to enable a confirmation prompt
  ;; before applying updates. This can be useful if you want manual control.
  (auto-package-update-prompt-before-update t)

  :config
  ;; Run package updates automatically at startup, but only if the configured
  ;; interval has elapsed.
  (auto-package-update-maybe)

  ;; Schedule a background update attempt daily at 10:00 AM.
  ;; This uses Emacs' internal timer system. If Emacs is running at that time,
  ;; the update will be triggered. Otherwise, the update is skipped for that
  ;; day. Note that this scheduled update is independent of
  ;; `auto-package-update-maybe` and can be used as a complementary or
  ;; alternative mechanism.
  (auto-package-update-at-time "10:00"))


(provide 'bakin-auto-package-update)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:

;;; bakin-auto-package-update.el ends here
