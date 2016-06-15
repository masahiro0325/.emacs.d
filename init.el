;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 基本設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
     (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
         (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))

;;; ディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path ".")

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" .  "http://stable.melpa.org/packages/") t)
(package-initialize)


;;; 曖昧文字幅の対策

(defun set-east-asian-ambiguous-width (width)
  (cond ((= emacs-major-version 22) (set-east-asian-ambiguous-width-22 width))
        ((> emacs-major-version 22) (set-east-asian-ambiguous-width-23 width))))

(defun set-east-asian-ambiguous-width-23 (width)
  (while (char-table-parent char-width-table)
         (setq char-width-table (char-table-parent char-width-table)))
  (let ((table (make-char-table nil)))
    (dolist (range
              '(#x00A1 #x00A4 (#x00A7 . #x00A8) #x00AA (#x00AD . #x00AE)
                (#x00B0 . #x00B4) (#x00B6 . #x00BA) (#x00BC . #x00BF)
                #x00C6 #x00D0 (#x00D7 . #x00D8) (#x00DE . #x00E1) #x00E6
                (#x00E8 . #x00EA) (#x00EC . #x00ED) #x00F0
                (#x00F2 . #x00F3) (#x00F7 . #x00FA) #x00FC #x00FE
                #x0101 #x0111 #x0113 #x011B (#x0126 . #x0127) #x012B
                (#x0131 . #x0133) #x0138 (#x013F . #x0142) #x0144
                (#x0148 . #x014B) #x014D (#x0152 . #x0153)
                (#x0166 . #x0167) #x016B #x01CE #x01D0 #x01D2 #x01D4
                #x01D6 #x01D8 #x01DA #x01DC #x0251 #x0261 #x02C4 #x02C7
                (#x02C9 . #x02CB) #x02CD #x02D0 (#x02D8 . #x02DB) #x02DD
                #x02DF (#x0300 . #x036F) (#x0391 . #x03A9)
                (#x03B1 . #x03C1) (#x03C3 . #x03C9) #x0401
                (#x0410 . #x044F) #x0451 #x2010 (#x2013 . #x2016)
                (#x2018 . #x2019) (#x201C . #x201D) (#x2020 . #x2022)
                (#x2024 . #x2027) #x2030 (#x2032 . #x2033) #x2035 #x203B
                #x203E #x2074 #x207F (#x2081 . #x2084) #x20AC #x2103
                #x2105 #x2109 #x2113 #x2116 (#x2121 . #x2122) #x2126
                #x212B (#x2153 . #x2154) (#x215B . #x215E)
                (#x2160 . #x216B) (#x2170 . #x2179) (#x2190 . #x2199)
                (#x21B8 . #x21B9) #x21D2 #x21D4 #x21E7 #x2200
                (#x2202 . #x2203) (#x2207 . #x2208) #x220B #x220F #x2211
                #x2215 #x221A (#x221D . #x2220) #x2223 #x2225
                (#x2227 . #x222C) #x222E (#x2234 . #x2237)
                (#x223C . #x223D) #x2248 #x224C #x2252 (#x2260 . #x2261)
                (#x2264 . #x2267) (#x226A . #x226B) (#x226E . #x226F)
                (#x2282 . #x2283) (#x2286 . #x2287) #x2295 #x2299 #x22A5
                #x22BF #x2312 (#x2460 . #x24E9) (#x24EB . #x254B)
                (#x2550 . #x2573) (#x2580 . #x258F) (#x2592 . #x2595)
                (#x25A0 . #x25A1) (#x25A3 . #x25A9) (#x25B2 . #x25B3)
                (#x25B6 . #x25B7) (#x25BC . #x25BD) (#x25C0 . #x25C1)
                (#x25C6 . #x25C8) #x25CB (#x25CE . #x25D1)
                (#x25E2 . #x25E5) #x25EF (#x2605 . #x2606) #x2609
                (#x260E . #x260F) (#x2614 . #x2615) #x261C #x261E #x2640
                #x2642 (#x2660 . #x2661) (#x2663 . #x2665)
                (#x2667 . #x266A) (#x266C . #x266D) #x266F #x273D
                (#x2776 . #x277F) (#xE000 . #xF8FF) (#xFE00 . #xFE0F)
                #xFFFD
                ))
      (set-char-table-range table range width))
    (optimize-char-table table)
    (set-char-table-parent table char-width-table)
    (setq char-width-table table)))

(set-east-asian-ambiguous-width 2)


;; GCを減らして軽くする
(setq gc-cons-threshold (* 128 1024 1024))

;; スクロールバーを非表示に
(scroll-bar-mode -1)

;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)

;; 改行コードを表示する
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; 複数ウィンドウを禁止する
(setq ns-pop-up-frames nil)

;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.85 0.85)))

;; メニューバーを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;; 列数を表示する
(column-number-mode t)

;; 行数を表示する
(global-linum-mode t)

;; カーソルの点滅をやめる
(blink-cursor-mode 0)

;; カーソル行をハイライトする
(global-hl-line-mode t)

;; 対応する括弧を光らせる
(show-paren-mode 1)

;; ウィンドウ内に収まらないときだけ、カッコ内も光らせる
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")

;; スペース、タブなどを可視化する
;;(global-whitespace-mode 1)

;; スクロールは１行ごとに
(setq scroll-conservatively 1)

;; C-kで行全体を削除する
(setq kill-whole-line t)

;;; dired設定
(require 'dired-x)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; beep音を消す
(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;;; デバッグモードでの起動
(require 'cl)


;; 質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)


;;; キー操作
;; C-mにnewline-and-indentを割り当てる。
(global-set-key (kbd "C-m") 'newline-and-indent)

;;; 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; ファイルサイズを表示
(size-indication-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-install
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-install)
(auto-install-compatibility-setup)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; migemo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

;; Set your installed path
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 候補を作って描写するまでのタイムラグを設定する（デフォルトは 0.01）
(setq helm-idle-delay 0.2)

(require 'helm-config)
(require 'helm-ag)
(require 'helm-descbinds)

(helm-mode 1)
(helm-migemo-mode 1)

  (define-key global-map (kbd "M-x")     'helm-M-x)
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)
  (define-key global-map (kbd "M-y")     'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i")   'helm-imenu)
  (define-key global-map (kbd "C-x C-b")   'helm-buffers-list)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
(global-set-key (kbd "M-z") 'helm-resume) ;レジューム（1つ前のhelmに戻る）のはよく使うため、cmd+Zで使えるようにした

(require 'helm-swoop)
;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;;; C-M-:に割り当て
(global-set-key (kbd "C-M-:") 'helm-swoop-nomigemo)

;;; ace-isearch
(global-ace-isearch-mode 1)

;;; [2015-03-23 Mon]C-u C-s / C-u C-u C-s
(defun isearch-forward-or-helm-swoop (use-helm-swoop)
  (interactive "p")
  (let (current-prefix-arg
        (helm-swoop-pre-input-function 'ignore))
    (call-interactively
     (case use-helm-swoop
       (1 'isearch-forward)
       (4 'helm-swoop)
       (16 'helm-swoop-nomigemo)))))
(global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)

;; ------------------------------------------------------------------------
;; @ sequential-command
;; 同じコマンドを連続実行した時の振る舞いを変更する
;; C-a : 行頭→文頭→元の位置→行頭…とトグル
;; C-e : 行末→文末→元の位置→行末…とトグル
;; M-u : 直前の単語を順次大文字にする
;; M-l : 直前の単語を順次小文字にする
;; M-c : 直前の単語を順次キャメライズ

(require 'sequential-command-config)
(sequential-command-setup-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 時刻の表示
(require 'time)
(setq display-time-24hr-format t)
(setq display-time-string-forms '(24-hours ":" minutes))
(display-time-mode t)

;; ------------------------------------------------------------------------
;; @ cursor

;; カーソル点滅表示(GUIのみ効く)
(blink-cursor-mode 1)

;; スクロール時のカーソル位置の維持
(setq scroll-preserve-screen-position t)

;; スクロール行数（一行ごとのスクロール）
(setq vertical-centering-font-regexp ".*")
(setq scroll-conservatively 35)
(setq scroll-margin 0)
(setq scroll-step 1)

;; 画面スクロール時の重複行数
(setq next-screen-context-lines 1)

;; ------------------------------------------------------------------------
;; @ default setting

;; ⌘キーがメタキーとして解釈される
;; http://qiita.com/hayamiz/items/0f0b7a012ec730351678
;;(when (eq system-type 'darwin)
;;    (setq ns-command-modifier (quote meta)))

;; 起動メッセージの非表示
(setq inhibit-startup-message t)

;; スタートアップ時のエコー領域メッセージの非表示
(setq inhibit-startup-echo-area-message -1)

;;BackSpaceを有効に(isearch時にも効くように)
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; ビープ音を消す
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; 現在行をセンタリングして再描画 : C-lをhelmで潰したためC-M-lに変更
;; （多用するためC-x C-lは破棄）
(global-set-key (kbd "C-M-l") 'recenter-top-bottom)

;; C-k １回で行全体を削除する
(setq kill-whole-line t)

;;キルリングカスタマイズ（  "ポイントが空行ならキルリングに追加しない"）
(defun my-kill-or-delete-line ()
    "ポイントが空行ならキルリングに追加しない"
      (interactive)
        (if (and (bolp) (eolp)) ;お気に入り
                  (my-delete-line)
              (my-kill-line)))

;;C-h（BackSpace）でリージョンを一括削除
(delete-selection-mode 1)

;;ツールバーを非表示に
(tool-bar-mode nil)

;;*scratch* で最初に書かれる message を消す
(setq initial-scratch-message "")

;; システムへ修飾キーを渡さない
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; オートセーブOff
(setq auto-save-default nil)

;; バックアップファイルを作らない
(setq backup-inhibited t)

;; 変更ファイルのバックアップ
(setq make-backup-files nil)

;; 変更ファイルの番号つきバックアップ
(setq version-control nil)

;; 編集中ファイルのバックアップ
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; ロックファイルを生成しない
(setq create-lockfiles nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; key-combo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'key-combo)
(key-combo-load-default)                ;おまかせ設定

(key-combo-define-global (kbd "{") '("{`!!'}"))
(key-combo-define-global (kbd "{}") "{}")
(key-combo-define-global (kbd "(") '("(`!!')"))
(key-combo-define-global (kbd "()") "()")
(key-combo-define-global (kbd "[") '("[`!!']"))
(key-combo-define-global (kbd "[]") "[]")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete)
(require 'auto-complete-config)    ;;  必須ではないですが一応
(global-auto-complete-mode t)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; ; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)
(setq ac-auto-start 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(package-install 'flycheck)
(global-flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; web-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" .  web-mode))
(setq web-mode-engines-alist
      '(("php"   .  "\\.phtml\\'")
        ("blade" .  "\\.blade\\.")))


(setq web-mode-ac-sources-alist
      '(("css" .  (ac-source-css-property))
        ("html" .  (ac-source-words-in-buffer ac-source-abbrev))))
(setq web-mode-ac-sources-alist
      '(("php" .  (ac-source-yasnippet ac-source-php-auto-yasnippets))
        ("html" .  (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
        ("css" .  (ac-source-css-property ac-source-emmet-css-snippets))))

(add-hook 'web-mode-before-auto-complete-hooks
          '(lambda ()
             (let ((web-mode-cur-language
                    (web-mode-language-at-pos)))
               (if (string=  web-mode-cur-language "php")
                   (yas-activate-extra-mode 'php-mode)
                 (yas-deactivate-extra-mode 'php-mode))
               (if (string=  web-mode-cur-language "css")
                   (setq emmet-use-css-transform t)
                 (setq emmet-use-css-transform nil)))))
