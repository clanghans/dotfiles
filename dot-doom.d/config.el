;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Chris Langhans"
      user-mail-address "chris@langhans-coding.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 13)
      doom-variable-pitch-font (font-spec :family "Source Code Pro"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-acario-dark)
;; (setq doom-theme 'doom-monokai)
;; (setq doom-theme 'doom-dark+)
;; (setq doom-theme 'doom-material)
;; (setq doom-theme 'doom-nord)
(setq doom-theme 'doom-palenight)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(setq doom-modeline-workspace-name t)

;; display perspective in modeline
(after! doom-modeline
  (setq doom-modeline-persp-name t)
  )

(after! persp-mode
  (setq +workspaces-on-switch-project-behavior nil)
  )

(map!
 (:leader
  :desc "M-x" "SPC" #'counsel-M-x
  )
 (:leader
  :prefix ("j" . "jump")
  :desc "+default/search-buffer" "s" #'+default/search-buffer
  :desc "avy-goto-char-timer" "j" #'avy-goto-char-timer
  )
 (:leader
  :prefix "w"
  :desc "delete-other-window" "1" #'delete-other-windows
  ;; :desc "V"
  )
 )

(after! magit
  (setq magit-save-repository-buffers 'dontask
        magit-repository-directories '(("~/Workspace/" . 3))
        )
  )

(after! org
  (setq org-bullets-bullet-list '("#"))
  )

;; Interesting packages
;; carbon-now-sh

(setq-hook! 'cmake-mode-hook
  cmake-tab-width 4
  +format-with-lsp nil
  )

;; (use-package! tree-sitter
;;   :config
;;   (require 'tree-sitter-langs)
;;   ;; (global-tree-sitter-mode)
;;   ;; (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;   (add-hook 'c-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'c++-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'go-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'java-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'html-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'js-mode-hook #'tree-sitter-hl-mode)
;;   (add-hook 'rust-mode-hook #'tree-sitter-hl-mode)
;; )

;; LSP with clangd
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;; (after! ccls
;;   (setq ccls-initialization-options
;;         (append ccls-initialization-options
;;                 `(:clang, (list :extraArgs [""]
;;                                 :resourceDir (cdr (doom-call-process "clang" "-print-resource-dir")))))))

;; disable code formatting in specific modes
(setq +format-on-save-enabled-modes
      '(not cmake-mode)
      )

;; always recenter on going off screen
;; (setq scroll-conservatively 0)
(setq scroll-margin 5
      which-key-idle-delay 0.3
      require-final-newline t
      ;; raise undo limit to 100MB
      undo-limit 100000000
      ;; nobody wants to loose changes
      auto-save-default t)

(global-so-long-mode -1)
(global-visual-line-mode 1)

(setq evil-escape-unordered-key-sequence t
      ;; evil search commands cross line endings
      evil-cross-lines t
      ;; don't move cursor when exiting insert mode
      evil-move-cursor-back nil
      evil-vsplit-window-right t
      evil-split-window-below t
      evil-want-fine-undo t)

(after! projectile
  ;; recursively ignore projects
  (setq projectile-ignored-projects '("~/" "~/.emacs.d/.local/straight/repos/" "/tmp"))
  (defun projectile-ignored-project-function (filepath)
    "Return t if FILEPATH is wihtin any of 'projectile-ignored-projects'"
    (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))
  )

;; Flycheck
(after! flycheck
  (setq-default flycheck-disabled-checkers '(python-flake8))
  )

;; company
(after! company
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

;; whitespace wars
(require 'ws-butler)
(add-hook 'prog-mode-hook #'ws-butler-mode)

;; docsets
(set-docsets! 'python-mode "Python_3")
(set-docsets! 'sh-mode "Bash")
(set-docsets! '(c-mode c++-mode) "C" "C++")
(set-docsets! 'cmake-mode "CMake")
(set-lookup-handlers! '(c-mode c++-mode)
  :documentation #'+lookup/documentation)

(setq +lookup-open-url-fn #'eww)

(after! ivy
  (setq ivy-more-chars-alist
        '((counsel-rg . 3)
          (counsel-search . 2)
          (t . 3))))

(after! swiper
  (setq swiper-goto-start-of-match t))

(after! lsp-ui
  (setq lsp-enable-file-watchers nil)
  (setq lsp-diagnostics-provider :none)
  (setq lsp-lens-enable nil))

;; Yasnippet hacks
;; '(warning-suppress-types
;;   '(((yasnippet backquote-change))))

;; compilation buffer
(set-popup-rule! "^\\*compilation" :side 'bottom :size 0.5 :select nil :ttl 0)

;; PLANTUML
(set-popup-rule! "^\\*PLANTUML" :side 'right :size 0.5 :select nil :ttl 0)
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

(defun clanghans/c-mode-setup ()
  "Ran in c-mode-hook"
        (add-hook 'auto-save-hook
                #'clanghans/compile-command-link nil t)
)

(defun clanghans/compile-command-link ()
  (interactive)
  "Create a symbolic link from the root directory to the compile-command.json file."
  (when (projectile-project-p)
    (let*((cc-json "compile_commands.json")
          ;; find file in project root - recursive
          (target (directory-files-recursively (projectile-project-root) cc-json)))
      ;; only enter if compile command was found
      (when target
        ;; creating the symbolic link
        (make-symbolic-link (file-relative-name (car target) (projectile-project-root)) (concat (projectile-project-root) cc-json) t)
        )
      )
    )
  )

(defun clanghans/copy-azure-link-at-point ()
  (interactive)
  "Create a external link to the code in AzureDevops"
  ;; "<remote-url>?path=/<fp>&version=GB<branch>&line=<line>&lineEnd=<next-line>&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents"
  (let*(
        (remote-url (replace-regexp-in-string "https://.*@" "https://"
                                              (magit-get "remote" (magit-get-some-remote) "url")))
        (branch (magit-get-current-branch))
        (fp (file-relative-name buffer-file-name (projectile-project-root)))
        (line (line-number-at-pos))
        (next-line (1+ line))

        (url (concat remote-url "?path=/" fp "&version=GB" branch "&line=" (number-to-string line) "&lineEnd=" (number-to-string next-line) "&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents"))
        )
                                        ; put the string into the kill ring
    (kill-new url)
    )
  )

(defun clanghans/gdbmi-bnf-target-stream-output (c-string)
  "Change behavior for GDB/MI target the target-stream-output so that it is displayed to the console."
  (gdb-console c-string)
  )

(advice-add 'gdbmi-bnf-target-stream-output :override 'clanghans/gdbmi-bnf-target-stream-output)

(add-hook 'c-mode-common-hook
          #'clanghans/c-mode-setup())
