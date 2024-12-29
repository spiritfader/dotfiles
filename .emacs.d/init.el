;; initialize melpa repo
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
        '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; initialize use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; initialize theme
(use-package spacemacs-theme
  :ensure t
  :config
  (load-theme 'spacemacs-dark t))

;(use-package vscode-dark-plus-theme
;  :ensure t
;  :config
;  (load-theme 'vscode-dark-plus t))

;; set font
(set-face-attribute 'default nil :family "DroidSansM Nerd Font Mono Regular" :height 130)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; set background transparency
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; disable menu and toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; add duplicate line feature
(defun duplicate-line ()
  (interactive)
  (save-mark-and-excursion
	(beginning-of-line)
    (insert (thing-at-point 'line t))))
(global-set-key (kbd "C-M-d") 'duplicate-line)

;; move current line down or up (vscode functionality)
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
	(save-excursion
      (forward-line)
      (transpose-lines 1))
    (move-to-column col)))
	(forward-line)

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
	(save-excursion
      (forward-line)
      (transpose-lines -1))
    (forward-line -1)
    (move-to-column col)))

(global-set-key (kbd "C-S-k") 'move-line-up)
(global-set-key (kbd "C-S-j") 'move-line-down)

(show-paren-mode 1)

;; enable traditional copy/paste functionality
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(setq inhibit-startup-message t)

;; disable auto backup and auto-save
(setq make-backup-files nil)
(setq auto-save-default nil)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil)

(global-prettify-symbols-mode t)

;(defun split-and-follow-horizontally ()
;  (interactive)
;  (split-window-below)
;  (balance-windows)
;  (other-window 1))
;(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

;(defun split-and-follow-vertically ()
;  (interactive)
;  (split-window-right)
;  (balance-windows)
;  (other-window 1))
;(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)

(global-hl-line-mode t)


;; use-package section


(setq use-package-always-defer t)

(use-package org
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            #'(lambda ()
               (visual-line-mode 1))))

(use-package org-indent
  :diminish org-indent-mode)

(use-package htmlize
  :ensure t)

(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package vterm
  :ensure t)

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package diminish
  :ensure t)

(use-package spaceline
  :ensure t)

(use-package powerline
  :ensure t
  :init
  (spaceline-emacs-theme)
  :hook
  ('after-init-hook) . 'powerline-reset)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))

(use-package swiper
  :ensure t
  :bind ("C-s" . 'swiper))

(use-package beacon
  :ensure t
  :diminish beacon-mode
  :init
  (beacon-mode 1))

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

(use-package async
  :ensure t
  :init
  (dired-async-mode 1))

(use-package page-break-lines
  :ensure t
  :diminish (page-break-lines-mode visual-line-mode))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)

(use-package magit
  :ensure t)

(use-package eldoc
  :ensure t
  :diminish eldoc-mode)

(use-package abbrev
  :diminish abbrev-mode)

(use-package multiple-cursors
  :ensure t
  :bind(("M-S M-S" . mc/edit-lines)
        ("C-»" . mc/mark-next-like-this)
        ("C-«" . mc/mark-previous-like-this)
        ("C-c C-«" . mc/mark-all-like-this)
        ("C-c n" . mc/insert-numbers))
)

(use-package vertico
  :ensure t
  :custom
    (vertico-scroll-margin 0) ;; Different scroll margin
    (vertico-count 20) ;; Show more candidates
    (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
    (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  #'(vertico-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))
;      :bind (:map 'flycheck-mode-map
;                  ("M-n" . flycheck-next-error) ; optional but recommended error navigation
;                  ("M-p" . flycheck-previous-error)))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  :init
  #'(global-corfu-mode))

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map) ;; Alternative keys: M-p, M-+, ...
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
)

(use-package dashboard
  :ensure t
  :defer nil
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  (setq dashboard-startup-banner 'official )
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  ;(setq dashboard-show-shortcuts nil)
  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
)

(use-package nerd-icons
  :ensure t)

;(use-package lsp-mode
;  :commands lsp
;  :hook
;  (sh-mode . lsp) ;; bash
;  (python-mode . lsp) ;; python
;  (lsp-enable-which-key-integration t)
;)

;(defun efs/lsp-mode-setup ()
;  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;  (lsp-headerline-breadcrumb-mode))
;
;  :hook (lsp-mode . efs/lsp-mode-setup)

;(use-package lsp-ui
;  :hook (lsp-mode . lsp-ui-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(spacemacs-theme which-key vterm vscode-dark-plus-theme vertico undo-tree treemacs-projectile treemacs-magit swiper spaceline page-break-lines nerd-icons multiple-cursors marginalia jinx htmlize flycheck embark-consult diminish dashboard corfu cape beacon auto-package-update async)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
