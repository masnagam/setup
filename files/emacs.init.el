;;; init.el --- init.el

;;; Commentary:

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Basic Settings

;; Don't delete the following line.  It is intended to prevent to be
;;  added the following line automatically by package.el.
;(package-initialize)

;; For avoiding to write custom variables in init.el.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Load proxy settings if it exists.
(load (expand-file-name "init-proxy" user-emacs-directory) t)

(setq inhibit-splash-screen t)
(setq inhibit-startup-screen t)   ;; equivalent to the above expression
(setq inhibit-startup-message t)  ;; equivalent to the above expression
(setq initial-scratch-message "")

;; Inhibit to load default.el at startup.
(setq inhibit-default-init t)

;; language
(set-language-environment "Japanese")

;; encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; enter the debugger each time an error is found
;(setq debug-on-error t)

;; enable font-lock
(global-font-lock-mode t)

;; show file name ("%f") if exists, otherwise show buffer name ("%b")
(setq frame-title-format '(buffer-file-name "%f" "%b"))

;; hide bars
(menu-bar-mode -1)
(if window-system (tool-bar-mode 0))

;; maximize frame
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; default font
(add-to-list 'default-frame-alist '(font . "Sarasa Mono J-14"))

;; resize mini buffer window
(setq resize-mini-windows t)

;; cursor
;(set-cursor-type 'box)
;(set-cursor-type 'hairline-caret)

;; clipboard
(cond (window-system (setq select-enable-clipboard t)))

;; line and column number
(global-display-line-numbers-mode t)
(column-number-mode t)

;; inhibit to create new lines at the end of line
(setq next-line-add-newlines nil)

;; scroll-step
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)

;; always indent using spaces, never tabs
(setq-default indent-tabs-mode nil
              tab-width 4)

;; visual feedback
(setq visible-bell t)
(global-hl-line-mode t)
(transient-mark-mode t)
(show-paren-mode t)

;; make sure that text files end in a newline
(setq require-final-newline t)

;; just never create backup files at all
(setq make-backup-files nil)

;; change from yes/no to y/n to reduce key typing
(fset 'yes-or-no-p 'y-or-n-p)

;; case insensitive completion
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; common keymaps
(define-key global-map (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "C-;") 'yank-pop)
(define-key global-map (kbd "C-x j") 'browse-url-at-point)
(define-key global-map (kbd "C-x C-h") 'help-command)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Package Manager Settings

;; See https://github.com/seagle0128/.emacs.d/issues/98
(custom-set-variables
 '(gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(require 'package)

(defvar my-package-contents-refreshed nil)

(defun my-refresh-package-contents ()
  "Download the latest packages in archives once."
  (unless my-package-contents-refreshed
    (package-refresh-contents)
    (setq my-package-contents-refreshed t)))

(unless package--initialized (package-initialize t))

(advice-add 'package-install
            :before (lambda (&rest args)
                      (my-refresh-package-contents)))

;; Priority: melpa(10) > melpa-stable(5) > gnu(0)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archive-priorities
             '("melpa" . 10) t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archive-priorities
             '("melpa-stable" . 5) t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Additional Packages
;;;
;;; use-package is used for managing packages:
;;;
;;; :init
;;;   executes code before a package is loaded
;;;
;;; :config
;;;   executes code after a package is loaded
;;;

(defmacro safe-diminish (file mode &optional new-name)
  "Diminish the minor MODE defined in FILE."
  `(with-eval-after-load ,file
     (diminish ,mode ,new-name)))

(use-package diminish
  :straight t
  :ensure t
  :config
  (safe-diminish "abbrev" 'abbrev-mode)
  (safe-diminish "flyspell" 'flyspell-mode)
  (safe-diminish "eldoc" 'eldoc-mode)
  )

(use-package auto-package-update
  :straight t
  :ensure t
  :config
  (auto-package-update-maybe)
  :custom
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  )

(use-package exec-path-from-shell
  :straight t
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  )

(use-package anzu
  :straight t
  :ensure t
  :diminish anzu-mode
  :config
  (global-anzu-mode t)
  )

(use-package migemo
  :straight t
  :ensure t
  :if (executable-find "cmigemo")
  :config
  (load-library "migemo")
  (migemo-init)
  :custom
  (migemo-command "cmigemo")
  (migemo-options '("-q" "--emacs"))
  (migemo-user-dictionary nil)
  (migemo-regex-dictionary nil)
  (migemo-coding-system 'utf-8)
  ;; define migemo-dictionary in init-local.el
  )

(use-package switch-window
  :straight t
  :ensure t
  :demand
  :bind (("C-x o" . switch-window))
  )

(use-package lsp-mode
  :straight t
  :ensure t
  :commands (lsp lsp-deferred)
  :custom
  (lsp-prefer-flymake nil)
  (lsp-enable-file-watchers t)
  (lsp-enable-on-type-formatting nil)
  (lsp-file-watch-threshold nil)
  (lsp-rust-server 'rust-analyzer)
  :hook ((rust-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (objc-mode . lsp-deferred))
  )

(use-package lsp-ui
  :straight t
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable nil)
  )

(use-package company
  :straight t
  :ensure t
  :diminish company-mode
  :bind (:map company-active-map
              ("M-n" . nil)
              ("M-p" . nil)
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("C-h" . nil)
              ("<tab>" . company-complete-common-or-cycle)
              ("M-d" . company-show-doc-buffer)
         :map prog-mode-map
              ("<tab>" . company-complete))
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  )

;(use-package company-box
;  :hook (company-mode . company-box-mode)
;  )

(use-package company-lsp
  :straight t
  :ensure t
  :commands company-lsp
  :after (lsp-mode company)
  :requires yasnippet
  :config
  (push 'company-lsp company-backends)
  )

(use-package yasnippet
  :straight t
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1)
  )

(use-package flycheck
  :straight t
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  (define-key flycheck-mode-map flycheck-keymap-prefix nil)
  (define-key flycheck-mode-map flycheck-keymap-prefix
    flycheck-command-map)
  :custom
  (flycheck-keymap-prefix (kbd "C-c f"))
  )

(use-package flycheck-pos-tip
  :straight t
  :disabled t
  :ensure t
  :after flycheck
  :init
  (flycheck-pos-tip-mode)
  )

(use-package flycheck-tip
  :straight t
  :ensure t
  :bind (:map flycheck-mode-map
              ("C-c f n" . flycheck-tip-cycle)
              ("C-c f p" . flycheck-tip-cycle-reverse))
  )

(use-package ido
  :straight t
  :ensure t
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  :custom
  (ido-enable-flex-matching t)
  )

(use-package ido-completing-read+
  :straight t
  :ensure t
  :after ido
  :init
  (ido-ubiquitous-mode 1)
  )

(use-package ido-vertical-mode
  :straight t
  :ensure t
  :after ido
  :init
  (ido-vertical-mode 1)
  :custom
  (ido-vertical-define-keys 'C-n-and-C-p-only)
  )

(use-package wgrep
  :straight t
  :ensure t
  )

(use-package rg
  :straight t
  :ensure t
  :requires wgrep
  :config
  (rg-enable-default-bindings (kbd "M-s"))
  )

(use-package cmake-mode
  :straight t
  :ensure t
  :mode ("\\.cmake\\'" "CMakeList.txt\\'")
  )

(use-package meson-mode
  :straight t
  :ensure t
  :mode ("meson.build\\'")
  )

(use-package llvm-mode
  :straight t
  :disabled t
  :ensure t
  :mode "\\.ll\\'"
  )

(use-package c-mode
  :mode "\\.c\\'"
  )

(use-package c++-mode
  :mode ("\\.cc\\'" "\\.hh\\'" "\\.cpp\\'" "\\.hpp\\'")
  )

(use-package dummy-h-mode
  :straight (:host github :repo "syohex/dummy-h-mode-el")
  :commands dummy-h-mode
  :mode "\\.h\\'"
  :custom
  (dummy-h-mode-default-major-mode 'c-mode)
  (dummy-h-mode-search-limit 60000)
  )

(use-package google-c-style
  :straight (:host github :repo "google/styleguide" :branch "gh-pages")
  :ensure t
  :hook (c-mode-common . google-set-c-style)
  )

(use-package ruby-mode
  :mode ("\\.rb\\'" "Rakefile\\'")
  :interpreter "ruby"
  :functions inf-ruby-keys
  :hook (ruby-mode . (lambda () (inf-ruby-keys)))
  )

(use-package js-mode
  :mode "\\.js\\'"
  :custom
  (js-indent-level 2)
  )

(use-package coffee-mode
  :ensure t
  :mode "\\.coffee\\'"
  :config
  (set (make-local-variable 'tab-width) 2)
  (set (make-local-variable 'coffee-tab-width) 2)
  )

(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :custom
  (typescript-indent-level 2)
  )

(use-package graphviz-dot-mode
  :straight t
  :mode "\\.dot\\'"
  )

(use-package web-mode
  :straight t
  :ensure t
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.jst\\'"
         "\\.html\\.njk\\'"
         "\\.html?\\'")
  :custom
  (web-mode-enable-auto-indentation nil)
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-style-padding 2)
  (web-mode-script-padding 2)
  )

(use-package css-mode
  :mode "\\.css\\'"
  )

(use-package scss-mode
  :straight t
  :ensure t
  :mode "\\.scss\\'"
  )

(use-package yaml-mode
  :straight t
  :ensure t
  :mode ("\\.yml\\'" "\\.yaml\\'")
  )

(use-package scala-mode
  :straight t
  :mode ("\\.scala\\'" "\\.sc\\'")
  :custom
  (scala-indent:use-javadoc-style t)
  )

(use-package rust-mode
  :straight t
  :ensure t
  :mode ("\\.rs\\'")
  )

(use-package flycheck-rust
  :straight t
  :ensure t
  :after (flycheck rust-mode)
  :hook (flycheck-mode . flycheck-rust-setup)
  )

(use-package go-mode
  :straight t
  :ensure t
  :mode ("\\.go\\'")
  )

(use-package nim-mode
  :straight t
  :ensure t
  :mode ("\\.nim\\'")
  )

(use-package markdown-mode
  :straight t
  :ensure t
  :mode ("\\.md\\'" "\\.mark\\'" "\\.markdown\\'")
  )

(use-package docker
  :straight t
  :ensure t
  :bind ("C-c d" . docker)
  )

(use-package dockerfile-mode
  :straight t
  :ensure t
  :mode "Dockerfile\\'"
  :config
  (put 'dockerfile-image-name 'safe-local-variable #'stringp)
  )

(use-package plantuml-mode
  :straight t
  :ensure t
  :if (executable-find "plantuml")
  :mode ("\\.puml\\'" "\\.plantuml\\'")
  ;; define plantuml-jar-path in init-local.el
  )

(use-package octave-mode
  :mode "\\.m\\'"
  )

;; shell
(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt)
(setq comint-scroll-show-maximum-output t)

(use-package w3m
  :straight t
  :ensure t
  :custom
  (browse-url-browser-function 'w3m-browse-url)
  (w3m-add-referer nil)
  (w3m-coding-system 'utf-8)
  (w3m-default-coding-system 'utf-8)
  (w3m-file-coding-system 'utf-8)
  (w3m-file-name-coding-system 'utf-8)
  (w3m-input-coding-system 'utf-8)
  (w3m-output-coding-system 'utf-8)
  (w3m-terminal-coding-system 'utf-8)
  )

(use-package magit
  :straight t
  :ensure t
  :pin melpa-stable  ;; unstable magit is often broken..
  :bind (("C-c g c" . magit-checkout)
         ("C-c g d" . magit-diff-popup)
         ("C-c g s" . magit-status)
         ("C-c g l" . magit-log-popup))
  )

(use-package magit-filenotify
  :straight t
  :ensure t
  :requires magit
  :hook (magit-status-mode . magit-filenotify-mode)
  )

(use-package git-gutter
  :straight t
  :ensure t
  :diminish git-gutter-mode
  :init
  (global-git-gutter-mode +1)
  )

;; Use dirname if the same buffer name already exists.
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

(use-package gdb-mi
  :commands gdb
  :config
  (setq gdb-many-windows t)
  (gud-tooltip-mode t)
  ;; Install a function which is called before gud-display-line in
  ;; order to always display source code in gdb-source-window.
  ;;
  ;; gud-display-line uses display-buffer to show source code in some
  ;; window.  That causes that the source code is displayed in a window
  ;; other than gdb-source-window, in most cases, the window which
  ;; displays the GUD buffer.
  ;;
  ;; The function to be installed calls set-window-buffer in order to
  ;; display the source code in gdb-source-window before
  ;; gud-display-line so that the source code may not be displayed any
  ;; other windows.
  (advice-add
   'gud-display-line
   :before (lambda (true-file line)
             (let ((buffer
                    (with-current-buffer gud-comint-buffer
                      (gud-find-file true-file))))
               (when (and gdb-source-window buffer)
                 (set-window-buffer gdb-source-window buffer)))))
  )

(use-package ispell
  :config
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+"))
  :custom
  (ispell-program-name "aspell")
  )

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :custom
  (flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
  )

(use-package whitespace
  :diminish global-whitespace-mode
  :init
  (global-whitespace-mode t)
  :custom
  (whitespace-line-column nil)
  (whitespace-style
   '(face trailing tabs spaces lines-tail empty tab-mark))
  (whitespace-space-regexp
   ;; IDEOGRAPHIC SPACE
   "\\(\u3000+\\)")
  (whitespace-display-mappings
   ;; IDEOGRAPHIC SPACE -> WHITE SQUARE
   ;; TAB -> RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
   '((space-mark ?\u3000 [?\u25A1])
     (tab-mark   ?\u0009 [?\u00BB ?\t])))
  )

;; (use-package fill-column-indicator
;;   :straight t
;;   :ensure t
;;   :hook (prog-mode . fci-mode)
;;   )

(use-package expand-region
  :straight t
  :ensure t
  :bind (("C-=" . er/expand-region))
  )

(use-package multiple-cursors
  :straight t
  :ensure t
  )

(use-package region-bindings-mode
  :straight t
  :ensure t
  :after multiple-cursors
  :config
  (region-bindings-mode-enable)
  (define-key region-bindings-mode-map "a" 'mc/mark-all-like-this)
  (define-key region-bindings-mode-map "m"
    'mc/mark-more-like-this-extended)
  (define-key region-bindings-mode-map "n" 'mc/mark-next-like-this)
  (define-key region-bindings-mode-map "p"
    'mc/mark-previous-like-this)
  )

(use-package editorconfig
  :straight t
  :ensure t
  :diminish editorconfig-mode
  :init
  (editorconfig-mode 1)
  )

(use-package editorconfig-custom-majormode
  :straight t
  :ensure t
  :after editorconfig
  :init
  (add-hook 'editorconfig-custom-hooks
            'editorconfig-custom-majormode)
  )

(use-package fontawesome
  :straight t
  :ensure t
  :config
  (defun insert-fontawesome ()
    (interactive)
    (insert (call-interactively 'fontawesome)))
  )

(use-package popwin
  :straight t
  :ensure t
  :config
  (popwin-mode 1)
  )

(use-package prodigy
  :straight t
  :ensure t
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Platform-Specific Settings

;; Windows
(when (equal system-type 'windows-nt)
  ;(setq exec-suffix-list '(".exe" ".com" ".bat" ".sh" ".pl" ".py"))

  ;; ;; Cygwin
  ;; (setq shell-file-name "sh")
  ;; (setq explicit-shell-file-name "bash")
  ;; (setq shell-command-switch "-c")
  ;; (setq explicit-bash-args '("--login" "--noediting" "-i"))
  ;; (setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")
  ;; (add-hook
  ;;  'shell-mode-hook
  ;;  (lambda ()
  ;;    (ansi-color-for-comint-mode-on)
  ;;    (set-buffer-process-coding-system 'undecided-dos 'sjis-unix)
  ;;    (setq comint-buffer-maximum-size 3000)
  ;;    (setq comint-output-filter-functions 'comint-truncate-buffer)
  ;;    (cd "~")))
  ;; (autoload 'ansi-color-for-comint-mode-on "ansi-color"
  ;;   "Set `ansi-color-for-comint-mode' to t." t)

  ;; CMD.EXE
  (setq explicit-shell-file-name "cmdproxy.exe")
  (setq shell-file-name "cmdproxy.exe")
  (setq shell-command-switch "/C")
  ;(setq win32-quote-process-args "")

  ;; grep-find
  (setq grep-find-command
        (cons (concat "find . -type f -print0 | xargs -0 grep -nH -e ''") 49))
  )

;; Linux
(when (equal system-type 'gnu/linux)
  (use-package mozc
    :straight t
    :ensure t
    :if (executable-find "mozc_emacs_helper")
    :config
    (setq default-input-method "japanese-mozc")
    (setq mozc-candidate-style 'echo-area)
    )
  )

;; macOS
(when (equal system-type 'darwin)
  ;; fullscreen in macOS
  (add-to-list 'default-frame-alist '(fullscreen . fullboth))
  (add-to-list 'default-frame-alist '(font . "Sarasa Mono J-18"))
  ;; brew install llvm
  (custom-set-variables
   '(lsp-clients-clangd-executable "/usr/local/opt/llvm/bin/clangd"))
  )


;; Load local settings if it exists
(load (expand-file-name "init-local" user-emacs-directory) t)

;; rename
;; see http://emacsredux.com/blog/2013/05/04/rename-file-and-buffer/
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))
(define-key global-map (kbd "C-c C-r") 'rename-file-and-buffer)

(use-package server
  :config
  (unless (server-running-p) (server-start))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Theme

(use-package nord-theme
  :straight t
  :ensure t
  :init
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'nord t)))
    (load-theme 'nord t))
  )

;;; init.el ends here
