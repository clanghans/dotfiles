;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a "Module Index" link where you'll find
;;      a comprehensive list of Doom's modules and what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

;; very early config because it has to be loaded before evil
(use-package-hook! evil
  :pre-init
  (setq evil-respect-visual-line-mode t) ;; sane j and k behavior
  t)

(doom! :input
       ;;chinese
       ;;japanese
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       company
       ;;helm
       ;;ido
       (ivy
        +fuzzy
        +prescient
        +icons)

       :ui
       ;;deft
       doom
       doom-dashboard
       doom-quit
       ;;(emoji +unicode)
       ;;fill-column
       hl-todo
       ;;hydra
       indent-guides
       ;; ligatures
       ;;minimap
       (modeline +light)
       nav-flash
       ;;neotree
       ophints
       (popup +defaults)
       ;;tabs
       ;;treemacs
       ;;unicode
       vc-gutter
       vi-tilde-fringe
       ;; window-select
       workspaces
       ;;zen

       :editor
       (evil +everywhere
             +evil-want-o/O-to-continue-comments nil
             )
       file-templates
       fold
       format
       ;;god
       ;;lispy
       ;;multiple-cursors
       ;;objed
       ;;parinfer
       ;;rotate-text
       snippets
       word-wrap

       :emacs
       dired
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       ;;eshell
       ;;shell
       term
       ;;vterm

       :checkers
       syntax
       ;;spell
       ;;grammar

       :tools
       ;;ansible
       (debugger)
       ;;direnv
       ;;docker
       ;;editorconfig
       ;;ein
       (eval +overlay)
       ;;gist
       (lookup +docsets)
       lsp
       magit
       make
       ;;pass
       ;;pdf
       ;;prodigy
       ;;rgb
       ;;taskrunner
       ;;terraform
       ;;tmux
       ;;upload

       :os
       ;; (:if IS-MAC macos)
       ;;tty

       :lang
       ;;agda
       (cc +lsp)
       ;;clojure
       common-lisp
       ;;coq
       ;;crystal
       ;;csharp
       data
       ;;(dart +flutter)
       ;;elixir
       ;;elm
       emacs-lisp
       ;;erlang
       ;;ess
       ;;faust
       ;;fsharp
       ;;fstar
       ;;gdscript
       ;;(go +lsp)
       ;;(haskell +dante)
       ;;hy
       ;;idris
       json
       ;;(java +meghanada)
       ;;javascript
       ;;julia
       ;;kotlin
       latex
       ;;lean
       ;;factor
       ;;ledger
       ;;lua
       markdown
       ;;nim
       ;;nix
       ;;ocaml
       (org
        +brain
        +gnuplot
        +hugo
        +pretty)

       ;;php
       plantuml
       ;;purescript
       python
       ;;qt
       ;;racket
       ;;raku
       ;;rest
       ;;rst
       ;;(ruby +rails)
       ;;rust
       ;;scala
       ;;scheme
       sh
       ;;sml
       ;;solidity
       ;;swift
       ;;terra
       ;;web
       yaml

       :email
       ;;(mu4e +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       ;;irc
       ;;(rss +org)
       ;;twitter

       :config
       ;;literate
       (default +bindings +smartparens))

