
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

;; Install 'use-package' if necessary
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))

;; Always download missing use-package packages
(setq use-package-always-ensure t)

(load-theme 'atom-one-dark t)

;;(initial-buffer-choice ("~/Dropbox/todo/todo.org" "~/dotfiles/emacs.d/init.org"))

(setq org-todo-keywords
       '((sequence "TODO" "IDEA" "MOVE" "WORKFLOW" "STORYX" "INFO" "TRIAGE" "JACK" "BLOG" "POST" "OPENSOURCE" "|" "TODOLOL" "INACTIVE" "REMINDER" "DONE" "BLOCKED" "SCHEDULED")))

(setq org-src-fontify-natively t)

(defun my/tangle-dotfiles ()
  "If the current file is in '~/.dotfiles', the code blocks are tangled"
  (when (equal (file-name-directory (directory-file-name buffer-file-name))
               (concat (getenv "HOME") "/dotfiles/emacs.d/"))
    (org-babel-tangle)
    (message "%s tangled" buffer-file-name)))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(global-auto-revert-mode t)

(eval-when-compile (require 'cl))
 (defun toggle-transparency ()
   (interactive)
   (if (/=
        (cadr (frame-parameter nil 'alpha))
        100)
       (set-frame-parameter nil 'alpha '(100 100))
     (set-frame-parameter nil 'alpha '(85 50))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'character)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
)

(require 'zoom-frm)
(global-set-key (kbd "s-+") 'zoom-frm-in)
(global-set-key (kbd "s-=") 'zoom-frm-in)
(global-set-key (kbd "s--") 'zoom-frm-out)
(global-set-key (kbd "s-_") 'zoom-frm-out)

;; auto-save-files not in same dir as original
(setq backup-directory-alist `(("." . "~/.emacs/auto-save-list")))

(setq ns-auto-hide-menu-bar t)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq-default indent-tabs-mode nil)

(set-frame-font "Operator Mono 12")

(set-frame-parameter (selected-frame) 'alpha '(99 . 99))
(add-to-list 'default-frame-alist '(alpha . (99 . 99)))

(setq ns-use-native-fullscreen nil)
(global-set-key (kbd "<s-return>") 'toggle-frame-fullscreen)

;; default full screen
(setq default-frame-alist
    '((fullscreen . fullboth) (fullscreen-restore . fullheight)))

;; Window movement
;; (global-set-key (kbd "C-l C-l") 'windmove-right)
;; (global-set-key (kbd "C-l l") 'windmove-right)
;; (global-set-key (kbd "C-h C-h") 'windmove-left)
;; (global-set-key (kbd "C-h h") 'windmove-left)
;; (global-set-key (kbd "C-k C-k") 'windmove-up)
;; (global-set-key (kbd "C-k k") 'windmove-up)
;; (global-set-key (kbd "C-j C-j") 'windmove-down)
;; (global-set-key (kbd "C-j j") 'windmove-down)
(global-set-key (kbd "C-l") 'windmove-right)
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-j") 'windmove-down)

;; Scrolling Settings (@wpcarro)
(setq scroll-step 1)
(setq scroll-conservatively 10000)

;; line numbers
(global-linum-mode t)

;; line wrap
(setq-default word-wrap t)
(toggle-truncate-lines -1)

(use-package evil
  :commands (evil-mode local-evil-mode)
  :bind (:map evil-motion-state-map
         ("<return>" . nil)
         ("<tab>" . nil)
         ("SPC" . nil)
         ("M-." . nil)
         ("/" . helm-swoop)
         ("*" . helm-swoop)
         ("(" . backward-sexp)
         (")" . forward-sexp)

         :map evil-normal-state-map
         ("<return>" . nil)
         ("<tab>" . nil)
         ("M-." . nil)
         ("/" . helm-swoop)
         ("*" . helm-swoop)
         ("n" . helm-swoop)
         ("C-p" . helm-projectile)

         :map evil-visual-state-map
         ("g c" . comment-or-uncomment-region)

         :map evil-ex-map
         ("e" . helm-find-files)
         ("b" . helm-buffers-list)
         ("tb" . alchemist-mix-test-this-buffer)
         ("tap" . alchemist-mix-test-at-point)
         ("lt" . alchemist-mix-rerun-last-test)
        )

  :init
  (progn
    (setq evil-default-cursor t)
    (setq evil-shift-width 2)

    (use-package evil-leader
      :init (global-evil-leader-mode)

      :config
      (progn
        (setq evil-leader/in-all-states t)

        (evil-leader/set-leader "<SPC>")

        (evil-leader/set-key
         "<SPC>" 'evil-switch-to-windows-last-buffer
         "c" 'comment-or-uncomment-region
         "n" 'neotree-find
         "k" 'kill-buffer
         "b" 'helm-mini
         "p" 'helm-mini
         "S" 'helm-projectile-ag
         "s" 'split-window-below
         "v" 'split-window-right
         "x" 'alchemist-mix
         "r" 'alchemist-mix-rerun-last-test
         "t" 'alchemist-project-toggle-file-and-tests
         "T" 'alchemist-project-toggle-file-and-tests-other-window
         "d" 'alchemist-help-search-at-point
         "=" 'balance-windows
         "a" 'ace-window
         "l" 'avy-goto-line
         ">" 'evil-window-increase-width
         "<" 'evil-window-decrease-width
         )))

    (evil-mode 1))

  :config
  (progn

    ;; esc should always quit: http://stackoverflow.com/a/10166400/61435
    (define-key evil-normal-state-map [escape] 'keyboard-quit)
    (define-key evil-visual-state-map [escape] 'keyboard-quit)
    (define-key minibuffer-local-map [escape] 'abort-recursive-edit)
    (define-key minibuffer-local-ns-map [escape] 'abort-recursive-edit)
    (define-key minibuffer-local-completion-map [escape] 'abort-recursive-edit)
    (define-key minibuffer-local-must-match-map [escape] 'abort-recursive-edit)
    (define-key minibuffer-local-isearch-map [escape] 'abort-recursive-edit)
  )
)

(use-package helm
  :bind (
    ("M-x" . helm-M-x)
    ("C-x C-f" . helm-find-files)
    ("C-x f" . helm-projectile)
    ("M-y" . helm-show-kill-ring)
    ("C-x b" . helm-mini)
    ("C-x C-b" . helm-buffers-list)

    :map helm-map
    ([tab] . helm-next-source)
    ("C-j" . helm-next-line)
    ("C-k" . helm-previous-line)
    ("C-?" . describe-key)
    ([escape] . helm-keyboard-quit)

    :map helm-find-files-map
    ("C-l" . helm-execute-persistent-action)
    ("C-h" . helm-find-files-up-one-level)
    ("C-?" . describe-key)

    :map helm-read-file-map
    ("C-l" . helm-execute-persistent-action)
    ("C-h" . helm-find-files-up-one-level)
    ("C-?" . describe-key)
  )

  :init (helm-mode 1)

  :config
  (progn
    (setq helm-buffers-fuzzy-matching t helm-recentf-fuzzy-match t)

    (setq helm-semantic-fuzzy-match t helm-imenu-fuzzy-match t)

    (setq helm-locate-fuzzy-match t)

    (add-to-list 'helm-mini-default-sources
      (helm-build-sync-source "MY ALWAYS FILES"
        :action 'helm-type-file-actions
        :candidates '(
          "~/dotfiles/emacs.d/init.org"
          "~/Dropbox/todo/todo.org"
          "~/Dropbox/Writing/writing-february-2017.org"
          "~/Dropbox/Writing/triage.org"
        )
      )
      'append)

    (use-package helm-projectile
      :config
      (progn
        (helm-projectile-on))
    )
  )
)

(use-package ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
)

(use-package avy)

(use-package ag)

(use-package helm-ag)

(use-package alchemist
  :config
    (setq alchemist-goto-elixir-source-dir "/usr/local/share/src/elixir")
    (setq alchemist-goto-erlang-source-dir "/usr/local/share/src/otp")

    (setq alchemist-test-display-compilation-output t)
    ;;(setq alchemist-hooks-test-on-save t)
    (setq alchemist-hooks-compile-on-save t)

    ;; fix to return from erlang dives
    (defun custom-erlang-mode-hook ()
        "Jump to and from Elixir, Erlang, Elixir files."
        (define-key erlang-mode-map (kbd "M-,") 'alchemist-goto-jump-back))
    (add-hook 'erlang-mode-hook 'custom-erlang-mode-hook)
)

(add-to-list 'display-buffer-alist
             `(,(rx bos (or "*alchemist test report*"
                            "*alchemist mix*"
                            "*alchemist help*"))
                    (display-buffer-reuse-window)
                    (inhibit-switch-frame t)
                    (reusable-frames . visible)))

(use-package company
  :bind ("<tab>" . company-complete-common)

  :config
  (setq company-show-numbers t)
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)

  (dotimes (i 10)
    (define-key company-active-map (kbd (format "C-%d" i)) 'company-complete-number))

  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-j") 'company-select-next)
  (define-key company-active-map (kbd "C-k") 'company-select-previous)

  (global-company-mode)
)

(use-package flycheck
  :config
  (global-flycheck-mode)

  ; Flycheck Mix Settings
  (use-package flycheck-mix
    :init
    (flycheck-mix-setup))

  ;; Flycheck Credo Settings
  (use-package flycheck-credo
    :init
    (flycheck-credo-setup))
  )

(use-package magit
  :init (progn)
  :config (progn (use-package evil-magit))
)

(use-package neotree
  :init
  (progn
    ;; Every time when the neotree window is opened, it will try to find current file and jump to node.
    (setq-default neo-smart-open t)
  )

  :config
  (progn
    ;; theme
    (setq neo-theme 'ascii)

    ;; evil mappings
    (evil-set-initial-state 'neotree-mode 'normal)

    (evil-define-key 'normal neotree-mode-map
    (kbd "RET") 'neotree-enter
    (kbd "c")   'neotree-create-node
    (kbd "r")   'neotree-rename-node
    (kbd "d")   'neotree-delete-node
    (kbd "j")   'neotree-next-line
    (kbd "k")   'neotree-previous-line
    (kbd "R")   'neotree-refresh
    (kbd "C")   'neotree-change-root
    (kbd "H")   'neotree-hidden-file-toggle
    (kbd "q")   'neotree-hide
    (kbd "s")   'neotree-enter-horizontal-split
    (kbd "v")   'neotree-enter-vertical-split
    ))

    ;; neo vc integration
    (setq neo-vc-integration '(face char))

    ;; Patch to fix vc integration
    (defun neo-vc-for-node (node)
    (let* ((backend (vc-backend node))
      (vc-state (when backend (vc-state node backend))))
      ;; (message "%s %s %s" node backend vc-state)
      (cons (cdr (assoc vc-state neo-vc-state-char-alist))
        (cl-case vc-state
          (up-to-date       neo-vc-up-to-date-face)
          (edited           neo-vc-edited-face)
          (needs-update     neo-vc-needs-update-face)
          (needs-merge      neo-vc-needs-merge-face)
          (unlocked-changes neo-vc-unlocked-changes-face)
          (added            neo-vc-added-face)
          (removed          neo-vc-removed-face)
          (conflict         neo-vc-conflict-face)
          (missing          neo-vc-missing-face)
          (ignored          neo-vc-ignored-face)
          (unregistered     neo-vc-unregistered-face)
          (user             neo-vc-user-face)
          (t                neo-vc-default-face)))))
  )

(use-package projectile
  :config
  (progn
    (setq projectile-switch-project-action 'projectile-find-file)
    (projectile-mode)
  )
)

(use-package helm-swoop
  :bind (
    :map helm-swoop-map
    ([tab] . helm-next-line)
    ([backtab] . helm-previous-line)
  )

  :config
    ;; If this value is t, split window inside the current window
    (setq helm-swoop-split-with-multiple-windows nil)

    ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
    (setq helm-swoop-split-direction 'split-window-vertically)

    ;; If there is no symbol at the cursor, use the last used words instead.
    (setq helm-swoop-pre-input-function
      (lambda ()
        (let (($pre-input (thing-at-point 'symbol)))
          (if (eq (length $pre-input) 0)
              helm-swoop-pattern ;; this variable keeps the last used words
            $pre-input))))
)
