;;; pre-early-init.el --- Runs _before_ minimal-emacs.d `early-init.el` -*- no-byte-compile: t; lexical-binding: t; -*-

;;; helps with debugging these init files
(setq debug-on-error t)

;;; display emacs startup duration
(defun display-startup-time ()
  "Display the startup time and number of garbage collections."
  (message "Emacs init loaded in %.2f seconds (Full emacs-startup: %.2fs) with %d garbage collections."
           (float-time (time-subtract after-init-time before-init-time))
           (time-to-seconds (time-since before-init-time))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time 100)

;; establish some optional UI features
(setq minimal-emacs-ui-features '(context-menu menu-bar tooltips))

;; Reducing clutter in ~/.emacs.d by redirecting files to ~/.emacs.d/var/
;; Still loads minimal emacs configs `{pre,post}{-early}init.el` from ~/.minimal-emacs.d
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

;; don't even bother looking for `site-start.el` or `default.el`
(setq site-run-file nil)
(setq inhibit-default-init t)

;; Configure the native lisp compiler (see https://www.jamescherti.com/compiling-emacs/ under optimization,
;; and https://www.gnu.org/software/emacs/manual/html_node/elisp/Native_002dCompilation-Variables.html
;; and https://github.com/ilhet/emacs_config)

(setq my-cpu-architecture "alderlake" ; as computed by `gcc -march=native -Q --help=target | grep march`
      compilation-safety 1
      native-comp-async-jobs-number 2
      native-comp-async-query-on-exit t
      native-comp-async-report-warnings-errors t
      native-comp-debug 0
      native-comp-enable-subr-trampolines t
      native-comp-jit-compilation t
      native-comp-jit-compilation-deny-list `( "(pre-|post-)?(early-)?init\\.el" "bakin-init-my-packages\\.el" )
      native-comp-speed 2
      native-comp-verbose 0
      native-comp-compiler-options `(
  "-O2" "-g0"
  ,(format "-mtune=%s" my-cpu-architecture)
  ,(format "-march=%s" my-cpu-architecture)
  "-fno-omit-frame-pointer"
  "-fno-finite-math-only"))
