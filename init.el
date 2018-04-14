;; Don't run GC during startup
(setq gc-cons-threshold 400000000)

;; Speed up initial load by ignoring default regex checks
;; NOTE: this may give some benign errors!
(let ((file-name-handler-alist nil))

  ;; Don't clutter my filesystem
  (setq backup-directory-alist
	`(("." . ,(concat user-emacs-directory "backups"))))

  ;; Move customization settings to their own file
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file)

  ;; Turn off mouse interface early in startup to avoid momentary display
  (when window-system
    (menu-bar-mode -1)
    (tool-bar-mode -1)
					;  (scroll-bar-mode -1)
					;  (tooltip-mode -1)
    )  

  ;; For MELPA
  (require 'package)
  (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		      (not (gnutls-available-p))))
	 (proto (if no-ssl "http" "https")))
    ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
    (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
    ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
    (when (< emacs-major-version 24)
      ;; For important compatibility libraries like cl-lib
      (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
  (package-initialize)

;;; Bootstrap use-package
  ;; Install use-package if it's not already installed.
  ;; use-package is used to configure the rest of the packages.
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  ;; From use-package README
  (eval-when-compile
    (require 'use-package))
  (use-package diminish :ensure t)
  (require 'diminish)                ;; if you use :diminish
  (require 'bind-key)                ;; if you use any :bind variant

  ;; Set theme
  (use-package zenburn-theme
    :ensure t
    :init
    (progn
      (load-theme 'zenburn t)
      (set-cursor-color "red")))

;;; Load the config
  (org-babel-load-file (concat user-emacs-directory "config.org"))

  )

;; Set GC back to modern level
(setq gc-cons-threshold 1000000)
