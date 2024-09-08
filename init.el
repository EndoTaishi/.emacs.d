;;; init.el --- My init.el

;; Author: Taishi Endo

;;; Commentary:
;;; Code

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
  :ensure t
  :bind (("M-=" . transient-dwim-dispatch)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 基本設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PATHの設定を引き継ぐ
(leaf exec-path-from-shell
  :ensure t
  :require t
  :defun (exec-path-from-shell-initialize)
  :config (exec-path-from-shell-initialize))

;; 起動時の画面を非表示
(setq inhibit-startup-message t)

;; 対応する括弧をハイライト
(setq show-paren-delay 0)
(show-paren-mode t)

;; 括弧のハイライトの設定
(setq show-paren-style 'parenthesis)
(set-face-attribute 'show-paren-match nil
      :background "gray"
      :underline 'unspecified);

;; 対応する括弧を自動挿入
(electric-pair-mode 1)

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
     (:background "#AAAAAA"))
    (t
     ()))
  "*Face used by hl-line.")
(global-hl-line-mode t)

;; バックアップファイルの保存先の変更
(setq backup-directory-alist
  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
        backup-directory-alist))
(setq auto-save-file-name-transforms
      `((".*", (expand-file-name "~/.emacs.d/backup/") t)))

;; 現在位置の列数を表示
(column-number-mode t)

;; 左側に行番号表示
(global-display-line-numbers-mode 1)

;; 起動時画面フルサイズ
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; "yes or no"の選択を"y or n"にする
(fset 'yes-or-no-p 'y-or-n-p)

;; 閉じる前に確認
(setq confirm-kill-emacs 'y-or-n-p)

;; 警告音無効
(setq ring-bell-function 'ignore)

(add-hook 'text-mode-hook 'turn-on-auto-fill)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインディング
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key global-map (kbd "C-t") 'other-window) ; ウィンドウ切り替え
(define-key global-map (kbd "C-x f") 'find-file) ; C-x C-f と同等
(define-key global-map (kbd "C-h") 'backward-delete-char)

;; 単体行コメントアウト用コマンド
(defun comment-out-current-line ()
  "Toggle comment out using `comment-dwim`."
  (interactive)
  (move-beginning-of-line 1)
  (set-mark-command nil)
  (move-end-of-line 1)
  (comment-dwim nil))
(global-set-key (kbd "C-;") 'comment-out-current-line)

;; 選択中の入力は、regionを削除して挿入する
(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ヴィジュアルの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; タブを可視化
(leaf whitespace
  :ensure t
  :custom
  ((whitespace-style . '(face
                         trailing
                         tabs
                         ;; spaces
                         ;; empty
                         space-mark
                         tab-mark))
   (whitespace-display-mappings . '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]))))
  :config
  (global-whitespace-mode t))

;; デフォルトのインデント
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

(leaf doom-themes
  :ensure t
  :custom ((doom-themes-enable-italic . nil)
           (doom-themes-enable-bold . t))
  :config
  (load-theme 'doom-winter-is-coming-dark-blue t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

;; (leaf zenburn-theme
  ;; :ensure t
  ;; :config (load-theme 'zenburn t))

;; (leaf modus-themes
  ;; :ensure t
  ;; :bind ("<f5>" . modus-themes-toggle)
  ;; :init
  ;; (load-theme 'modus-vivendi-deuteranopia :no-confirm)
  ;; :config
  ;; )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラミング言語一般
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(leaf highlight-indent-guides
  :ensure t
  :blackout t
  :hook (((prog-mode-hook comint-mode-hook) . highlight-indent-guides-mode))
  :custom (
           (highlight-indent-guides-method . 'character)
           (highlight-indent-guides-auto-enabled . t)
           (highlight-indent-guides-responsive . t)
           (highlight-indent-guides-character . ?|)))

(leaf rainbow-delimiters
  :ensure t
  :hook (((prog-mode-hook comint-mode-hook) . rainbow-delimiters-mode)))

(leaf mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; prog-modeでcopilotを有効にする
(add-hook 'prog-mode-hook 'copilot-mode)

(add-to-list 'auto-mode-alist '(("\\.ts" . typescript-ts-mode)
                                ("\\.tsx" . typescript-ts-mode)
                                ("\\.js" . js-ts-mode)
                                ("\\.jsx" . typescript-ts-mode)
                                ("\\.py" . python-ts-mode)))

(add-hook 'python-ts-mode #'python-ts-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; その他
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
(leaf magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; flymake
(leaf flymake
  :doc "A universal on-the-fly syntax checker"
  :bind ((prog-mode-map
          ("M-n" . flymake-goto-next-error)
          ("M-p" . flymake-goto-prev-error))))

;; undo-tree
(leaf undo-tree
  :ensure t
  :leaf-defer nil
  :bind (("M-/" . undo-tree-redo))
  :custom ((global-undo-tree-mode . t)
           (undo-tree-auto-save-history . nil)))

;; auto-complete
(leaf auto-complete
  :ensure t
  :leaf-defer nil
  :config
  (ac-config-default)
  :custom ((ac-use-menu-map . t)
           (ac-ignore-case . nil))
  :bind (:ac-mode-map
         ; ("M-TAB" . auto-complete))
         ("M-t" . auto-complete)))

;; smart-mode-line
(leaf smart-mode-line
  :ensure t
  :custom ((sml/no-confirm-load-theme . t)
           (sml/theme . 'dark)
           (sml/shorten-directory . -1))
  :config
  (sml/setup))

;; multi-term
(leaf multi-term
  :ensure t
  :custom `((multi-term-program . ,(getenv "SHELL")))
  :preface
  (defun open-shell-sub (new)
   (split-window-below)
   (enlarge-window 5)
   (other-window 1)
   (let ((term) (res))
     (if (or new (null (setq term (dolist (buf (buffer-list) res)
                                    (if (string-match "*terminal<[0-9]+>*" (buffer-name buf))
                                        (setq res buf))))))
         (multi-term)
       (switch-to-buffer term))))
  (defun open-shell ()
    (interactive)
  (defun to-shell ()
    (interactive)
    (open-shell-sub nil))
  :bind (("C-^"   . to-shell)
         ("C-M-^" . open-shell)
         (:term-raw-map
          ("C-t" . other-window)))))

;; ivy
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf copilot
  :el-get "copilot-emacs/copilot"
  :require t
  :load-path "~/.emacs.d/el-get/copilot"
  :config
  (leaf dash
    :ensure t)
  (leaf s
    :ensure t)
  (leaf editorconfig
    :ensure t)
  (leaf f
    :ensure t)
  (setq copilot-executable-node "/opt/homebrew/opt/node@18/bin/node")
  ; tabで補完
  (defun copilot-tab ()
    (interactive)
    (or (copilot-accept-completion)
        (indent-for-tab-command)))
  (with-eval-after-load 'copilot
   (define-key copilot-mode-map (kbd "TAB") 'copilot-tab))
          )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(editorconfig dash s f ivy-prescient prescient counsel swiper ivy multi-term smart-mode-line auto-complete undo-tree zenburn-theme whitespace transient-dwim leaf-convert leaf-tree blackout el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)

;; End:

;;; init.el ends here
