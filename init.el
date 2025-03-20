;; init.el --- My init.el
; Author: Taishi Endo

;;; Commentary:
;;; Code

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;;; Set up the package manager

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 基本設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PATHの設定を引き継ぐ
(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))

;; 起動時の画面を非表示
(setq inhibit-startup-message t)

;; 括弧のハイライトの設定
;; (setq show-paren-style 'parenthesis)
;; (set-face-attribute 'show-paren-match nil
      ;; :background "gray"
      ;; :underline 'unspecified)

;; 選択範囲をハイライト
(set-face-attribute 'region nil
                    :background "gray"
                    :foreground "black")

;; 現在行をハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "#AAAAAA")))
  "*Face used by hl-line.")
(global-hl-line-mode t)

;; バックアップファイルの保存先の変更
(setq backup-directory-alist
  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
        backup-directory-alist))
(setq auto-save-file-name-transforms
      `((".*", (expand-file-name "~/.emacs.d/backup/") t)))

;; "yes or no"の選択を"y or n"にする
(fset 'yes-or-no-p 'y-or-n-p)

;; 閉じる前に確認
(setq confirm-kill-emacs 'y-or-n-p)

;; 警告音無効
(setq ring-bell-function 'ignore)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(menu-bar-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(add-hook 'org-mode-hook (lambda () (auto-fill-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインディング
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key global-map (kbd "C-t") 'other-window) ; ウィンドウ切り替え
(define-key global-map (kbd "C-x f") 'find-file) ; C-x C-f と同等
(define-key global-map (kbd "C-h") 'backward-delete-char) ; C-h でバックスペース
(define-key global-map (kbd "C-x ?") 'help-command) ; C-x ? でヘルプを表示


;; 単体行コメントアウト用コマンド
(defun comment-out-current-line ()
  "Toggle comment out using `comment-dwim`."
  (interactive)
  (move-beginning-of-line 1)
  (set-mark-command nil)
  (move-end-of-line 1)
  (comment-dwim nil))
(define-key global-map (kbd "C-;") 'comment-out-current-line)

;; 選択中の入力は、regionを削除して挿入する
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ヴィジュアルの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Zen mode
(use-package centered-window
  :ensure t
  :hook (after-init . centered-window-mode))

;; シンタックスハイライト
(use-package treesit-auto
    :ensure t
    :custom
    (treesit-auto-install 'prompt)
    :config
    (treesit-auto-add-to-auto-mode-alist 'all)
    (global-treesit-auto-mode))

;; デフォルトのインデント
(setq tab-width 4)
;; (setq-default indent-tabs-mode nil)

;; カッコの補完
(use-package smartparens
  :ensure t
  :delight
  :hook (after-init . smartparens-global-mode)
  :custom (electric-pair-mode 1)
  :config
  (require 'smartparens-config))

;; (leaf doom-themes
  ;; :ensure t
  ;; :config
  ;; (load-theme 'doom-winter-is-coming-dark-blue t)
  ;; (doom-themes-neotree-config)
  ;; (doom-themes-org-config)
  ;; (custom-set-faces
   ;; '(font-lock-comment-face ((t (:foreground "#999999")))))
  ;; :custom ((doom-themes-enable-italic . nil)
;; (doom-themes-enable-bold . t)))

;; (use-package doom-themes
  ;; :ensure t
  ;; :custom
  ;; (doom-themes-enable-italic . nil)
  ;; (doom-themes-enable-bold . nil)
  ;; :custom-face
  ;; (doom-modeline-bar ((t (:background "#000000"))))
  ;; (default ((t (:background "#282822"))))
  ;; :config
  ;; (load-theme 'doom-dracula t)
;; (load-theme 'doom-winter-is-coming-dark-blue t))

(use-package doom-themes
  :ensure t
  :custom
  (setq doom-themes-enable-italic nil)
  (setq doom-themes-enable-bold nil)
  :config
  ;; Load catppuccin theme with specific flavor
  (use-package catppuccin-theme
    :ensure t
    :config
    (setq catppuccin-flavor 'frappe)) ;; Set the flavor before loading
  (load-theme 'catppuccin t))


;; Nerd icons
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package pretty-speedbar
  :ensure t
  :config
  (setq pretty-speedbar-font "Font Awesome 6 Free Solid"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org captureを呼び出す
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-hide-leading-stars t)

(use-package org
  :ensure t
  :custom
  (org-capture-templates
   '(("t" "Task" entry
      (file+headline "/Users/endotaishi/Documents/tasks.org" "INBOX")
      "* TODO %?\n  %U\n  %i\n  %a" :prepend t)
     ("n" "Note" entry
      (file+headline "/Users/endotaishi/Documents/notes.org" "Notes")
      "* %?\n  Entered on %U\n  %i\n  %a" :prepend t)))
  (org-agenda-files '("/Users/endotaishi/Documents/tasks.org"
                      "/Users/endotaishi/Documents/notes.org"))
  (org-tag-alist '(("mantra" . ?m) ("life" . ?l) ("research" . ?r))))

(require 'org-habit)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "SUSPENDED(s)" "CANCELLED(c)")))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラミング言語一般
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package highlight-indent-guides
  :ensure t
  :delight
  :hook ((prog-mode-hook . highlight-indent-guides-mode))
  :config
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-character ?\|))


(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode-hook . rainbow-delimiters-mode)))

(use-package mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; (add-to-list 'auto-mode-alist '("\\.py" . python-ts-mode))

;; (add-hook 'python-ts-mode #'python-ts-mode)

(use-package markdown-mode
  :ensure t
  :custom
  (markdown-fontify-code-blocks-natively t)
  ;; (setopt markdown-header-scaling t)
  (markdown-indent-on-enter 'indent-and-new-item)
  :config
  (define-key markdown-mode-map (kbd "<S-tab>") #'markdown-shifttab))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; その他
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; undo-tree
(use-package undo-tree
  :ensure t
  :bind (("M-/" . undo-tree-redo))
  :hook (after-init . global-undo-tree-mode)
  :config
  (setq undo-tree-auto-save-history nil))

;; smart-mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'light)
  (setq sml/shorten-directory -1)  
(sml/setup))

;; ivy
(use-package ivy
  :ensure t
  :hook (after-init . ivy-mode))

(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))

(use-package counsel
   :ensure t
   :blackout t
   :bind (("C-S-s" . counsel-imenu)
          ("C-x C-r" . counsel-recentf))
   :custom `((counsel-yank-pop-separator . "\n----------\n")
             (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
   :hook (after-init . counsel-mode))

(use-package prescient
  :ensure t
  :custom
  (setq prescient-aggressive-file-save t)
  :hook (global-minor-mode . prescient-persist-mode))

(use-package ivy-prescient
  :ensure t
  :custom
  (setq ivy-prescient-retain-classic-highlighting t)
  :hook (global-minor-mode . ivy-prescient-mode))

;;; Configure the minibuffer and completions

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;;; The file manager (Dired)

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

(provide 'init)

;; End:

;;; init.el ends here
