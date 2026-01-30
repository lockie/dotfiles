# Agent Guide for dotfiles Repository

## Overview

This is a personal dotfiles repository containing configuration files for various Linux tools and applications. It manages shell configurations, editor setups, window managers, and application preferences.

**Important**: This is NOT a software development project with build systems or tests. It's a configuration repository intended to be symlinked or copied to a user's home directory.

## Repository Structure

```
~/
├── .emacs.d/           # Emacs configuration (use-package based)
├── .vim/               # Vim plugins and bundles (managed by pathogen)
├── .zsh/               # Zsh plugins and extensions
├── .fonts/             # Custom fonts
├── .config/            # Application configurations
│   ├── i3/            # i3 window manager config
│   ├── xmonad/        # XMonad config (Haskell)
│   ├── polybar/       # Status bar with scripts
│   ├── rofi/          # App launcher/theme
│   ├── mpv/           # Media player config
│   ├── qutebrowser/   # Browser config
│   └── ...            # Other app configs
├── .Xresources         # X11 resource file (theme settings)
├── .bash_aliases       # Shared shell aliases
├── .gitconfig          # Git configuration
├── .vimrc              # Vim configuration
├── .xprofile           # X11 session startup script
├── .zshrc              # Zsh shell configuration
└── .gitmodules         # Git submodule definitions
```

## Git Submodules

This repository uses 18 git submodules for plugins and tools:

### Vim Plugins (in `.vim/bundle/`)
- a.vim - Alternate file switching
- ack.vim - Search integration (uses ag if available)
- bufkill - Buffer management
- ctrlp.vim - Fuzzy file finder
- indentpython.vim - Python indentation
- molokai - Color theme
- nerdtree - File browser
- tagbar - Code navigation
- vim-airline + themes - Status bar
- vim-devicons - File icons
- vim-fugitive - Git integration
- vim-wakatime - Time tracking
- zenburn - Color theme

### Zsh Plugins (in `.zsh/`)
- warhol.plugin.zsh - Colorful prompt
- zsh-256color - 256-color terminal support
- zsh-background-notify - Notifications for long commands
- zsh-history-substring-search - History search
- zsh-syntax-highlighting - Syntax highlighting
- gibo - Git ignore templates

### Development Tools
- pyenv - Python version management

### Working with Submodules

After cloning the repository, initialize and update submodules:

```bash
git submodule update --init --recursive
```

To update submodules to latest versions:

```bash
git submodule update --remote
```

## Key Configurations

### Zsh (Primary Shell)

**Location**: `.zshrc`

Features:
- Vi-mode keybindings (`bindkey -v`)
- Extensive alias system with `nocorrect` prefix to prevent autocorrection
- Custom prompt with:
  - VCS status (git branch, staged/unstaged indicators)
  - Virtual environment indicator
  - Vi mode indicator (I/N for insert/normal)
  - Emoji status indicators (😄/😣 for command success/failure)
  - Current directory with color coding
- Colorized output (grc integration if available)
- History management (1M entries, ignore dups/space-prefixed)
- Auto-pushd directory stack navigation
- Custom keybindings for Home/End/Delete keys (terminal-specific)

**Note**: Contains Russian comments. Configuration checks for various Linux distributions (Gentoo, etc.) and sets appropriate prompts.

**Aliases**: Shortened commands (c=cd, l=ls, v=vim, etc.) in `.bash_aliases`

### Vim

**Location**: `.vimrc`

Key features:
- Uses pathogen for plugin management (`call pathogen#infect()`)
- Leader key set to `'` (single quote)
- Unicode support (UTF-8 encoding)
- Persistent undo history in `~/.vim/undodir/`
- 80-character column marker (colorcolumn)
- Line numbering, cursor highlighting
- Tab visualization (`listchars=tab:→→,trail:⋅`)
- Fold management (indent-based, disabled by default)
- Custom font: MonofurForPowerline Nerd Font 14
- Integrates with ag (the_silver_searcher) if available for ack.vim

**Note**: Uses Zenburn theme consistently.

### Emacs

**Location**: `.emacs.d/init.el`, `.emacs.d/early-init.el`

