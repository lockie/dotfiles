;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
;; NOTE : this config requires Emacs 25+

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     auto-completion
     ;better-defaults
     emacs-lisp
     git
     ;org
     (shell :variables
            shell-default-shell 'ansi-term
            shell-default-position 'right)
     (spell-checking :variables
                     spell-checking-enable-by-default nil)
     (syntax-checking :variables syntax-checking-enable-tooltips nil)
     version-control

     (c-c++ :variables c-c++-enable-clang-support t)
     python
     html
     (javascript :variables javascript-disable-tern-port-files nil)
     markdown
     chrome
     latex
     lua
     racket
     shell-scripts
     vimscript
     yaml
     semantic
     cscope
     imenu-list
     nginx
     (wakatime :variables
               wakatime-cli-path "~/.local/bin/wakatime")
     emoji
     colors
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(;smart-tabs-mode
                                      undohist
                                      dockerfile-mode
                                      highlight-symbol
                                      howdoi
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(exec-path-from-shell
                                    rainbow-identifiers
                                    color-identifiers
                                    nyan-mode
                                    smartparens
                                    ;; for performance sake...
                                    auto-yasnippet
                                    yapfify
                                    )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(zenburn)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Anonymous Pro"
                               :size 16
                               :weight normal
                               :width normal
                               :powerline-scale 1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ";"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title nil
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers t
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'nil
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server t
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

  ;; fix PATH
  (add-to-list 'exec-path (expand-file-name "~/.npm/bin"))
  (add-to-list 'exec-path (expand-file-name "~/.luarocks/bin"))
  (add-to-list 'exec-path (expand-file-name "~/.local/bin"))
  (add-to-list 'exec-path (expand-file-name "~/bin"))

  ;; prevent long lines degrading performance
  (setq-default bidi-display-reordering nil)

  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; sign :3
  (setq user-full-name   "Andrew Kravchuk")
  (setq user-mail-adress "awkravchuk@gmail.com")

  ;; keybindings
  (unbind-key "<f1>")
  (defun save-all ()
    (interactive)
    (save-some-buffers t)
  )
  (define-key evil-normal-state-map (kbd "<f2>") 'save-all)
  (define-key evil-insert-state-map (kbd "<f2>") 'save-all)
  (define-key evil-normal-state-map (kbd "<f3>") 'projectile-find-other-file)
  (define-key evil-insert-state-map (kbd "<f3>") 'projectile-find-other-file)
  (define-key evil-normal-state-map (kbd "<f4>") 'spacemacs/helm-files-smart-do-search-region-or-symbol)
  (define-key evil-insert-state-map (kbd "<f4>") 'spacemacs/helm-files-smart-do-search-region-or-symbol)
  ; TODO : setup compilation
  (define-key evil-normal-state-map (kbd "<f5>") 'compile)
  (define-key evil-insert-state-map (kbd "<f5>") 'compile)
  (define-key evil-normal-state-map (kbd "<f6>") 'imenu-list-minor-mode)
  (define-key evil-insert-state-map (kbd "<f6>") 'imenu-list-minor-mode)
  (define-key evil-normal-state-map (kbd "<f10>") 'spacemacs/prompt-kill-emacs)
  (define-key evil-insert-state-map (kbd "<f10>") 'spacemacs/prompt-kill-emacs)
  (define-key evil-normal-state-map (kbd "<f12>") 'neotree-toggle)
  (define-key evil-insert-state-map (kbd "<f12>") 'neotree-toggle)

  (defun clang-format-bindings ()
    (spacemacs/set-leader-keys "m f" 'clang-format-buffer))
  (add-hook 'c++-mode-hook 'clang-format-bindings)
  (add-hook 'c-mode-hook 'clang-format-bindings)

  (spacemacs/set-leader-keys "<left>" 'evil-window-left)
  (spacemacs/set-leader-keys "<right>" 'evil-window-right)
  (spacemacs/set-leader-keys "<up>" 'evil-window-up)
  (spacemacs/set-leader-keys "<down>" 'evil-window-down)

  (define-key evil-normal-state-map (kbd "M-n") 'highlight-symbol-next)
  (define-key evil-insert-state-map (kbd "M-n") 'highlight-symbol-next)
  (define-key evil-normal-state-map (kbd "M-p") 'highlight-symbol-prev)
  (define-key evil-insert-state-map (kbd "M-p") 'highlight-symbol-prev)

  (spacemacs/set-leader-keys "h h" 'howdoi-query-insert-code-snippet-at-point)

  ;; fix :bd so that it closes buffer, not the window
  (evil-ex-define-cmd "bdelete" 'spacemacs/kill-this-buffer)

  ;; scroll tweaks
  (setq scroll-margin 7)
  (setq mouse-wheel-progressive-speed nil)

  ;; persistent undo
  (require 'undohist)
  (setq undohist-directory   (expand-file-name
                              (concat
                               (if (boundp 'user-emacs-directory)
                                   user-emacs-directory
                                 "~/.emacs.d")
                               ".cache/undohist")))
  (undohist-initialize)

  ;; ruler at column 80
  (add-hook 'prog-mode-hook #'fci-mode)

  ;; highlight trailing whitespace
  (require 'whitespace)
  (setq-default whitespace-style '(face trailing tab-mark))
  (setq whitespace-display-mappings
        '((tab-mark   ?\t   [?\x2192?\x2192] [?\\ ?\t]))
   )
  (global-whitespace-mode 1)

  ;; load build dir from dir locals
  (put 'helm-make-build-dir 'safe-local-variable 'stringp)

  ;; indentaion
  (setq-default tab-width 4)
  (setq-default standart-indent 4)
  (setq-default c-basic-offset 4)
  (setq-default c-default-style "bsd")
  (setq-default js-indent-level 4)
  (setq-default js2-basic-offset 4)
  (setq-default lisp-body-indent 4)
  (setq-default indent-tabs-mode nil)
  ;(smart-tabs-insinuate 'c 'c++ 'javascript)
  ;(add-hook 'c-mode-common-hook
  ;          (lambda () (setq indent-tabs-mode t)))
  ;(add-hook 'c++-mode-common-hook
  ;          (lambda () (setq indent-tabs-mode t)))
  ;(add-hook 'javascript-mode-common-hook
  ;          (lambda () (setq indent-tabs-mode t)))
  ; TODO : deal with smart-tabs T_T

  ;; make TAB behave in python mode
  (add-hook 'python-mode-hook
            (lambda () (setq indent-line-function 'python-indent-line)))

  ;; fix slow elisp autocomplete
  (use-package semantic
    :config
    (setq-mode-local emacs-lisp-mode
                     semanticdb-find-default-throttle
                     (default-value 'semanticdb-find-default-throttle)))

  ;; markdown preview
  (use-package markdown-mode
    :config (setq markdown-command "markdown2 -x code-friendly,cuddled-lists,fenced-code-blocks,header-ids,tables"))
  (eval-after-load "markdown-mode"
    '(defalias 'markdown-add-xhtml-header-and-footer 'as/markdown-add-xhtml-header-and-footer))
  ;; no edit server plz
  (defun chrome/init-edit-server () ())
  ;; markdown proper encoding
  (defun as/markdown-add-xhtml-header-and-footer (title)
    "Wrap XHTML header and footer with given TITLE around current buffer."
    (goto-char (point-min))
    (insert "<!DOCTYPE html5>\n"
            "<html>\n"
            "<head>\n<title>")
    (insert title)
    (insert "</title>\n")
    (insert "<meta charset=\"utf-8\" />\n")
    (when (> (length markdown-css-paths) 0)
      (insert (mapconcat 'markdown-stylesheet-link-string markdown-css-paths "\n")))
    (insert "\n</head>\n\n"
            "<body>\n\n")
    (goto-char (point-max))
    (insert "\n"
            "</body>\n"
            "</html>\n"))

  ;; latex autoupdate
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)

  ;; git integration
  (global-git-commit-mode t)

  ;; colorize hex codes
  (add-hook 'html-mode-hook #'rainbow-mode)
  (add-hook 'css-mode-hook #'rainbow-mode)

  ;; window title
  (setq-default frame-title-format
                '(:eval
                  (format "%s%s %s- spacemacs"
                          (if (buffer-modified-p)
                            (cond
                              (buffer-file-truename "*")
                              (t ""))
                            ""
                            )
                          (buffer-name)
                          (cond
                           (buffer-file-truename
                            (concat "(" default-directory ") "))
                           (dired-directory
                            (concat "(" dired-directory ") "))
                           (t
                            "")))))

  ;; identifiers list
  (setq imenu-list-auto-resize nil)

  ;; Dockerfile mode
  (require 'dockerfile-mode)
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
  (put 'docker-image-name 'safe-local-variable 'stringp)

  ;; omit __pycache__ files
  (eval-after-load "dired-mode"
    '(setq dired-omit-files (concat dired-omit-files
                                 "\\|^\\..+$\\|\\.pyc$|^__pycache__$")))

  ;; be more like Vi and include underscores in word motions
  (add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

  ;; use both system clipboards
  (setq x-select-enable-clipboard t)
  (setq x-select-enable-primary t)
  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

  ;; highlight parenthesis
  (show-paren-mode t)
  (add-hook 'prog-mode-hook
            (lambda ()
              (when (> (buffer-size) 40000)
                (turn-off-show-smartparens-mode))))

  ;; более лучшая отрисовка буфера
  (setq redisplay-dont-pause t)

  ;; dont create ugly .# lock files
  (setq create-lockfiles nil)

  ;; use only echo area for questions
  (setq use-dialog-box nil)

  ;; highlight current symbol, like in Notepad++
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  (setq highlight-symbol-idle-delay 0.3)
  (setq highlight-symbol-highlight-single-occurrence nil)

  ;; make zsh behave; see https://git.io/v5inm
  (evil-set-initial-state 'term-mode 'emacs)
  (push 'term-mode evil-escape-excluded-major-modes)
  (evil-define-key 'emacs term-raw-map (kbd "C-c") 'term-send-raw)
  (evil-define-key 'emacs term-raw-map (kbd "ESC") 'term-send-raw)
  ;; also make proper width for shell
  (defun launch-shell ()
      (interactive)
      (spacemacs/default-pop-shell)
      (balance-windows))
  (spacemacs/set-leader-keys "'" 'launch-shell)

  ;; fix bug "Symbol’s value as variable is void: helm-bookmark-map" https://git.io/v5iFG
  (require 'helm-bookmark)

  ;; use magit in fullscreen, see http://whattheemacsd.com/setup-magit.el-01.html
  (defadvice magit-status (around magit-fullscreen activate)
      (window-configuration-to-register :magit-fullscreen)
      ad-do-it
      (delete-other-windows))
  (defun magit-quit-session ()
      "Restores the previous window configuration and kills the magit buffer"
      (interactive)
      (kill-buffer)
      (jump-to-register :magit-fullscreen))
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

  ;; neat statusline
  (spacemacs|diminish highlight-symbol-mode)
  (spacemacs|diminish wakatime-mode "⌚")
  (setq powerline-default-separator 'arrow)


  ;; TODO : figure out HTML editing, turn off snippets for it

  ;; TODO : https://github.com/bmag/emacs-purpose ?? https://github.com/ecb-home/ecb ??

  ;; TODO : ormode for notes + org-capture for todo-list of current project

  ;; TODO : pomodoro? https://github.com/TatriX/pomidor  ? org-pomodoro ?

  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-commit-arguments (quote ("--gpg-sign=B8A851BA50F6285F")))
 '(package-selected-packages
   (quote
    (howdoi flyspell-popup flyspell-correct-helm flyspell-correct auto-dictionary highlight-symbol gmail-message-mode ham-mode html-to-markdown flymd edit-server mmm-mode markdown-toc markdown-mode gh-md dockerfile-mode yaml-mode vimrc-mode dactyl-mode undohist smart-tabs-mode rainbow-mode rainbow-identifiers color-identifiers-mode wakatime-mode nginx-mode imenu-list zeal-at-point helm-dash helm-cscope xcscope insert-shebang fish-mode company-shell racket-mode faceup lua-mode company-auctex auctex-latexmk auctex web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern dash-functional tern coffee-mode web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data emoji-cheat-sheet-plus company-emoji disaster company-c-headers cmake-mode clang-format stickyfunc-enhance srefactor yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode helm-pydoc cython-mode company-anaconda anaconda-mode pythonic xterm-color smeargle shell-pop orgit multi-term magit-gitflow helm-gitignore helm-company helm-c-yasnippet gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter fuzzy flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor eshell-z eshell-prompt-extras esh-help diff-hl company-statistics company auto-yasnippet yasnippet ac-ispell auto-complete ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint info+ indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump f s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed dash aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#DCDCCC" :background "#3F3F3F")))))
