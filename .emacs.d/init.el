;;; -*- lexical-binding: t; -*-
(require 'package)
(setq
 package-archives
 `(,@package-archives
   ("melpa" . "https://melpa.org/packages/")
   ("nongnu" . "https://elpa.nongnu.org/nongnu/")
   ))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package server
  :commands (server-running-p)
  :if window-system
  :init
  (unless (server-running-p)
    (server-start)))

(use-package zenburn-theme
  :ensure t
  :custom
  (frame-inhibit-implied-resize t)
  :config
  (load-theme 'zenburn t)
  (defun my/zenburn-color (color)
    (cdr (assoc color zenburn-default-colors-alist)))
  (unless (display-graphic-p)
    (zenburn-with-color-variables
      (custom-theme-set-faces
       'zenburn
       `(line-number ((t (:foreground ,zenburn-fg-05 :background ,zenburn-bg-05)))))))
  (add-to-list 'default-frame-alist '(font . "Cascadia Code NF Light-15"")))

(use-package ligature
  :ensure t
  :hook
  ;; for lambda
  (emacs-lisp-mode . prettify-symbols-mode)
  (lisp-mode . prettify-symbols-mode)
  (scheme-mode . prettify-symbols-mode)
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures '(html-mode nxml-mode web-mode)
                          '("<!--" "-->" "</>" "</" "/>" "://"))
  (ligature-set-ligatures 'markdown-mode
                          '(("=" (rx (+ "=") (? (| ">" "<"))))
                            ("-" (rx (+ "-")))
                            "##" "###" "####"))
  (ligature-set-ligatures '(lisp-mode scheme-mode elisp-mode)
                          '("lambda"))
  (ligature-set-ligatures
   'prog-mode
   '("**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "[]" "::"
     ":::" ":=" "!!" "!=" "!==" "-}" "--" "---" "-->" "->" "->>" "-<"
     "-<<" "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
     ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**" "/=" "/==" "/>"
     "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>" "++" "+++" "+>"
     "=:=" "==" "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">=" ">=>"
     ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>" "<$" "<$>" "<!--"
     "<-" "<--" "<->" "<+" "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-"
     "<<=" "<<<" "<~" "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>"
     "%%" "0x"))
  :hook
  (prog-mode . ligature-mode-turn-on))

(use-package solaire-mode
  :ensure t
  :config (solaire-global-mode))

(use-package bind-key :ensure t)
(use-package diminish :ensure t)

(defun my/cache-file (filename)
  (expand-file-name
   (concat
    (if (boundp 'user-emacs-directory)
        user-emacs-directory
      "~/.emacs.d/")
    "cache/"
    filename)))

(use-package emacs
  :diminish global-whitespace-mode
  :custom
  (user-full-name   "Andrew Kravchuk")
  (visible-bell t)
  (ring-bell-function 'ignore)
  (truncate-lines nil)
  (fill-column 79)
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
  (dired-listing-switches "-val --group-directories-first")
  (dired-kill-when-opening-new-dired-buffer t)
  (warning-minimum-level :error)
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
  (icon-title-format
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
  (add-to-list
   'compilation-finish-functions
   (lambda (_ str)
     (when (null (string-match ".*exited abnormally.*" str))
       (run-at-time
        0.4 nil 'delete-windows-on
        (get-buffer-create "*compilation*"))
       (message "No compilation errors"))))
  (put 'erase-buffer 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
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
  ("<f11>"   . nil)
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
     (when (and (eq evil-state 'insert)
                (not (eq major-mode 'vterm-mode)))
       (evil-normal-state))))
  (evil-declare-not-repeat 'evil-insert)
  (evil-mode 1))

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
   ";"   `(comment-or-uncomment-region
           :which-key "(un)comment")
   "TAB" `(,(lambda ()
              (interactive)
              (switch-to-buffer (other-buffer (current-buffer))))
           :which-key "last buffer")
   "a"   '(:which-key "applications")
   "ad"  'dired
   "ae"  'ediff-files
   "am"  'mu4e
   "as"  'sql-postgres
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
   "d"   '(:which-key "get things done")
   "dc"  `(,(lambda ()
              (interactive)
              (org-capture nil "i"))
           :which-key "capture")
   "ds"  `(,(lambda ()
              (interactive)
              (org-capture nil "s"))
           :which-key "schedule")
   "dd"  `(,(lambda ()
              (interactive)
              (org-agenda nil "d"))
           :which-key "agenda")
   "dC"  `(,(lambda ()
              (interactive)
              (find-file org-default-notes-file))
           :which-key "clarify")
   "dA"  `(,(lambda ()
              (interactive)
              (find-file (concat org-directory "/tasks.org")))
           :which-key "actions")
   "dn"  `(,(lambda ()
              (interactive)
              (org-capture nil "n"))
           :which-key "next-action")
   "dS"  `(,(lambda ()
              (interactive)
              (org-capture nil "S"))
           :which-key "shrink")
   "f"   '(:which-key "files")
   "fc"  'copy-file
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
   "s"   '(evil-write :which-key "save")
   "S"   '(evil-write-all :which-key "save all")
   "t"   '(:which-key "toggles")
   "ta"  '(goto-address-mode :which-key "toggle clickable addresses")
   "td"  'toggle-debug-on-error
   "tl"  'toggle-truncate-lines
   "tL"  'page-break-lines-mode
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
           :which-key "uniquify lines")
   "xw"  'whitespace-cleanup-region
   "xW"  'whitespace-cleanup)
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

(use-package org
  :defer t
  :custom
  (org-babel-lisp-eval-fn 'sly-eval)
  (org-babel-lisp-dir-fmt "(progn %%s\n)")
  (org-ditaa-jar-path "/usr/share/ditaa/lib/ditaa.jar")
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-enforce-todo-dependencies t)
  (org-confirm-babel-evaluate nil)
  (org-todo-keywords '((sequence "TODO" "DOING" "|" "DONE")))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-agenda-window-setup 'current-window)
  (org-agenda-start-day nil)
  (org-reverse-note-order t)
  (org-return-follows-link t)
  (org-startup-truncated nil)
  (calendar-week-start-day 1)
  (calendar-set-date-style 'european)
  (calendar-day-name-array ["Воскресенье" "Понедельник" "Вторник    "
                            "Среда      " "Четверг    " "Пятница    "
                            "Суббота    "])
  (calendar-day-header-array ["Вc" "Пн" "Вт" "Ср" "Чт" "Пт" "Сб"])
  (calendar-month-name-array ["Январь" "Февраль" "Март" "Апрель" "Май"
                              "Июнь" "Июль" "Август" "Сентябрь"
                              "Октябрь" "Ноябрь" "Декабрь"])
  (org-agenda-block-separator "")
  (org-agenda-prefix-format
   '((agenda . "\t")
     (todo . "\t")
     (tags . "\t")
     (search . "\t")))
  ;; TODO https://github.com/sid-kurias/org-agenda-count ?
  (org-agenda-custom-commands
   `(("d" "Get things done"
      ((agenda "" ((org-agenda-overriding-header "📆 Calendar")
                   (org-agenda-span 14)))
       (tags-todo "LEVEL=2"
                  ((org-agenda-overriding-header "⚡ Next actions")
                   (org-agenda-files '(,(concat org-directory "/tasks.org")))
                   (org-agenda-sorting-strategy '(todo-state-down))
                   (org-agenda-skip-function
                    '(and
                      (org-agenda-skip-entry-if 'todo '("TODO" "WAITING" "DONE"))))))
       (tags-todo "LEVEL=2"
                  ((org-agenda-overriding-header "⌛ Waiting")
                   (org-agenda-files '(,(concat org-directory "/tasks.org")))
                   (org-agenda-skip-function
                    '(and
                      (org-agenda-skip-entry-if
                       'todo '("TODO" "NEXT" "DOING" "DONE"))))))
       (tags "LEVEL=1"
             ((org-agenda-overriding-header "🤔 Someday/Maybe")
              (org-agenda-files '(,(concat org-directory "/someday-maybe.org")))))
       ;; TODO references
       ))))
  :hook ((org-agenda-mode
          . (lambda ()
              (evil-set-initial-state 'org-agenda-mode 'normal)
              (define-key evil-motion-state-local-map (kbd "RET")
                'org-agenda-switch-to)
              (define-key evil-normal-state-local-map (kbd "r")
                'org-agenda-redo)))
         (calendar-mode
          . (lambda () (define-key evil-motion-state-local-map (kbd "RET")
                    'org-calendar-select))))
  :general
  (:keymaps 'org-mode-map
            "C-c t" 'counsel-org-tag
            "C-c f" 'my/org-show-current-heading-tidily)
  :config
  (advice-add #'org-capture-place-template :after #'delete-other-windows)
  (defun my/gtd-save-org-buffers (&rest _)
    "Save `org-agenda-files' buffers without user confirmation."
    (interactive)
    (message "Saving org-agenda-files buffers...")
    (save-some-buffers t (lambda () (member (buffer-file-name) org-agenda-files)))
    (message "Saving org-agenda-files buffers... done"))
  (advice-add #'org-refile :after #'my/gtd-save-org-buffers)
  (advice-add #'org-refile :after #'org-refile-goto-last-stored)
  (put 'org-reverse-note-order 'safe-local-variable #'booleanp)
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((C . t)
                                 (python . t)
                                 (ditaa . t)))
  (defun my/org-show-current-heading-tidily ()
    (interactive)
    "Show next entry, keeping other entries closed."
    (if (save-excursion (end-of-line) (outline-invisible-p))
        (progn (org-show-entry) (show-children))
      (outline-back-to-heading)
      (unless (and (bolp) (org-on-heading-p))
        (org-up-heading-safe)
        (hide-subtree)
        (error "Boundary reached"))
      (org-display-inline-images)
      (org-overview)
      (org-reveal t)
      (org-show-entry)
      (show-children)))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((lisp . t)))
  :init
  (setq
   org-directory (expand-file-name "~/Dropbox/GTD")
   org-agenda-files (directory-files-recursively org-directory "\\.org$")
   org-default-notes-file (concat org-directory "/inbox.org")
   org-capture-templates
   `(("i" "Inbox" entry (file org-default-notes-file)
      "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:"
      :prepend t
      :kill-buffer t)
     ("l" "Link" entry (file org-default-notes-file)
      "* TODO %:annotation\n:PROPERTIES:\n:CREATED: %U\n:END:"
      :prepend t
      :kill-buffer t)
     ("n" "Next action" entry (file+headline ,(concat org-directory "/tasks.org") "⚡ Next actions")
      "* TODO %?\n:PROPERTIES:\n:OUTCOME: %^{OUTCOME}\n:CREATED: %U\n:END:"
      :prepend t
      :kill-buffer t)
     ("s" "Schedule" entry (file ,(concat org-directory "/calendar.org"))
      "* TODO %?\nSCHEDULED: %^t"
      :prepend t
      :kill-buffer t)
     ("S" "Shrink" entry (file+headline ,(concat org-directory "/someday-maybe.org") "💬 Shrink")
      "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:"
      :prepend t
      :kill-buffer t))
   org-refile-targets `((,(concat org-directory "/tasks.org") :maxlevel . 1)
                        (,(concat org-directory "/someday-maybe.org") :level . 1)
                        (,(concat org-directory "/someday-maybe.org") :tag . "ideas")
                        (,(concat org-directory "/references.org") :level . 1)
                        (,(concat org-directory "/archive.org") :level . 0)
                        )))

(use-package org-protocol)

(use-package org-appear
  :ensure t
  :defer t
  :custom
  (org-appear-autolinks t)
  :hook
  (org-mode . org-appear-mode))

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
  (purpose-add-user-purposes :modes '((sly-repl-mode . terminal)
                                      (sly-inspector-mode . popup)
                                      (sly-db-mode . terminal)
                                      (sly-xref-mode . popup)
                                      (cider-repl-mode . terminal)
                                      (cider-test-report-mode . popup)
                                      (vterm-mode . terminal))
                             :names '(("*sly-macroexpansion*" . popup)
                                      ("*cider-macroexpansion*" . popup)
                                      ("*cider-clojuredocs*" . popup)))
  (purpose-mode)
  :init
  ;; prevent breaking C-c in term mode
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
  (evil-undo-system 'undo-fu)
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
   '(ag bookmark (buff-menu "buff-menu") calc calendar cider cmake-mode
        comint company compile custom dashboard diff-mode dired doc-view ediff eww
        flymake geiser grep help ibuffer image imenu-list info ivy man magit
        minibuffer mu4e (package-menu package) profiler simple
        sly wdired which-key woman xref))
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
  (:states 'motion
   :keymaps 'ivy-minibuffer-map
   "C-d" 'ivy-scroll-up-command
   "C-f" 'ivy-scroll-up-command
   "C-u" 'ivy-scroll-down-command
   "C-b" 'ivy-scroll-down-command)
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
   "?"   '(counsel-descbinds :which-key "bindings")
   "SPC" '(counsel-M-x :which-key "command")
   "xc"  'counsel-unicode-char
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
   "/"   '(swiper-all :which-key "search")))

(use-package exec-path-from-shell
  :ensure t
  :defer 0.1
  :custom
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-arguments '())
  :config (exec-path-from-shell-initialize))

(use-package dashboard
  ;; newer version breaks about everything
  :quelpa (dashboard
           :fetcher github
           :repo "emacs-dashboard/emacs-dashboard"
           :commit "eeee96")
  :custom
  (dashboard-startup-banner
   (concat
    (if (boundp 'user-emacs-directory)
        user-emacs-directory
      "~/.emacs.d/")
    "logo.png"))
  (dashboard-projects-backend 'projectile)
  (dashboard-center-content t)
  (dashboard-set-footer nil)
  (dashboard-week-agenda nil)
  (dashboard-agenda-sort-strategy '(time-up))
  (dashboard-items
   '((recents  . 7)
     (projects . 7)
     (bookmarks . 5)
     (agenda . 5)))
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
  (projectile-enable-caching t)
  (define-advice project-try-vc (:before-while (dir) ignore-quicklisp)
    (let ((pred (apply-partially #'file-equal-p "~/.quicklisp/")))
      (not (locate-dominating-file dir pred))))
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
   "pt"  '(doom/ivy-tasks :which-key "todos"))
  :hook (after-init . doom-todo-ivy)
  :config
  (setq doom/ivy-task-tags
        '(("TODO"  . warning)
          ("XXX" . warning)
          ("FIXME" . error))))

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
  (defun my/recentf-save-silently-advice (original &rest args)
    (let ((inhibit-message t))
      (apply original args)))
  (advice-add 'recentf-save-list :around #'my/recentf-save-silently-advice)
  (add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
  (add-to-list 'recentf-exclude "/usr/share/emacs/.*")
  (add-to-list 'recentf-exclude "/usr/lib64/sbcl/.*")
  (add-to-list 'recentf-exclude "/usr/lib64/sbcl/asdf/.*")
  (add-to-list 'recentf-exclude (recentf-expand-file-name "~/.quicklisp/.*"))
  (add-to-list 'recentf-exclude "/tmp/.*")
  (let ((home (getenv "HOME")))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/bookmarks" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/recentf" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/.cache/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/snippets/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/elpa/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.m2/.*" home))
    (add-to-list 'recentf-exclude (format "%s/\\.Mail/.*" home))
    ))

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

(use-package paredit
  :ensure t
  :hook
  (clojure-mode . paredit-mode)
  (lisp-mode . paredit-mode)
  (emacs-lisp-mode . paredit-mode)
  (scheme-mode . paredit-mode)
  (racket-mode . paredit-mode)
  (ielm-mode . paredit-mode)
  (lisp-interaction-mode . paredit-mode)
  (fennel-mode . paredit-mode)
  :bind
  ("M-[" . paredit-wrap-square)
  ("M-{" . paredit-wrap-curly)
  :config
  (eldoc-add-command 'paredit-backward-delete 'paredit-close-round))

(use-package paren-face
  :ensure t
  :custom
  (paren-face-regexp "[()]")
  :config
  (global-paren-face-mode))

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

;; prevent fill-column-indicator from adding weird symbols to Org export
;; see https://emacs.stackexchange.com/q/44361/16660
(use-package htmlize
  :defer t
  :config
  (progn
    (with-eval-after-load 'fill-column-indicator
      (defvar modi/htmlize-initial-fci-state nil
        "Variable to store the state of `fci-mode' when `htmlize-buffer' is called.")
      (defun modi/htmlize-before-hook-fci-disable ()
        (setq modi/htmlize-initial-fci-state fci-mode)
        (when fci-mode
          (fci-mode -1)))
      (defun modi/htmlize-after-hook-fci-enable-maybe ()
        (when modi/htmlize-initial-fci-state
          (fci-mode 1)))
      (add-hook 'htmlize-before-hook #'modi/htmlize-before-hook-fci-disable)
      (add-hook 'htmlize-after-hook #'modi/htmlize-after-hook-fci-enable-maybe))))

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
  (highlight-indent-guides-method 'bitmap)
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
  (sass-mode . rainbow-mode)
  (latex-mode . rainbow-mode))

(use-package volatile-highlights
  :ensure t
  :diminish volatile-highlights-mode
  :custom-face
  (vhl/default-face ((t (:background ,(my/zenburn-color "zenburn-green-4")))))
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
  (nconc lisp-extra-font-lock-let-functions '("if-let" "when-let" "mvlet" "mvlet*"))
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
      ((ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
       (ivy-rich-candidate (:width 60))
       (ivy-rich-switch-buffer-size (:width 7))
       (ivy-rich-switch-buffer-major-mode (:width 16 :face warning))
       (ivy-rich-switch-buffer-project (:width 30 :face success))
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

(use-package vterm
  :ensure t
  :custom
  (vterm-max-scrollback 100000)
  :config
  (evil-set-initial-state 'vterm-mode 'insert)
  (defun my/dummy-command () (interactive))
  :hook
  (vterm-copy-mode . (lambda () (if vterm-copy-mode
                               (evil-normal-state)
                             (evil-insert-state))))
  (vterm-copy-mode
   . (lambda ()
       (dolist (key '("i" "I" "a" "A" "o" "O"))
         (define-key evil-normal-state-local-map (kbd key) #'my/dummy-command))
       (evil-define-key 'normal vterm-copy-mode-map (kbd "C-c C-n") #'multi-vterm-next)
       (evil-define-key 'normal vterm-copy-mode-map (kbd "C-c C-p") #'multi-vterm-prev)))
  (evil-insert-state-entry . (lambda () (when vterm-copy-mode (evil-normal-state))))
  (vterm-mode
   . (lambda ()
       (evil-define-key 'insert vterm-mode-map (kbd "C-c C-d") #'term-send-eof)
       (evil-define-key 'insert vterm-mode-map (kbd "C-c C-n") #'multi-vterm-next)
       (evil-define-key 'insert vterm-mode-map (kbd "C-c C-p") #'multi-vterm-prev)
       (evil-define-key 'insert vterm-mode-map (kbd "<escape>") #'vterm--self-insert)
       (dotimes (i 9)
         (let ((n (+ i 1)))
           (define-key vterm-mode-map (kbd (format "M-%i" n)) nil))))))

(use-package multi-vterm
  :ensure t
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'vterm-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mn"  'multi-vterm-next
   "mp"  'multi-vterm-prev)
  (:states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "'"   '(multi-vterm :which-key "term")))

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
  (defadvice magit-mode-quit-window (after magit-restore-screen activate)
    (jump-to-register :magit-fullscreen))
  (defun my/close-magit ()
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))
  :bind
  (:map magit-status-mode-map
        ("q" . my/close-magit)
        ("<escape>" . my/close-magit))
  (:map magit-diff-mode-map
        ("M-1" . nil)
        ("M-2" . nil)
        ("M-3" . nil)
        ("M-4" . nil)))

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
     (:underline (:style wave :color ,(my/zenburn-color "zenburn-red-1")) :inherit unspecified))
    (t (:foreground ,(my/zenburn-color "zenburn-red-1") :weight bold :underline t))))
  (flymake-warning
   ((((supports :underline (:style wave)))
     (:underline (:style wave :color ,(my/zenburn-color "zenburn-yellow")) :inherit unspecified))
    (t (:foreground ,(my/zenburn-color "zenburn-yellow") :weight bold :underline t))))
  (flymake-note
   ((((supports :underline (:style wave)))
     (:underline (:style wave :color ,(my/zenburn-color "zenburn-cyan")) :inherit unspecified))
    (t (:foreground ,(my/zenburn-color "zenburn-cyan") :weight bold :underline t))))
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

(use-package origami
  :ensure t
  :config
  (defvar my/org-agenda-auto-show-groups
    '("Calendar" "Next actions" "Waiting"))
  (defun my/org-agenda-origami-fold-default ()
    (unless (buffer-narrowed-p)
      (save-excursion
        (call-interactively 'origami-close-all-nodes)
        (call-interactively 'origami-open-node)
        (call-interactively 'origami-forward-fold)
        (call-interactively 'origami-open-node))))
  :hook
  ((org-agenda-mode . origami-mode)
   (org-agenda-finalize . my/org-agenda-origami-fold-default))
  :general
  (:keymaps 'org-agenda-mode-map
            "<tab>" #'origami-toggle-node))

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
  (clojure-mode . (lambda () (setq-local counsel-dash-docsets '("Clojure"))))
  (racket-mode . (lambda () (setq-local counsel-dash-docsets '("Racket"))))
  (lua-mode . (lambda () (setq-local counsel-dash-docsets '("Lua"))))
  (python-mode . (lambda () (setq-local counsel-dash-docsets '("Python 3" "Django" "Flask" "NumPy" "SQLAlchemy"))))
  (sql-mode . (lambda () (setq-local counsel-dash-docsets '("PostgreSQL"))))
  (TeX-mode . (lambda () (setq-local counsel-dash-docsets '("LaTeX"))))
  (markdown-mode . (lambda () (setq-local counsel-dash-docsets '("Markdown"))))
  (web-mode . (lambda () (setq-local counsel-dash-docsets '("HTML" "Jinja" "CSS" "jQuery"))))
  (css-mode . (lambda () (setq-local counsel-dash-docsets '("CSS"))))
  (dockerfile-mode . (lambda () (setq-local counsel-dash-docsets '("Docker" "Bash"))))
  (sh-mode . (lambda () (setq-local counsel-dash-docsets '("Bash"))))
  (cmake-mode . (lambda () (setq-local counsel-dash-docsets '("CMake"))))
  (c-mode . (lambda () (setq-local counsel-dash-docsets '("C" "GLib"))))
  (c++-mode . (lambda () (setq-local counsel-dash-docsets '("C" "C++" "Qt")))))

(use-package bison-mode
  :ensure t)

(use-package eglot
  :ensure t
  :commands (eglot eglot-ensure eglot-format)
  :custom
  (eglot-ignored-server-capabilities
   '(:documentOnTypeFormattingProvider
     :documentHighlightProvider :hoverProvider :colorProvider :codeLensProvider
     :foldingRangeProvider :codeActionProvider :documentLinkProvider
     :inlayHintProvider))
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(fennel-mode "fennel-ls"))
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
  (c++-mode . eglot-ensure)
  (fennel-mode . eglot-ensure))

(use-package cider
  :ensure t
  :custom
  (cider-repl-history-file (my/cache-file ".cider-repl-history"))
  :hook
  (cider-mode . (lambda ()
                  (set (make-local-variable 'eldoc-documentation-function)
                       'cider-eldoc)))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'clojure-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "msi" 'cider-jack-in
   "msI" 'cider-jack-in-clj&cljs
   "mss" 'sesman-start
   "mst" 'cider-test-run-project-tests
   "mhc" 'cider-cheatsheet
   "mfb" 'cider-format-buffer
   "mfr" 'cider-format-region
   "mfd" 'cider-format-defun)
  (:states '(motion)
   :keymaps 'clojure-mode-map
   "gd" 'cider-find-var)
  (:keymaps 'cider-repl-mode-map
   :prefix "C-c"
   "M-o" 'cider-repl-clear-buffer)
  :init
  (put 'cider-default-cljs-repl 'safe-local-variable #'symbolp)
  (put 'cider-shadow-default-options 'safe-local-variable #'stringp)
  (put 'cider-shadow-watched-builds 'safe-local-variable #'listp)
  (put 'cider-preferred-build-tool 'safe-local-variable #'symbolp))

(use-package cider-eval-sexp-fu
  :ensure t
  :custom
  (eval-sexp-fu-flash-duration 0.2)
  (eval-sexp-fu-flash-error-duration 0.2)
  (eval-sexp-fu-flash-face '((t (:inherit 'highlight))))
  (eval-sexp-fu-flash-error-face '((t (:inherit 'highlight)))))

(use-package clj-refactor
  :ensure t
  :hook
  (clojure-mode . (lambda ()
                    (clj-refactor-mode 1)
                    (cljr-add-keybindings-with-prefix "C-c r"))))

(use-package flymake-kondor
  :ensure t
  :hook
  (clojure-mode . flymake-kondor-setup))

(use-package re-jump
  :quelpa (re-jump
           :fetcher github
           :repo "oliyh/re-jump.el")
  :general
  (:states '(motion)
   :keymaps 'clojure-mode-map
   "gr" 're-frame-jump-to-reg))

;; TODO : <https://github.com/nedap/formatting-stack>

(use-package geiser
  :ensure t
  :custom
  (geiser-active-implementations '(guile chez chibi chicken gambit mit racket))
  (geiser-default-implementation 'guile)
  ;; (geiser-chicken-binary '("csi" "-R" "r7rs"))
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
   "msi" 'geiser
   "msr" 'geiser-eval-region
   ))

(use-package geiser-chicken
  :ensure t)

(use-package geiser-gambit
  :ensure t)

(use-package geiser-guile
  :ensure t
  ;; :custom
  ;; (geiser-guile-binary "guile-3")
  )

(use-package geiser-chez
  :ensure t)

(use-package geiser-mit
  :ensure t)

(use-package geiser-racket
  :ensure t)

(use-package geiser-chibi
  :ensure t)

(use-package sly
  :ensure t
  :after (evil zenburn-theme)
  :custom
  (sly-default-lisp 'sbcl)
  (sly-net-coding-system 'utf-8-unix)
  (sly-common-lisp-style-default "sbcl")
  (sly-complete-symbol-function #'my/sly-flex-completions)
  (sly-mrepl-history-file-name (my/cache-file ".sly-mrepl-history"))
  :custom-face
  (sly-mrepl-output-face
   ((t (:foreground ,(my/zenburn-color "zenburn-green+2")))))
  (sly-note-face
   ((t (:underline (:style wave :color ,(my/zenburn-color "zenburn-fg"))))))
  (sly-style-warning-face
   ((t (:underline (:style wave :color ,(my/zenburn-color "zenburn-blue"))))))
  (sly-warning-face
   ((t (:underline (:style wave :color ,(my/zenburn-color "zenburn-orange"))))))
  (sly-error-face
   ((t (:underline (:style wave :color ,(my/zenburn-color "zenburn-red-1"))))))
  :bind
  (:map sly-editing-mode-map
        ("M-n" . nil)
        ("M-p" . nil)
        :map sly-mode-map
        ("M-_" . nil)
        :map evil-insert-state-map
        ("C-r" . nil))
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'sly-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mc"  'sly-compile-and-load-file
   "mrc" 'sly-close-all-parens-in-sexp
   "msb" 'sly-eval-buffer
   "msd" 'sly-eval-defun
   "mse" 'sly-eval-last-expression
   "msi" 'sly
   "msr" 'sly-eval-region)
  :config
  (setq sly-lisp-implementations
        '((sbcl ("sbcl" "--dynamic-space-size" "4096"))
          (ccl ("ccl"))
          (ecl ("ecl"))
          (abcl ("abcl"))
          (clisp ("clisp"))
          (alisp ("alisp"))))
  (setq lisp-indent-function #'sly-common-lisp-indent-function)
  (defun my/sly-flex-completions (pattern)
    "Same as SLY-FLEX-COMPLETIONS, but without annoying percentage numbers"
    (cl-loop with (completions _) =
         (sly--completion-request-completions pattern 'slynk-completion:flex-completions)
       for (completion score chunks classification suggestion) in completions
       do (cl-loop for (pos substring) in chunks
             do (put-text-property pos (+ pos (length substring))
                                   'face 'completions-first-difference completion)
             collect `(,pos . ,(+ pos (length substring))) into chunks-2
             finally (put-text-property 0 (length completion)
                                        'sly-completion-chunks chunks-2 completion))
         (add-text-properties 0 (length completion)
                              `(sly--annotation ,classification sly--suggestion ,suggestion)
                              completion)
       collect completion into formatted
       finally return (list formatted nil)))
  (defun my/sly-ignore-fennel (f &rest args)
    "Prevent sly functions from running in `fennel-mode'."
    (unless (or (eq major-mode 'fennel-mode)
                (eq major-mode 'fennel-repl-mode))
      (apply f args)))
  (dolist (f '(sly-mode sly-editing-mode))
    (advice-add f :around #'my/sly-ignore-fennel))
  (defun my/sly-run-lisp-unit-test-at-point (&optional raw-prefix-arg)
    "See `sly-compile-defun' for RAW-PREFIX-ARG."
    (interactive "P")
    (call-interactively 'sly-compile-defun)
    (let ((name `(quote ,(intern (sly-qualify-cl-symbol-name (sly-parse-toplevel-form))))))
      (sly-eval-async
          `(parachute:test ,name :report 'parachute:interactive)
        (lambda (results)
          ;; TODO : returning result not working
          (message results)
          (switch-to-buffer-other-window  (get-buffer-create "*Test Results*"))
          (erase-buffer)
          (insert results)))))
  (define-key lisp-mode-map (kbd "C-c C-v")
    #'my/sly-run-lisp-unit-test-at-point)
  (load "~/.quicklisp/log4sly-setup.el")
  (global-log4sly-mode 1))


(use-package sly-quicklisp
  :ensure t
  :defer t
  :config
  (define-key sly-prefix-map (kbd "C-q") 'sly-quickload))

(use-package cmake-mode :ensure t)

(use-package docker-compose-mode :ensure t :defer t)

(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile\\'"
  :config
  (put 'docker-image-name 'safe-local-variable 'stringp))

(use-package terraform-mode
  :ensure t
  :custom (terraform-indent-level 2))

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
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'fennel-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "msi" (lambda () (interactive) (run-lisp "love ."))
   "msb" 'fennel-reload
   "msd" 'lisp-eval-defun
   "msr" 'lisp-eval-region))

(use-package git-modes
  :ensure t
  :mode ("/.dockerignore\\'" . gitignore-mode))

(use-package haskell-mode
  :ensure t)

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

(use-package impatient-showdown
  :ensure t
  :custom
  (impatient-showdown-flavor 'github)
  :general
  (:states '(normal visual insert emacs)
   :keymaps 'markdown-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-m"
   "mP" 'impatient-showdown-mode))

(use-package nsis-mode
  :ensure t
  :mode "\\.nsi\\'")

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

(use-package sass-mode
  :ensure t
  :defer t
  :mode ("\\.sass\\'" . sass-mode))

(use-package sql
  :custom
  (sql-server "localhost")
  (sql-user "postgres"))

(use-package sql-indent
  :ensure t
  :after sql
  :diminish sql-indent
  :hook
  (sql-mode . sqlind-minor-mode))

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
  :after auctex
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
           "xg"  `(,(lambda ()
                      (interactive)
                      (google-this nil t))
                   :which-key "google this")))

(use-package mu4e
  :preface (setq-default mu-command (executable-find "mu"))
  :if mu-command
  :custom
  (mail-user-agent 'mu4e-user-agent)
  (read-mail-command 'mu4e)
  (mu4e-confirm-quit nil)
  (mu4e-mu-home (expand-file-name "~/.cache/mu"))
  (mu4e-maildir (expand-file-name "~/.Mail"))
  (mu4e-attachment-dir (expand-file-name "~/Downloads"))
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-change-filenames-when-moving t)
  (mu4e-use-fancy-chars t)
  (mu4e-completing-read-function 'ivy-completing-read)
  (mu4e-context-policy 'pick-first)
  (mu4e-compose-context-policy 'ask)
  (mu4e-headers-leave-behavior 'apply)
  (mu4e-read-option-use-builtin nil)
  (mu4e-bookmarks
   `((:name "Unread"
            :query ,(concat
                     "flag:unread AND NOT flag:trashed AND ("
                     "maildir:/awkravchuk/inbox"
                     " OR maildir:/lockie666/inbox"
                     ")")
            :key ?u)
     (:name "Today"
            :query ,(concat "date:today..now AND NOT ("
                            "maildir:/awkravchuk/junk"
                            " OR maildir:/lockie666/junk"
                            ")")
            :key ?t)))
  (mu4e-modeline-max-width 50)
  (mu4e-headers-fields
   '((:date . 10)
     (:flags . 6)
     (:mailing-list . 15)
     (:from . 26)
     (:subject)))

  :config
  (setf (alist-get 'trash mu4e-marks)
        ;; https://github.com/danielfleischer/mu4easy ❤️
        '(:char ("d" . "▼")
                :prompt "dtrash"
                :dyn-target (lambda (target msg) (mu4e-get-trash-folder msg))
                :action (lambda (docid msg target)
                          (mu4e--server-move docid
                                             (mu4e--mark-check-target target)
                                             "+S-u-N"))))
  (setq
   mu4e-headers-draft-mark     '("D" . "🔧")
   mu4e-headers-flagged-mark   '("F" . "🚩")
   mu4e-headers-new-mark       '("N" . "🔥")
   mu4e-headers-passed-mark    '("P" . "🠞")
   mu4e-headers-replied-mark   '("R" . "🠜")
   mu4e-headers-seen-mark      '("S" . "☑")
   mu4e-headers-trashed-mark   '("T" . "🗑️")
   mu4e-headers-attach-mark    '("a" . "📎")
   mu4e-headers-encrypted-mark '("x" . "🔒")
   mu4e-headers-signed-mark    '("s" . "🔑")
   mu4e-headers-unread-mark    '("u" . "☐")
   mu4e-headers-list-mark      '("l" . "🔈")
   mu4e-headers-personal-mark  '("p" . "👨")
   mu4e-headers-calendar-mark  '("c" . "📅"))
  (defun my/make-mu4e-context-matcher (match-str)
    (lambda (msg)
      (when msg
        (message (mu4e-message-field msg :maildir))
        (string-prefix-p match-str (mu4e-message-field msg :maildir)))))
  (defun my/make-context (ctx)
    (let ((name (plist-get ctx :name)))
      (make-mu4e-context
       :name name
       :match-func (my/make-mu4e-context-matcher (format "/%s" name))
       :vars `((mu4e-sent-folder . ,(format "/%s/sent" name))
               (mu4e-drafts-folder . ,(format "/%s/drafts" name))
               (mu4e-trash-folder . ,(format "/%s/trash" name))
               (mu4e-refile-folder . ,(format "/%s/archive" name))
               (user-mail-address . ,(plist-get ctx :address))
               (mu4e-maildir-shortcuts . ((,(format "/%s/inbox" name). ?i)
                                           (,(format "/%s/archive" name) . ?a)
                                           (,(format "/%s/drafts" name) . ?d)
                                           (,(format "/%s/sent" name) . ?S)
                                           (,(format "/%s/junk" name) . ?j)
                                           (,(format "/%s/starred" name) . ?s)
                                           (,(format "/%s/trash" name) . ?t)))))))
  (setf mu4e-contexts `(,(my/make-context '(:name "awkravchuk" :address "awkravchuk@gmail.com"))
                        ,(my/make-context '(:name "lockie666" :address "lockie666@gmail.com"))
                       )))

(use-package smtpmail-multi
  :ensure t
  :custom
  (message-signature nil)
  (smtpmail-stream-type 'ssl)
  (smtpmail-multi-accounts
   '((awkravchuk . ("awkravchuk" "smtp.gmail.com" 587 "awkravchuk@gmail.com" nil nil nil nil))
     (lockie666 . ("lockie666" "smtp.gmail.com" 587 "lockie666@gmail.com" nil nil nil nil))))
  (smtpmail-multi-associations
   '(("awkravchuk@gmail.com" awkravchuk)
     ("lockie666@gmail.com" lockie666)))
  (smtpmail-multi-default-account 'awkravchuk)
  (message-send-mail-function 'smtpmail-multi-send-it)
  (smtpmail-debug-info t)
  (smtpmail-debug-verbose t))

(put 'narrow-to-region 'disabled nil)
