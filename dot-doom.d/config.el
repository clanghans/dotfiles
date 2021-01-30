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
(setq display-line-numbers-type nil)


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
  :desc "delete-other-window" "1" #'delete-other
  ;; :desc "V"
  )
 (:leader
  :prefix "o"
  :desc "org-brain-visualize" "v" #'org-brain-visualize
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

(after! org-brain
  (map! :map org-brain-visualize-mode-map
        :desc "which-key" "?" #'which-key-show-major-mode
        :desc "which-key" "SPC" #'which-key-show-major-mode
        )

  (setq org-brain-path "~/org/brain"
        org-brain-scan-for-header-entries nil)
  (evil-set-initial-state 'org-brain-visualize-mode 'emacs)
  )

;; (setq-default cmake-tab-width 4)
;; (setq-default c-basic-offset 4)
(setq-hook! 'cmake-mode-hook
  cmake-tab-width 4
  +format-with-lsp nil
  )

;; (after! ccls
;;   (setq ccls-initialization-options
;;         (append ccls-initialization-options
;;                 `(:clang, (list :extraArgs [""]
;;                                 :resourceDir (cdr (doom-call-process "clang" "-print-resource-dir")))))))


(setq-hook! 'cmake-mode-hook
  cmake-tab-width 4
  c-basic-offset 4)

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

(global-subword-mode 1)
(+global-word-wrap-mode +1)

(setq evil-escape-unordered-key-sequence t
      ;; evil search commands cross line endings
      evil-cross-lines t
      ;; don't move cursor when exiting insert mode
      evil-move-cursor-back nil
      evil-vsplit-window-right t
      evil-split-window-below t
      evil-want-fine-undo t)

;; recursively ignore projects
(setq projectile-ignored-projects '("~/" "~/.emacs.d/.local/straight/repos/" "/tmp"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is wihtin any of 'projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))

;; whitespace wars
(require 'ws-butler)
(add-hook 'prog-mode-hook #'ws-butler-mode)

;; counsel-dash
(require 'counsel-dash)
(setq +lookup-open-url-fn #'eww)
;; (set-docsets! 'js2-mode "JavaScript" "JQuery")
;; ;; Add docsets to minor modes by starting DOCSETS with :add
;; (set-docsets! 'rjsx-mode :add "React")
;; ;; Or remove docsets from minor modes
;; (set-docsets! 'nodejs-mode :remove "JQuery")

(after! ivy
  (setq ivy-more-chars-alist
        '((counsel-rg . 3)
          (counsel-search . 2)
          (t . 3)))
  )

(after! swiper
  (setq swiper-goto-start-of-match t))

(after! lsp-mode
  :config
  (setq lsp-diagnostics-provider :none)
  )

;;
;; clangd
;;
(defun clanghans/compile-command-link ()
  (interactive)
  "Create a symbolic link from the root directory to the compile-command.json file."
  (when (projectile-project-p)
    (defconst clanghans/cc_json "compile_commands.json")
    ;; find file in project root - recursive
    (defconst clanghans/target
      (directory-files-recursively (projectile-project-root) clanghans/cc_json))
    ;; full path to relative
    (defconst clanghans/relative-target
      (file-relative-name (car clanghans/target) (projectile-project-root)))
    ;; creating the symbolic link
    (make-symbolic-link clanghans/relative-target (concat (projectile-project-root) clanghans/cc_json) t)
    )
  )
