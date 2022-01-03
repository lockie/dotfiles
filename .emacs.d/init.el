;;; -*- lexical-binding: t; -*-
(require 'package)
(setq
 package-archives
 `(,@package-archives
   ("melpa" . "https://melpa.org/packages/")
   ("nongnu" . "https://elpa.nongnu.org/nongnu/")
   ("org" . "https://orgmode.org/elpa/")
   ))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package zenburn-theme
  :ensure t
  :custom
  (frame-inhibit-implied-resize t)
  :config
  (load-theme 'zenburn t)
  (add-to-list 'default-frame-alist '(font . "Anonymous Pro-14")))

(use-package bind-key :ensure t)
(use-package diminish :ensure t)

(defun my/cache-file (filename)
  (expand-file-name
   (concat
    (if (boundp 'user-emacs-directory)
        user-emacs-directory
      "~/.emacs.d/")
    ".cache/"
    filename)))

(use-package emacs
  :diminish global-whitespace-mode
  :custom
  (user-full-name   "Andrew Kravchuk")
  (user-mail-adress "awkravchuk@gmail.com")
  (truncate-lines nil)
  (scroll-margin 7)
  (mouse-wheel-progressive-speed nil)
  (use-dialog-box nil)
  (custom-file null-device)
  (bidi-display-reordering nil)
  (jit-lock-defer-time 0)
  (jit-lock-stealth-time 0.1)
  (save-interprogram-paste-before-kill t)
  (indicate-empty-lines t)
  (x-select-enable-clipboard t)
  (x-select-enable-primary t)
  (redisplay-dont-pause t)
  (enable-recursive-minibuffers t)
  (create-lockfiles nil)
  (backup-directory-alist `(("." . ,(my/cache-file "auto-save"))))
  (auto-save-default nil)
  (delete-old-versions t)
  (delete-by-moving-to-trash t)
  (bookmark-save-flag 1)
  (initial-scratch-message "")
  (initial-major-mode 'prog-mode)
  (ad-redefinition-action 'accept)
  (shr-use-fonts nil)
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (compilation-read-command nil)
  (compilation-finish-function
   (lambda (_ str)
     (when (null (string-match ".*exited abnormally.*" str))
       (run-at-time
        0.4 nil 'delete-windows-on
        (get-buffer-create "*compilation*"))
       (message "No compilation errors"))))
  (save-place-file (my/cache-file "places"))
  (whitespace-style '(face trailing tab-mark))
  (whitespace-display-mappings '((tab-mark   ?\t   [?\x2192?\x2192] [?\\ ?\t])))
  (require-final-newline t)
  (tab-width 4)
  (standart-indent 4)
  (c-basic-offset 4)
  (c-default-style "bsd")
  (js-indent-level 4)
  (js2-basic-offset 4)
  (lisp-body-indent 2)
  (indent-tabs-mode nil)
  (web-mode-markup-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (dired-dwim-target t)
  (winner-dont-bind-my-keys t)
  (hexl-bits 8)
  (frame-title-format
   '(:eval
     (format
      "%s%s %s- emacs"
      (if (buffer-modified-p)
          (cond
           (buffer-file-truename "* ")
           (t ""))
        "- ")
      (buffer-name)
      (cond
       (buffer-file-truename
        (concat "(" default-directory ") "))
       (dired-directory
        (concat "(" dired-directory ") "))
       (t "")))))
  :config
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  (tooltip-mode -1)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (defun display-startup-echo-area-message ())
  (defun my/prompt-kill-emacs ()
    (interactive)
    (save-some-buffers)
    (kill-emacs))
  (add-hook
   'kill-buffer-query-functions
   (lambda ()
     (if (equal (buffer-name (current-buffer)) "*scratch*")
         (progn (bury-buffer) nil)
       t)))
  (save-place-mode t)
  (global-whitespace-mode t)
  (show-paren-mode t)
  (global-hl-line-mode t)
  (winner-mode t)
  (minibuffer-depth-indicate-mode t)
  (define-fringe-bitmap 'tilde [0 0 0 113 219 142 0 0] nil nil 'center)
  (setcdr (assq 'empty-line fringe-indicator-alist) 'tilde)
  (set-fringe-bitmap-face 'tilde 'line-number)
  (put 'compile-command 'safe-local-variable #'stringp)
  :hook
  (after-save . executable-make-buffer-file-executable-if-script-p)
  (ediff-load
   . (lambda ()
       (add-hook 'ediff-before-setup-hook
                 (lambda ()
                   (setq ediff-saved-window-configuration
                         (current-window-configuration))))
       (let ((restore-window-configuration
              (lambda ()
                (set-window-configuration ediff-saved-window-configuration))))
         (add-hook 'ediff-quit-hook restore-window-configuration 'append)
         (add-hook 'ediff-suspend-hook restore-window-configuration 'append))))
  (prog-mode
   . (lambda () (unless (equal major-mode 'prog-mode) (hs-minor-mode))))
  (prog-mode . display-line-numbers-mode)
  (prog-mode
   . (lambda ()
       (modify-syntax-entry ?_ "w") (modify-syntax-entry ?- "w")))
  :bind
  ("C-x C-c" . nil)
  ("C-z"     . nil)
  ("<menu>"  . nil)
  ("<f1>"    . nil)
  ("<f2>"    . evil-write-all)
  ("<f3>"    . projectile-find-other-file)
  ("<f4>"    . ag)
  ("<f5>"    . compile)
  ("<f6>"    . imenu)
  ("<f7>"    . flymake-goto-next-error)
  ("<f8>"    . flymake-goto-prev-error)
  ("<f10>"   . my/prompt-kill-emacs)
  ("<f12>"   . dired-jump)
  ("S-C-h"   . shrink-window-horizontally)
  ("S-C-l"   . enlarge-window-horizontally)
  ("S-C-j"   . shrink-window)
  ("S-C-k"   . enlarge-window))

(use-package quelpa
  :ensure t
  :custom
  (quelpa-checkout-melpa-p nil))

(use-package quelpa-use-package :ensure t)

(use-package evil
  :ensure t
  :custom
  (evil-want-C-u-scroll t)
  (evil-want-fine-undo t)
  (evil-want-keybinding nil)
  :config
  (defun my/kill-this-buffer ()
      (interactive)
      (if (window-minibuffer-p)
          (abort-recursive-edit)
        (kill-buffer)))
  (evil-ex-define-cmd "bdelete" 'my/kill-this-buffer)
  (run-with-idle-timer
   10 t
   (lambda()
     (when (eq evil-state 'insert)
       (evil-normal-state))))
  (evil-mode 1))

(use-package org
  :defer t
  :custom
  (org-ditaa-jar-path "/usr/share/ditaa/lib/ditaa.jar")
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((ditaa . t))))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.4)
  (which-key-max-description-length 42)
  (which-key-separator "·")
  :config
  (which-key-mode))

(use-package general
  :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "!"   'shell-command
   ";"   'comment-or-uncomment-region
   "TAB" `(,(lambda ()
              (interactive)
              (switch-to-buffer (other-buffer (current-buffer))))
           :which-key "last buffer")
   "a"   '(:which-key "applications")
   "ad"  'dired
   "ae"  'ediff-files
   "b"   '(:which-key "buffers")
   "bd"  '(my/kill-this-buffer :which-key "kill")
   "bD"  `(,(lambda ()
              (interactive)
              (when (yes-or-no-p (format "Kill all buffers except \"%s\"? "
                                         (buffer-name)))
                (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
                (message "Buffers killed!")))
           :which-key "kill other")
   "bm"  'view-echo-area-messages
   "bn"  'next-buffer
   "bp"  'previous-buffer
   "br"  'read-only-mode
   "bs"  `(,(lambda ()
              (interactive)
              (switch-to-buffer (get-buffer "*scratch*")))
           :which-key "switch to scratch")
   "f"   '(:which-key "files")
   "fD"  `(,(lambda ()
              (interactive)
              (let ((filename (buffer-file-name))
                    (buffer (current-buffer)))
                (if (not (and filename (file-exists-p filename)))
                    (ido-kill-buffer)
                  (when (yes-or-no-p
                         "Are you sure you want to delete this file? ")
                    (delete-file filename t)
                    (kill-buffer buffer)
                    (when (projectile-project-p)
                      (call-interactively #'projectile-invalidate-cache))
                    (message "File '%s' successfully removed" filename)))))
           :which-key "delete")
   "fR"  `(,(lambda ()
              (interactive)
              (let* ((name (buffer-name))
                     (filename (buffer-file-name)))
                (if (not (and filename (file-exists-p filename)))
                    (error "Buffer '%s' is not visiting a file!" name)
                  (let* ((dir (file-name-directory filename))
                         (new-name (read-file-name "New name: " dir)))
                    (cond ((get-buffer new-name)
                           (error "Buffer '%s' already exists!" new-name))
                          (t
                           (let ((dir (file-name-directory new-name)))
                             (when (and (not (file-exists-p dir))
                                        (yes-or-no-p
                                         (format "Create directory '%s'?" dir)))
                               (make-directory dir t)))
                           (rename-file filename new-name 1)
                           (rename-buffer new-name)
                           (set-visited-file-name new-name)
                           (set-buffer-modified-p nil)
                           (when (fboundp 'recentf-add-file)
                             (recentf-add-file new-name)
                             (recentf-remove-if-non-kept filename))
                           (when (projectile-project-p)
                             (call-interactively #'projectile-invalidate-cache))
                           (message "File '%s' successfully renamed to '%s'"
                                    name (file-name-nondirectory new-name))))))))
           :which-key "rename")
   "fh"  'hexl-find-file
   "fl"  'find-file-literally
   "fs"  'save-buffer
   "fv"  '(:which-key "variables")
   "fvd" 'add-dir-local-variable
   "fvf" 'add-file-local-variable
   "fvp" 'add-file-local-variable-prop-line
   "h"   '(:which-key "help")
   "hD"  '(:which-key "describe")
   "hDK" 'desribe-keymap
   "hDb" 'describe-bindings
   "hDc" 'describe-char
   "hDk" 'desribe-key
   "hDm" 'describe-mode
   "hDp" 'desribe-package
   "hDs" 'describe-symbol
   "hk"  'which-key-show-top-level
   "hm"  'man
   "m"   '(:which-key "mode")
   "mr"  '(:which-key "refactor")
   "ms"  '(:which-key "repl")
   "q"   '(:which-key "quit")
   "qQ"  'kill-emacs
   "qq"  '(my/prompt-kill-emacs :which-key "quit emacs")
   "t"   '(:which-key "toggles")
   "ta"  '(goto-address-mode :which-key "toggle clickable addresses")
   "td"  'toggle-debug-on-error
   "tl"  'toggle-truncate-lines
   "tr"  `(,(lambda ()
              (interactive)
              (if (equal display-line-numbers-type 'relative)
                  (setq display-line-numbers-type t)
                (setq display-line-numbers-type 'relative))
              (display-line-numbers-mode))
           :which-key "toggle relative linum")
   "w"   '(:which-key "windows")
   "w-"  'split-window-below
   "w/"  'split-window-right
   "w="  'balance-windows
   "w TAB" `(,(lambda ()
                (interactive)
                (let ((prev-window (get-mru-window nil t t)))
                  (unless prev-window (user-error "Last window not found"))
                  (select-window prev-window)))
             :which-key "last window")
   "wD"  'delete-other-windows
   "wH"  'evil-window-move-far-left
   "wJ"  'evil-window-move-very-bottom
   "wK"  'evil-window-move-very-top
   "wL"  'evil-window-move-far-right
   "wM"  'maximize-window
   "wd"  'delete-window
   "wh"  'windmove-left
   "wj"  'windmove-down
   "wk"  'windmove-up
   "wl"  'windmove-right
   "wr"  'winner-redo
   "ws"  'split-window-below
   "wu"  'winner-undo
   "wv"  'split-window-right
   "ww"  'other-window
   "x"   '(:which-key "text")
   "xM"  'bookmark-delete
   "xd"  'delete-trailing-whitespace
   "xs"  'sort-lines
   "xS"  `(,(lambda (beg end) (interactive "r") (sort-lines t beg end))
           :which-key "reverse sort lines")
   "xu"  `(,(lambda ()
              (interactive)
              (save-excursion
                (save-restriction
                  (let* ((region-active (or (region-active-p) (evil-visual-state-p)))
                         (beg (if region-active (region-beginning) (point-min)))
                         (end (if region-active (region-end) (point-max))))
                    (goto-char beg)
                    (while (re-search-forward "^\\(.*\n\\)\\1+" end t)
                      (replace-match "\\1"))))))
           :which-key "uniquify lines"))
  (general-define-key
   :states '(normal visual insert)
    "<left>"   (lambda () (interactive)
                 (message
                  "Use Vim keys: <h> for Left, <b> for previous word"))
    "<right>"  (lambda () (interactive)
                 (message
                  "Use Vim keys: <l> for Right, <w> for next word"))
    "<up>"     (lambda () (interactive)
                 (message
                  "Use Vim keys: <k> for Up"))
    "<down>"   (lambda () (interactive)
                 (message
                  "Use Vim keys: <j> for Down"))
    "<home>"   (lambda () (interactive)
                 (message
                  "Use Vim keys: <0> for Home"))
    "<end>"    (lambda () (interactive)
                 (message
                  "Use Vim keys: <$> for End, <A> to insert at the end"))
    "<C-home>" (lambda () (interactive)
                 (message
                  "Use Vim keys: <gg> for beginning of document"))
    "<C-end>"  (lambda () (interactive)
                 (message
                  "Use Vim keys: <G> for end of document"))
    "<prior>"  (lambda () (interactive)
                 (message
                  "Use Vim keys: <C-b> for page up, <C-u> for half page up"))
    "<next>"   (lambda () (interactive)
                 (message
                  "Use Vim keys: <C-f> for page down, <C-d> for half page down"))
    "<delete>" (lambda () (interactive)
                 (message
                  "Use Vim keys: <x> for delete char, <d> for generic delete"))
    "<insert>" (lambda () (interactive)
                 (message
                  "Use Vim keys: <i>/<a> for insert, <R> for overwrite"))
    "<C-left>"  nil
    "<C-right>" nil
    "<C-up>"    nil
    "<C-down>"  nil
    "<M-left>"  nil
    "<M-right>" nil)
  (general-define-key
  :states 'visual
    "<" (lambda ()
          (interactive)
          (call-interactively 'evil-shift-left)
          (evil-normal-state)
          (evil-visual-restore))
    ">" (lambda ()
          (interactive)
          (call-interactively 'evil-shift-right)
          (evil-normal-state)
          (evil-visual-restore)))
  (general-define-key
   :states 'motion
    "TAB" nil
    "K"   nil
    ";"   'evil-ex)
  (push '(("\\(.*\\) 1" . "buffer-to-window-1") . ("\\1 1..9" . "buffer to window 1..9"))
        which-key-replacement-alist)
  (push '((nil . "buffer-to-window-[2-9]") . t) which-key-replacement-alist)
  (defun my/move-buffer-to-window (windownum)
    (interactive)
    (let ((b (current-buffer))
          (w1 (selected-window))
          (w2 (winum-get-window-by-number windownum)))
      (unless (eq w1 w2)
        (set-window-buffer w2 b)
        (switch-to-prev-buffer)
        (unrecord-window-buffer w1 b)))
    (select-window (winum-get-window-by-number windownum)))
  (dotimes (i 9)
    (let ((n (+ i 1)))
      (eval `(defun ,(intern (format "buffer-to-window-%i" n)) (&optional arg)
               (interactive)
               (my/move-buffer-to-window ,n)))
      (general-define-key
       :states '(normal visual insert emacs)
       :prefix "SPC"
       :non-normal-prefix "M-m"
       (format "b%i" n) (intern (format "buffer-to-window-%i" n))))))

(use-package winum
  :ensure t
  :config
  (push '(("\\(.*\\)1" . "winum-select-window-1")
          . ("\\11..9". "select window 1..9"))
        which-key-replacement-alist)
  (push '((nil . "winum-select-window-[2-9]") . t)
        which-key-replacement-alist)
  (dotimes (i 9)
    (let ((n (+ i 1)))
      (global-set-key
        (kbd (format "M-%i" n))
        (intern (format "winum-select-window-%i" n)))))
  (winum-mode))

(use-package window-purpose
  :ensure t
  :diminish purpose-mode
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "r"   '(:which-key "purpose")
   "rB"  'switch-buffer-without-purpose
   "rT"  'purpose-toggle-window-buffer-dedicated
   "rb"  'purpose-switch-buffer-with-purpose
   "rd"  'purpose-delete-non-dedicated-windows
   "rl"  'purpose-load-window-layout
   "rp"  'purpose-set-window-purpose
   "rs"  'purpose-save-window-layout
   "rt"  'purpose-toggle-window-purpose-dedicated)
  :config
  (purpose-add-user-purposes :modes '((slime-repl-mode . terminal)
                                      (slime-inspector-mode . popup)
                                      (sldb-mode . terminal))
                             :names '(("*slime-macroexpansion*" . popup)))
  (purpose-mode)
  :init
  (setq purpose-mode-map (make-sparse-keymap)))

(use-package window-purpose-x
  :ensure window-purpose
  :config
  (purpose-x-popwin-setup)
  (setq purpose-x-popwin-major-modes
        (append
         purpose-x-popwin-major-modes
         '(eww-mode messages-buffer-mode howdoi-mode multitran-mode
                    xref--xref-buffer-mode)))
  (purpose-x-popwin-update-conf)
  (purpose-x-magit-multi-on)
  (purpose-x-kill-setup))

(use-package spaceline
  :ensure t
  :custom
  (mode-line-format '("%e" (:eval (spaceline-ml-main)))))

(use-package spaceline-config
  :ensure spaceline
  :after evil
  :defer 0.1
  :custom
  (evil-emacs-state-cursor
   `(,(face-attribute 'spaceline-evil-emacs :background) box))
  (evil-normal-state-cursor
   `(,(face-attribute 'spaceline-evil-normal :background) box))
  (evil-visual-state-cursor
   `(,(face-attribute 'spaceline-evil-visual :background) hollow))
  (evil-insert-state-cursor
   `(,(face-attribute 'spaceline-evil-insert :background) bar))
  (evil-replace-state-cursor
   `(,(face-attribute 'spaceline-evil-replace :background) hbar))
  (spaceline-workspace-numbers-unicode t)
  :config
  (setq-default
   spaceline-highlight-face-func
   (lambda ()
     (let ((state
            (if (eq 'operator evil-state) evil-previous-state evil-state)))
       (intern (format "spaceline-evil-%S" state)))))
  ;; flymake support
  (defface spaceline-flymake-error
    '((t (:foreground "#FC5C94" :distant-foreground "#A20C41")))
    "" :group 'faces)
  (defface spaceline-flymake-warning
    '((t (:foreground "#F3EA98" :distant-foreground "#968B26")))
    "" :group 'faces)
  (defface spaceline-flymake-note
    '((t (:foreground "#8DE6F7" :distant-foreground "#21889B")))
    "" :group 'faces)
  (defmacro my/spaceline-flymake-lighter (severity)
    `(let ((count
            (length
             (seq-filter
              (lambda (diag)
                (= (flymake--severity ,severity)
                   (flymake--severity (flymake-diagnostic-type diag))))
              (flymake-diagnostics)))))
       (if (not (zerop count)) (format spaceline-flycheck-bullet count))))
  (dolist (state '(error warning note))
    (let ((segment-name (intern (format "flymake-%S" state)))
          (face (intern (format "spaceline-flymake-%S" state)))
          (severity (intern (format ":%S" state))))
      (eval
       `(spaceline-define-segment ,segment-name
          (when (bound-and-true-p flymake-mode)
            (let ((lighter (my/spaceline-flymake-lighter ,severity)))
              (when lighter (powerline-raw (s-trim lighter) ',face))))))))
  (spaceline-define-segment narrow
    (when (buffer-narrowed-p)
      "narrow"))
  (spaceline-install
    'main
    '((window-number
       :face highlight-face
       :priority 100)
      ((buffer-modified buffer-id narrow remote-host buffer-size)
       :priority 99)
      (major-mode :priority 94)
      (process :when active)
      (projectile-root
       :when active
       :priority 95)
      (version-control
       :when active
       :priority 97)
      ((flymake-error flymake-warning flymake-note)
       :when active
       :priority 96)
      (anzu :priority 99))
    '((global :when active)
      (purpose :priority 99)
      (python-pyvenv
       :priority 95)
      buffer-encoding-abbrev
      ((selection-info
        line-column)
       :priority 98)
      ((buffer-position
        hud)
       :priority 99))))

(use-package undo-fu
  :ensure t
  :custom
  (undo-limit 800000)
  (undo-strong-limit 12000000)
  (undo-outer-limit 120000000)
  (undo-fu-ignore-keyboard-quit t)
  :config
  (global-set-key [remap undo] #'undo-fu-only-undo)
  (global-set-key [remap redo] #'undo-fu-only-redo))

(use-package undo-fu-session
  :ensure t
  :after undo-fu
  :custom
  (undo-fu-session-directory (my/cache-file "undo-fu-session"))
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (global-undo-fu-session-mode +1))

(use-package evil-collection
  :ensure t
  :defer 0.1
  :after evil
  :custom
  (evil-collection-company-use-tng nil)
  (evil-collection-key-blacklist '("SPC" "<escape>"))
  (evil-collection-mode-list
   '(ag bookmark (buff-menu "buff-menu") calc calendar cmake-mode
        comint company compile custom dashboard diff-mode dired doc-view ediff eww
        flymake geiser grep help ibuffer image imenu-list info ivy man magit
        minibuffer (occur replace) (package-menu package) profiler simple
        slime wdired which-key woman xref))
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :custom
  (ivy-use-selectable-prompt t)
  (ivy-on-del-error-function #'ignore)
  (ivy-enable-advanced-buffer-information t)
  (ivy-extra-directories nil)
  (ivy-use-virtual-buffers t)
  :custom-face
  (ivy-current-match ((t (:inherit 'hl-line))))
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "bb"  'ivy-switch-buffer)
  :config
  (ivy-mode t))

(use-package counsel
  :ensure t
  :diminish counsel-mode
  :custom
  (counsel-projectile-ag-initial-input '(thing-at-point 'symbol t))
  :general
  (:states
   '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "?"   'counsel-descbinds
   "SPC" '(counsel-M-x :which-key "M-x")
   "ac"  'counsel-unicode-char
   "f/"  'counsel-ag
   "ff"  'counsel-find-file
   "fr"  'counsel-recentf
   "hDf" 'counsel-describe-function
   "hDv" 'counsel-describe-variable
   "x`"  'counsel-evil-marks
   "xm"  'counsel-bookmark
   "xp"  'counsel-yank-pop)
  (:keymaps 'counsel-find-file-map
   "<backspace>"
   (lambda ()
     (interactive)
     (if (equal (char-before) ?/)
         (counsel-up-directory)
       (delete-backward-char 1))))
  :config
  (counsel-mode))

(use-package swiper
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "/"   'swiper-all))

(use-package exec-path-from-shell
  :ensure t
  :defer 0.1
  :custom
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-arguments '())
  :config (exec-path-from-shell-initialize))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-items
   '((recents  . 7)
     (projects . 7)
     (bookmarks . 5)))
  :hook
  (dashboard-mode
   . (lambda ()
       (define-key evil-normal-state-local-map (kbd "m")
         (lookup-key dashboard-mode-map "m"))
       (define-key evil-normal-state-local-map (kbd "p")
         (lookup-key dashboard-mode-map "p"))
       (define-key evil-normal-state-local-map (kbd "r")
         (lookup-key dashboard-mode-map "r"))))
  :config
  (dashboard-setup-startup-hook))

(use-package restart-emacs
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "qr"  'restart-emacs))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :hook
  (find-file . projectile-find-file-hook-function)
  :custom
  (projectile-completion-system 'ivy)
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "p"   '(:which-key "projects")
   "p/"  'projectile-ag
   "pr"  'projectile-replace
   "pR"  'projectile-replace-regexp
   "pI"  'projectile-invalidate-cache))

(use-package doom-todo-ivy
  :quelpa (doom-todo-ivy
           :fetcher github
           :repo "lockie/doom-todo-ivy")
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "pt"  'doom/ivy-tasks)
  :hook (after-init . doom-todo-ivy))

(use-package counsel-projectile
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "pf"  'counsel-projectile-find-file
   "pF"  'counsel-projectile-find-file-dwim
   "pp"  'counsel-projectile)
  :config
  (counsel-projectile-mode))

(use-package autorevert
  :diminish auto-revert-mode
  :defer 0.1
  :config (global-auto-revert-mode))

(use-package recentf
  :defer 0.1
  :custom
  (recentf-auto-cleanup 'never)
  (recentf-max-saved-items 1000)
  (recentf-auto-save-timer (run-with-idle-timer 60 t 'recentf-save-list))
  :config
  (defun recentf-save-silently-advice (original &rest args)
    (let ((inhibit-message t))
      (apply original args)))
  (advice-add 'recentf-save-list :around #'recentf-save-silently-advice)
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
  (add-to-list 'recentf-exclude "/usr/share/emacs/.*")
  (add-to-list 'recentf-exclude "/tmp/.*")
  (let ((home (getenv "HOME")))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/bookmarks" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/recentf" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/.cache/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/snippets/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/elpa/.*" home))))

(use-package editorconfig
  :ensure t
  :diminish editorconfig-mode
  :config (editorconfig-mode t))

(use-package ag
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "fg"  'ag-files
   "pg"  'ag-project)
  :custom
  (ag-highlight-search t))

(use-package epl
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "aU"  `(,(lambda ()
              (interactive)
              (epl-refresh)
              (epl-upgrade))
           :which-key "upgrade pkgs")))

(use-package reverse-im
  :ensure t
  :config (reverse-im-activate "russian-computer"))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :custom
  (sp-autoinsert-pair nil)
  (sp-autoskip-closing-pair nil)
  (sp-base-key-bindings 'paredit)
  :bind
  (:map smartparens-mode-map
        ("C-M-a" . sp-beginning-of-sexp)
        ("C-M-e" . sp-end-of-sexp)
        ("C-M-n" . sp-next-sexp)
        ("C-M-p" . sp-previous-sexp)
        ("C-M-k" . sp-kill-sexp)
        ("C-k" . sp-kill-hybrid-sexp)
        ("M-k" . sp-backward-kill-sexp)
        ("M-]" . sp-unwrap-sexp)
        ("M-[" . sp-backward-unwrap-sexp)
        ("M-;" . sp-comment)
        ("M-d" . sp-kill-word)
        ("M-S" . sp-split-sexp)))

(use-package smartparens-config
  :ensure smartparens
  :hook
  (emacs-lisp-mode . smartparens-mode)
  (lisp-mode . smartparens-mode)
  (scheme-mode . smartparens-mode)
  (racket-mode . smartparens-mode))

(use-package fill-column-indicator
  :ensure t
  :custom
  (fci-rule-column 79)
  (fci-handle-truncate-lines nil)
  :hook
  (prog-mode . fci-mode)
  (window-configuration-change
   . (lambda ()
       (when (derived-mode-p 'prog-mode)
         (if (> (window-width) (+ fci-rule-column 5))
             (fci-mode 1)
           (fci-mode 0))))))

(use-package page-break-lines
  :ensure t
  :diminish page-break-lines-mode
  :config (global-page-break-lines-mode))

(use-package highlight-escape-sequences
  :ensure t
  :config (hes-mode t))

(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'stack)
  (highlight-indent-guides-character ?\N{U+2506})
  :hook
  (prog-mode . highlight-indent-guides-mode))

(use-package highlight-numbers
  :ensure t
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package highlight-symbol
  :ensure t
  :diminish highlight-symbol-mode
  :custom
  (highlight-symbol-idle-delay 0.3)
  (highlight-symbol-highlight-single-occurrence nil)
  :bind
  ("M-n" . highlight-symbol-next)
  ("M-p" . highlight-symbol-prev)
  :hook
  (prog-mode . highlight-symbol-mode))

(use-package hl-todo
  :ensure t
  :custom
  (hl-todo-highlight-punctuation ":")
  :config (global-hl-todo-mode))

(use-package rainbow-mode
  :ensure t
  :hook
  (html-mode . rainbow-mode)
  (css-mode . rainbow-mode)
  (latex-mode . rainbow-mode))

(use-package volatile-highlights
  :ensure t
  :diminish volatile-highlights-mode
  :custom-face
  (vhl/default-face ((t (:background "#3F5F3F"))))
  :config
  (vhl/define-extension 'evil 'evil-paste-after 'evil-paste-before
                        'evil-paste-pop 'evil-move)
  (vhl/install-extension 'evil)
  (vhl/define-extension 'undo-fu 'undo-fu-only-undo 'undo-fu-only-redo)
  (vhl/install-extension 'undo-fu)
  (volatile-highlights-mode t))

(use-package lisp-extra-font-lock
  :ensure t
  :config
  (nconc lisp-extra-font-lock-let-functions '("if-let" "when-let"))
  (lisp-extra-font-lock-global-mode t))

(use-package evil-anzu
  :ensure t
  :after evil
  :defer 0.1)

(use-package evil-matchit
  :ensure t
  :after evil
  :defer 0.1
  :custom
  (evilmi-may-jump-by-percentage nil)
  :config (global-evil-matchit-mode))

(use-package evil-fringe-mark
  :ensure t
  :after evil
  :defer 0.1
  :diminish global-evil-fringe-mark-mode
  :config (global-evil-fringe-mark-mode))

(use-package ivy-rich
  :ensure t
  :defer 0.1
  :custom
  (ivy-rich-display-transformers-list
   '(ivy-switch-buffer
     (:columns
      ((ivy-rich-candidate (:width 42))
       (ivy-rich-switch-buffer-size (:width 7))
       (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
       (ivy-rich-switch-buffer-major-mode (:width 16 :face warning))
       (ivy-rich-switch-buffer-project (:width 15 :face success))
       (ivy-rich-switch-buffer-path
        (:width
         (lambda (x)
           (ivy-rich-switch-buffer-shorten-path
            x (ivy-rich-minibuffer-width 0.3))))))
      :predicate
      (lambda (cand) (get-buffer cand)))
     counsel-M-x
     (:columns
      ((counsel-M-x-transformer (:width 60))
       (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
     counsel-describe-function
     (:columns
      ((counsel-describe-function-transformer (:width 40))
       (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
     counsel-describe-variable
     (:columns
      ((counsel-describe-variable-transformer (:width 40))
       (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
     counsel-recentf
     (:columns
      ((ivy-rich-candidate (:width 0.8))
       (ivy-rich-file-last-modified-time (:face font-lock-comment-face))))
     counsel-find-file
     (:columns
      ((ivy-read-file-transformer)
       (ivy-rich-counsel-find-file-truename
        (:face font-lock-doc-face))))
     package-install
     (:columns
      ((ivy-rich-candidate
        (:width 30))
       (ivy-rich-package-version
        (:width 16 :face font-lock-comment-face))
       (ivy-rich-package-archive-summary
        (:width 7 :face font-lock-builtin-face))
       (ivy-rich-package-install-summary
        (:face font-lock-doc-face))))))
  :config
  (ivy-rich-mode t))

(use-package prescient
  :ensure t
  :custom
  (prescient-save-file (my/cache-file "prescient-save.el"))
  (prescient-sort-length-enable nil)
  (prescient-filter-method '(fuzzy))
  :config (prescient-persist-mode t))

(use-package ivy-prescient
  :ensure t
  :after (counsel)
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (ivy-prescient-mode t)
  (setq
   ivy-sort-functions-alist
   '((read-file-name-internal . ivy-sort-file-function-default)
     (internal-complete-buffer . nil)
     (counsel-git-grep-function . nil)
     (Man-goto-section . nil)
     (org-refile . nil)
     (t . ivy-prescient-sort-function))))

(use-package company-prescient
  :ensure t
  :config (company-prescient-mode t))

(use-package iqa
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "fe"   '(:which-key "emacs")
   "fed" 'iqa-find-user-init-file
   "feR" 'iqa-reload-user-init-file)
  :config
  (iqa-setup-default))

(use-package anzu
  :ensure t
  :diminish anzu-mode
  :custom
  (anzu-minimum-input-length 2)
  (anzu-cons-mode-line-p nil)
  :config (global-anzu-mode t))

(use-package avy
  :ensure t
  :custom
  (avy-style 'pre)
  (avy-timeout-seconds 0.4)
  (avy-all-windows nil)
  (avy-background t)
  :general
  (:keymaps 'global
   :states 'motion
   "gc" 'evil-avy-goto-word-1
   "gt" 'evil-avy-goto-char-timer
   "gl" 'evil-avy-goto-line))

(use-package company
  :ensure t
  :diminish company-mode
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.4)
  (company-tooltip-idle-delay 0.4)
  (company-tooltip-align-annotations t)
  :config
  (defvar company-fci-mode-on-p nil)
  :hook
  (company-completion-started
   . (lambda (&rest _)
       (when (boundp 'fci-mode)
         (setq company-fci-mode-on-p fci-mode)
         (when fci-mode (fci-mode -1)))))
  (company-completion-finished
   . (lambda (&rest _)
       (when company-fci-mode-on-p (fci-mode 1))))
  (company-completion-cancelled
   . (lambda (&rest _)
       (when company-fci-mode-on-p (fci-mode 1))))
  (after-init . global-company-mode))

(use-package sane-term
  :ensure t
  :custom
  (term-char-mode-buffer-read-only nil)
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "'"   'sane-term)
  (:states '(normal visual insert emacs)
   :keymaps 'term-raw-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mc"  'sane-term-create
   "mn"  'sane-term-prev)
  (:states '(insert visual normal emacs)
   :prefix "C-x"
   "t"  `(,(lambda ()
             (interactive)
             (if (equal major-mode 'term-mode)
                 (if (term-in-line-mode)
                     (progn
                       (evil-emacs-state)
                       (term-char-mode))
                   (progn
                     (evil-normal-state)
                     (term-line-mode)))
               (user-error "Not in term mode")))
          :which-key "toggle term state"))
  (:keymaps 'term-raw-map
   "C-c"      'term-send-raw
   "<escape>" (lambda () (interactive) (term-send-raw-string "\e"))
   "M-n"      'term-send-up
   "M-p"      'term-send-down)
  :hook
  (term-mode . (lambda () (setq indicate-empty-lines nil)))
  (term-mode
   . (lambda ()
       (define-key evil-normal-state-local-map (kbd "C-g") nil)
       (dotimes (i 9)
         (let ((n (+ i 1)))
           (define-key term-raw-map (kbd (format "M-%i" n)) nil)))))
  :config
  (evil-set-initial-state 'term-mode 'emacs))

(use-package magit
  :ensure t
  :custom
  (magit-completing-read-function 'ivy-completing-read)
  (magit-diff-refine-hunk 'all)
  (magit-save-repository-buffers nil)
  (magit-refs-show-commit-count 'all)
  (magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 18))
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "g"   '(:which-key "git")
   "gS"  'magit-stage-file
   "gU"  'magit-unstage-file
   "gb"  'magit-blame-addition
   "gf"   '(:which-key "file")
   "gfh" 'magit-log-buffer-file
   "gm"  'magit-dispatch
   "gs"  'magit-status)
  :hook
  (magit-diff-mode . (lambda () (setq truncate-lines nil)))
  :config
  (defadvice magit-status (around magit-fullscreen activate)
      (window-configuration-to-register :magit-fullscreen)
      ad-do-it
      (delete-other-windows))
  :bind
  (:map magit-status-mode-map
        ("q" . (lambda ()
                 (interactive)
                 (kill-buffer)
                 (jump-to-register :magit-fullscreen))))
  (:map magit-diff-mode-map
        ("M-1" . nil)
        ("M-2" . nil)
        ("M-3" . nil)
        ("M-4" . nil)))

(use-package evil-magit :ensure t :defer 0.1)

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :custom
  (git-gutter-fr:side 'right-fringe)
  (global-git-gutter-mode t))

(use-package flymake
  :ensure t
  :diminish flymake-mode
  :custom-face
  (flymake-error
   ((((supports :underline (:style wave)))
     (:underline (:style wave :color "#BC8383") :inherit unspecified))
    (t (:foreground "#BC8383" :weight bold :underline t))))
  (flymake-warning
   ((((supports :underline (:style wave)))
     (:underline (:style wave :color "#F0DFAF") :inherit unspecified))
    (t (:foreground "#F0DFAF" :weight bold :underline t))))
  (flymake-note
   ((((supports :underline (:style wave)))
     (:underline (:style wave :color "#93E0E3") :inherit unspecified))
    (t (:foreground "#93E0E3" :weight bold :underline t))))
  :custom
  (flymake-wrap-around t)
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "ts"  '(flymake-mode :which-key "toggle syntax check")
   "e"  '(:which-key "errors")
   "el" 'flymake-show-diagnostics-buffer
   "en" 'flymake-goto-next-error
   "ep" 'flymake-goto-prev-error)
  :hook
  (prog-mode . flymake-mode))

(use-package flymake-diagnostic-at-point
  :ensure t
  :custom
  (flymake-diagnostic-at-point-timer-delay 0.4)
  (flymake-diagnostic-at-point-error-prefix "")
  (flymake-diagnostic-at-point-display-diagnostic-function
   #'flymake-diagnostic-at-point-display-minibuffer)
  :hook
  (flymake-mode . flymake-diagnostic-at-point-mode))

(use-package flymake-shellcheck
  :ensure t
  :hook
  (sh-mode . flymake-shellcheck-load))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "xi" 'yas-insert-snippet
   "xn" 'yas-new-snippet)
  :bind
  (:map yas-minor-mode-map
        ("TAB" . nil)
        ("<tab>" . nil))
  :custom
  (yas-prompt-functions '(yas-completing-prompt yas-ido-prompt))
  :config
  (yas-reload-all)
  :hook
  (prog-mode . yas-minor-mode))

(use-package origami :ensure t)

(use-package cl)

(use-package counsel-dash
  :ensure t
  :custom
  (dash-docs-enable-debugging nil)
  (counsel-dash-docs-enable-debugging nil)
  (counsel-dash-docs-min-length 1)
  (dash-docs-browser-func 'eww)
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "hd" `(,(lambda ()
             (interactive)
             (counsel-dash (current-word)))
          :which-key "counsel dash"))
  :hook
  (emacs-lisp-mode . (lambda () (setq-local counsel-dash-docsets '("Emacs Lisp"))))
  (lisp-mode . (lambda () (setq-local counsel-dash-docsets '("Common Lisp"))))
  (racket-mode . (lambda () (setq-local counsel-dash-docsets '("Racket"))))
  (python-mode . (lambda () (setq-local counsel-dash-docsets '("Python 3" "Django"))))
  (TeX-mode . (lambda () (setq-local counsel-dash-docsets '("LaTeX"))))
  (markdown-mode . (lambda () (setq-local counsel-dash-docsets '("Markdown"))))
  (web-mode . (lambda () (setq-local counsel-dash-docsets '("HTML" "Jinja" "CSS"))))
  (css-mode . (lambda () (setq-local counsel-dash-docsets '("CSS"))))
  (dockerfile-mode . (lambda () (setq-local counsel-dash-docsets '("Docker" "Bash"))))
  (sh-mode . (lambda () (setq-local counsel-dash-docsets '("Bash"))))
  (cmake-mode . (lambda () (setq-local counsel-dash-docsets '("CMake"))))
  (c-mode . (lambda () (setq-local counsel-dash-docsets '("C"))))
  (c++-mode . (lambda () (setq-local counsel-dash-docsets '("C" "C++")))))

(use-package eglot
  :ensure t
  :commands (eglot eglot-ensure eglot-format)
  :custom
  (eglot-ignored-server-capabilites
   '(:documentOnTypeFormattingProvider
     :documentHighlightProvider :hoverProvider :colorProvider :codeLensProvider
     :foldingRangeProvider :codeActionProvider :documentLinkProvider))
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (general-define-key
   :states '(normal visual insert emacs)
   :keymap 'eglot-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mrf" 'eglot-format
   "mrh" 'eglot-help-at-point
   "mrr" 'eglot-rename)
  :hook
  (python-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure))

(use-package geiser
  :ensure t
  :custom
  (geiser-active-implementations '(gambit chicken guile chez chibi))
  (geiser-chicken-binary '("csi" "-R" "r7rs"))
  (geiser-autodoc-delay 0.4)
  (geiser-mode-smart-tab-p t)
  :hook (scheme-mode . geiser-mode)
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'geiser-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "msb" 'geiser-eval-buffer
   "msc" 'geiser-compile-current-buffer
   "msd" 'geiser-eval-definition
   "mse" 'geiser-eval-last-sexp
   "msi" 'run-geiser
   "msr" 'geiser-eval-region
  ))

(use-package slime-company
  :ensure t
  :defer t
  :custom
  (slime-company-completion 'fuzzy))

(use-package slime
  :ensure t
  :custom
  (slime-lisp-implementations
   '((sbcl ("sbcl" "--dynamic-space-size" "4096"))
     (ccl ("ccl"))
     (ecl ("ecl"))))
  (slime-net-coding-system 'utf-8-unix)
  (slime-contribs
   '(slime-repl slime-autodoc slime-editing-commands slime-fancy-inspector
                slime-fancy-trace slime-fuzzy slime-mdot-fu slime-macrostep
                slime-presentations slime-quicklisp slime-references
                slime-fontifying-fu slime-trace-dialog slime-company
                slime-cl-indent slime-sbcl-exts))
  (slime-complete-symbol*-fancy t)
  (slime-repl-auto-right-margin t)
  (slime-repl-history-size 10000)
  (lisp-indent-function 'common-lisp-indent-function)
  (common-lisp-style "sbcl")
  :config
  (let ((quicklisp-helper (expand-file-name "~/.quicklisp/slime-helper.el")))
    (when (file-exists-p quicklisp-helper)
      (load quicklisp-helper)))
  :bind
  (:map slime-mode-indirect-map
        ("M-n" . nil)
        ("M-p" . nil))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'slime-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mc"  'slime-compile-and-load-file
   "mrc" 'slime-close-all-parens-in-sexp
   "msb" 'slime-eval-buffer
   "msd" 'slime-eval-defun
   "mse" 'slime-eval-last-expression
   "msi" 'slime
   "msr" 'slime-eval-region))

(use-package cmake-mode :ensure t)

(use-package docker-compose-mode :ensure t :defer t)

(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile\\'"
  :config
  (put 'docker-image-name 'safe-local-variable 'stringp))

(use-package elisp-mode
  :custom
  (lisp-indent-function 'lisp-indent-function)
  :hook
  (emacs-lisp-mode . (lambda () (setq evil-shift-width lisp-body-indent)))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'emacs-lisp-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mc"  'emacs-lisp-byte-compile
   "mrc" 'check-parens
   "msi" 'ielm
   "msb" 'eval-buffer
   "msd" 'eval-defun
   "mse" 'eval-last-sexp
   "msr" 'eval-region))

(use-package fennel-mode
  :ensure t
  :custom
  (fennel-mode-switch-to-repl-after-reload nil)
  :mode ("\\.fnl\\'" . fennel-mode)
  :hook
  (fennel-mode . (lambda () (slime-mode -1) (slime-autodoc-mode -1) (slime-trace-dialog-minor-mode -1)))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'fennel-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "msi" (lambda () (interactive) (run-lisp "love ."))
   "msb" 'fennel-reload
   "msd" 'lisp-eval-defun
   "msr" 'lisp-eval-region))

(use-package gitattributes-mode :ensure t)

(use-package gitconfig-mode :ensure t)

(use-package gitignore-mode
  :ensure t
  :mode "/.dockerignore\\'")

(use-package lua-mode
  :ensure t)

(use-package flymake-lua
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command
   "markdown2 -x cuddled-lists,fenced-code-blocks,header-ids,tables")
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'markdown-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mp" 'markdown-preview))

(use-package pip-requirements :ensure t)

(use-package python
  :hook
  (python-mode . (lambda () (setq evil-shift-width python-indent-offset)))
  (python-mode . (lambda () (setq indent-line-function 'python-indent-line)))
  (inferior-python-mode . (lambda () (setq indicate-empty-lines nil)))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'python-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "msi" 'run-python
   "msb" 'python-shell-send-buffer
   "msd" 'python-shell-send-defun
   "msr" 'python-shell-send-region))

(use-package pyvenv
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'python-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mv"   '(:which-key "venv")
   "mva" 'pyvenv-activate
   "mvd" 'pyvenv-deactivate
   "mvw" 'pyvenv-workon)
  :config
  (add-hook 'pyvenv-post-activate-hooks 'pyvenv-restart-python)
  (add-hook
   'pyvenv-post-activate-hooks
   (lambda () (eglot-reconnect eglot--cached-server))))

(use-package racket-mode
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'racket-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "hD"  'racket-describe
   "mrc" 'check-parens
   "msi" 'racket-run
   "msb" 'racket-run
   "msd" 'racket-send-definition
   "mse" 'racket-send-last-sexp
   "msr" 'racket-send-region)
  :config
  (general-def 'motion racket-mode-map "gd" 'racket-repl-visit-definition)
  (evil-set-initial-state 'racket-describe-mode 'motion)
  :hook
  (racket-mode . (lambda () (setq evil-shift-width lisp-body-indent)))
  (racket-repl-mode . (lambda () (setq indicate-empty-lines nil))))

(use-package tex-mode
  :ensure auctex
  :custom
  (TeX-auto-save nil)
  (TeX-parse-self t)
  (LaTeX-fill-break-at-separators nil)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server nil)
  (latex-build-command (if (executable-find "latexmk") "LatexMk" "LaTeX"))
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :keymaps 'TeX-mode-map
   :non-normal-prefix "M-m"
   "mb" `(,(lambda ()
             (interactive)
             (let ((TeX-save-query nil))
               (TeX-save-document (TeX-master-file)))
             (TeX-command latex-build-command 'TeX-master-file -1))
          :which-key "build")
   "mk" 'TeX-kill-job
   "mv" 'TeX-view)
  :hook
  (TeX-mode . origami-mode)
  (TeX-mode . display-line-numbers-mode)
  (TeX-mode . TeX-fold-mode))

(use-package auctex-latexmk
  :ensure t
  :defer 1
  :custom
  (auctex-latexmk-inherit-TeX-PDF-mode t)
  :config (auctex-latexmk-setup))

(use-package company-auctex
  :ensure t
  :defer 0.1
  :config (company-auctex-init))

(use-package yaml-mode
  :ensure t
  :hook
  (yaml-mode . display-line-numbers-mode)
  :mode (("\\.\\(yml\\|yaml\\)\\'" . yaml-mode)
         ("Procfile\\'" . yaml-mode)))

(use-package web-mode
  :ensure t
  :custom
  (web-mode-attr-indent-offset t)
  (web-mode-enable-auto-pairing nil)
  (web-mode-enable-css-colorization nil)
  (web-mode-enable-current-column-highlight nil)
  :hook
  (web-mode . (lambda () (setq evil-shift-width web-mode-markup-indent-offset)))
  :mode (("\\.htm\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.jinja\\'" . web-mode)
         ("\\.jinja2\\'" . web-mode)
         ("\\.jade\\'" . web-mode)))

(use-package howdoi
  :quelpa (howdoi
           :fetcher github
           :repo "lockie/emacs-howdoi")
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "hh" 'howdoi-query-insert-code-snippet-at-point
   "hH" 'howdoi-show-current-question
   "hn" 'howdoi-show-next-question
   "hp" 'howdoi-show-previous-question)
  :custom
  (howdoi-display-question t))

(use-package wakatime-mode
  :ensure t
  :diminish wakatime-mode
  :custom
  (wakatime-cli-path "~/.local/bin/wakatime")
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "aw"  `(,(lambda ()
              (interactive)
              (browse-url "https://wakatime.com/dashboard"))
           :which-key "wakatime dashboard"))
  :config
  (global-wakatime-mode))

(use-package multitran
  :ensure t
  :custom
  (multitran-dir (my/cache-file "multitran"))
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "xt" 'multitran)
  :config
  (evil-set-initial-state 'multitran-mode 'motion))

(use-package google-this
  :ensure t
  :defer t
  :general
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "xg" 'google-this))