Features:
- Modern configuration using `use-package`
- Package sources: MELPA, NONGNU
- Zenburn theme with dark mode support
- Font: Cascadia Code NF Light-15
- Ligature support for programming symbols
- `server-start` for emacsclient integration
- `solaire-mode` for better buffer face differentiation
- `early-init.el` prevents color flashes at startup

### Window Managers

**XMonad** (`.config/xmonad/xmonad.hs`):
- Written in Haskell
- Mod4 (Super) as modifier key
- Terminal: `st`
- Tabbed and tiled layouts
- Workspace-specific layouts
- Uses Zenburn colors

**i3** (`.config/i3/config`): Alternative tiling window manager configuration

### X11 Configuration

**XResources** (`.Xresources`):
- Font antialiasing settings (Xft)
- DPI: 122
- Rofi theme (Zenburn colors)
- XTerm configuration with Terminus font
- Zenburn color palette

**XProfile** (`.xprofile`):
- Sets QT_QPA_PLATFORMTHEME to qt5ct
- Starts GPG agent with SSH support

## Package Managers

### Vim
- **Method**: pathogen (plugin loader)
- **Plugins**: Git submodules in `.vim/bundle/`
- **To add a plugin**: Add submodule and update `.gitmodules`

### Emacs
- **Method**: use-package with package.el
- **Sources**: MELPA, NONGNU
- **To add a package**: Add `(use-package package-name :ensure t ...)` to `init.el`

### Python
- **Method**: pyenv (for version management)
- **Location**: `.pyenv/` (submodule)
- **Additional**: Install pyenv-virtualenv manually

### Zsh
- **Method**: Source-based plugin loading
- **Location**: `.zsh/` directory
- **To add plugin**: Clone into `.zsh/` and source in `.zshrc`

## Common Tasks

### Setting Up on a New Machine

1. Clone repository:
   ```bash
   git clone <repo-url> ~/Progs/dotfiles
   ```

2. Initialize submodules:
   ```bash
   cd ~/Progs/dotfiles
   git submodule update --init --recursive
   ```

3. Create symlinks to home directory:
   ```bash
   ln -s ~/Progs/dotfiles/.zshrc ~/.zshrc
   ln -s ~/Progs/dotfiles/.vimrc ~/.vimrc
   ln -s ~/Progs/dotfiles/.vim ~/.vim
   ln -s ~/Progs/dotfiles/.emacs.d ~/.emacs.d
   # ... repeat for other configs
   ```

### Updating Plugins

**Vim plugins**:
```bash
git submodule update --remote .vim/bundle/<plugin-name>
```

**Zsh plugins**:
```bash
git submodule update --remote .zsh/<plugin-name>
```

**Emacs packages**:
```bash
emacs --eval="(package-refresh-contents)"
emacs --eval="(package-list-packages)"
```

### Recompiling XMonad

```bash
cd ~/.config/xmonad
xmonad --recompile
xmonad --restart
```

This can also be done via the keybinding: `Mod+Shift+r`

## Themes and Visual Consistency

**Zenburn theme** is used across multiple applications:
- Vim (`.vim/bundle/zenburn/`)
- Emacs (use-package zenburn-theme)
- XTerm (colors in `.Xresources`)

This provides a consistent low-contrast dark theme throughout the system.

## Fonts

Custom fonts in `.fonts/`:
- monofur_italic_patched.ttf
- monofur_patched.ttf

Primary fonts:
- Terminal: Terminus (TTF) 18
- Vim: MonofurForPowerline Nerd Font 14
- Emacs: Cascadia Code NF Light-15

## Git Configuration

**Location**: `.gitconfig`

Settings:
- User: Andrew Kravchuk <awkravchuk@gmail.com>
- GPG signing enabled (key: 50F6285F)
- Default branch: main
- Pull uses rebase by default
- Meld for merge tool
- Custom aliases: co, st, br, g, df, ch, c

## Aliases Reference

### Common Shortcuts (from `.bash_aliases`)
- `c` → `cd`
- `l` → `ls`
- `ll` → `ls -alhF`
- `v` → `vim`
- `ee` → `emacs -nw`
- `g` → `git`
- `dc` → `docker-compose`
- `top` → `htop` (if installed)

### Platform-Specific Aliases

**Gentoo**:
- `upd` - Complete system update and maintenance
- `updk` - Kernel compilation
- `updm` - Module rebuild

**Arch (pacman/yaourt/clyde)**:
- `upd` - Package updates

**Debian/Ubuntu (aptitude)**:
- `upd` - Update, upgrade, autoremove, clean

### Tool Aliases (with grc if available)
Many tools have colorized output via grc: ping, traceroute, gcc, make, netstat, docker, etc.

## Application-Specific Notes

### Polybar
Location: `.config/polybar/`
- Configuration file: `config`
- Helper scripts: `io.sh`, `mail.sh`, `mpris.sh`, `net.sh`, `procs.sh`, `weather.py`

### MPV
Location: `.config/mpv/`
- Configuration: `config`, `input.conf`
- Scripts: `scripts/xscreensaver.lua`

### Qutebrowser
Location: `.config/qutebrowser/`
- Python-based config: `config.py`, `autoconfig.yml`
- Greasemonkey scripts: `youtube-ads.js`
- Userscripts: `org-capture`, `search-selected`

### Zathura (PDF Viewer)
Location: `.config/zathura/`
- Config: `zathurarc`

## Important Gotchas

1. **No Installation Script**: This repository lacks a centralized setup script. Symlinking must be done manually.

2. **Russian Comments**: The `.zshrc` contains comments in Russian. When modifying, consider the context or follow existing patterns.

3. **Autocorrection**: Most aliases use `nocorrect` prefix to prevent zsh's spelling correction. Maintain this pattern for new aliases.

4. **Vi-Mode**: Zsh is configured with vi-mode by default. New keybindings should respect this (use `bindkey -M viins` and `bindkey -M vicmd`).

5. **Terminal-Specific Keybindings**: `.zshrc` has extensive keybinding configurations for different terminals (xterm, rxvt-unicode, st-256color). Test changes across terminals if used.

6. **Submodule Updates**: Vim/Zsh plugins are not automatically updated. Manual `git submodule update --remote` is required.

7. **GPG Agent**: The `.xprofile` script assumes GPG agent is available and creates it at `/tmp/gpg-agent.env`. Ensure GPG is installed before starting X sessions.

8. **Emacs Server**: Emacs starts a server automatically for emacsclient integration. This means an Emacs daemon runs in the background.

9. **Python Version Management**: pyenv-virtualenv must be installed separately as noted in README.md.

10. **Font Dependencies**: The configurations assume specific fonts are installed:
    - Terminus (TTF)
    - MonofurForPowerline Nerd Font
    - Cascadia Code NF
    - Font Awesome and Powerline symbols (for polybar)

## Development Workflow

When modifying these dotfiles:

1. **Test locally first**: Many configs affect active sessions. Reload configurations incrementally (e.g., `source ~/.zshrc`).

2. **XMonad**: Always recompile before restarting (`xmonad --recompile`).

3. **Emacs**: Changes to `init.el` are applied on restart. Use `eval-last-sexp` for immediate testing during development.

4. **Vim**: Reload with `:source ~/.vimrc` after changes.

5. **Zsh**: Reload with `source ~/.zshrc` or start a new shell.

## Backup and Version Control

The entire repository is tracked by git. The `.gitignore` files in subdirectories should preserve local state files like:
- `.vim/undodir/`
- `.vim/swap/`
- `.emacs.d/cache/` (if created)

## Additional Tools Referenced in README

The README mentions these optional tools that may be installed for full functionality:
- `grc` - Generic colouriser for logs and command output
- `the_silver_searcher` (ag) - Fast code search
- `htop` - Interactive process viewer
- `unrar/unzip/7z` - Archive tools
- `imagemagick` - Image manipulation
- `fortune` - Random quotes
- `clang` - C compiler (for Emacs LSP)
- `pyls` - Python Language Server (for Emacs LSP)
- `shellcheck` - Shell script linter (for Emacs)
- `iostat`, `xmllint` - System utilities

## No Build System or Tests

This repository has no build commands, test suite, or deployment pipeline. All configurations are source files that are read by their respective applications on startup.

## Contact and Attribution

Repository owner: Andrew Kravchuk <awkravchuk@gmail.com>

See individual plugin submodules for their respective licenses and authors.
