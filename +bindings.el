;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

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
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.
This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" "" (shell-command-to-string
                                          "$SHELL --login -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(defun set-exec-path-from-shell-JVMOPTS ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.
This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" "" (shell-command-to-string
                                          "$SHELL --login -c 'echo $JVM_OPTS'"))))
    (setenv "JVM_OPTS" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-JVMOPTS)
(set-exec-path-from-shell-PATH)

;; HACK from xref
(defcustom xref-marker-ring-length 16
  "Length of the xref marker ring.
If this variable is not set through Customize, you must call
`xref-set-marker-ring-length' for changes to take effect."
  :type 'integer
  :initialize #'custom-initialize-default
  :set #'xref-set-marker-ring-length)

(defvar xref--marker-ring (make-ring xref-marker-ring-length)
  "Ring of markers to implement the marker stack.")

(setq doom-font-increment 1)
(setq doom-big-font-increment 2)
;; (doom/increase-font-size 2)

;; MAC
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'control)
  (setq mac-control-modifier 'super))

(setq +format-on-save-enabled-modes
      `(not emacs-lisp-mode sql-mode tex-mode latex-mode org-msg-edit-mode clojure-mode))

;; (global-set-key (kbd "s-o") 'other-frame)
(global-set-key (kbd "<s-escape>") (lambda () (interactive) (switch-to-buffer "*scratch*")))

(global-set-key (kbd "s-[") 'shrink-window-horizontally)
(global-set-key (kbd "s-{") 'shrink-window)
(global-set-key (kbd "s-]") 'enlarge-window-horizontally)
(global-set-key (kbd "s-}") 'enlarge-window)

;; move visible buffer directionally
(global-set-key (kbd "<C-S-up>") #'buf-move-up)
(global-set-key (kbd "<C-S-down>") #'buf-move-down)
(global-set-key (kbd "<C-S-left>") #'buf-move-left)
(global-set-key (kbd "<C-S-right>") #'buf-move-right)

;; (setq lsp-java-server-install-dir "/Users/zacharyteowj/OneDrive - DBS Bank Ltd/Emacs/bin/lsp/jdt-language-server-1.5.0-202110191539/")

;; (setq lsp-java-java-path "/Users/zacharyteowj/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home/bin/java")

;; (savehist-mode)

;; toggle flycheck on and off

(map! "C-z" nil)
(setq iedit-toggle-key-default nil)
(setq-default indent-tabs-mode nil)

;;(setq doom-localleader-alt-key "C-z")
(global-set-key (kbd "<f5>") 'revert-buffer)

;; Not sure if i want this
(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))

;; Backups
;; Settled by doom in .local/cache/backup
;;
;; (defvar --backup-directory (concat user-emacs-directory "backups"))
;; (if (not (file-exists-p --backup-directory))
;;        (make-directory --backup-directory t))
;; (setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t         ; backup of a file the first time it is saved.
      backup-by-copying t         ; don't clobber symlinks
      version-control t           ; version numbers for backup files
      vc-make-backup-files t      ; backup versioned files (git?)
      delete-old-versions t       ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6 ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9 ; newest versions to keep when a new numbered backup is made (default: 2)
      )

;; No persistent undo history
;; (remove-hook 'undo-fu-mode-hook #'global-undo-fu-session-mode)

(use-package! windmove
  :config
  (windmove-default-keybindings)
  ;; Make windmove work in Org mode:
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right))

;; To consider removing
(use-package! swiper
  :bind ("C-s" . swiper)
        ("C-r" . swiper))

(use-package! undo-fu
  :bind ("C-?" . undo-fu-only-redo))

(use-package! aggressive-indent
  :hook
  (clojure-mode . aggressive-indent-mode))

(use-package! kibit-helper
  :bind ("C-x C-'" . kibit-accept-proposed-change))

(use-package! clojure-essential-ref-nov
  :after cider
  :init
  (setq clojure-essential-ref-nov-epub-path "~/Dropbox/Books/Clojure_The_Essential_Reference_v29_MEAP.epub")
  :bind (
         :map cider-mode-map
         ("C-c C-d C-r" . clojure-essential-ref)
         ("C-c C-d r" . clojure-essential-ref-nov)
         :map cider-repl-mode-map
         ("C-c C-d C-r" . clojure-essential-ref)))

(use-package! cider
  :bind ("C-c C-e" . cider-pprint-eval-defun-to-comment)
  :config
  ;; (setq nrepl-log-messages t)
  (setq nrepl-use-ssh-fallback-for-remote-hosts t)
  (setq cider-enrich-classpath t)
  (setq cider-jdk-src-paths '("~/java/clojure-1.11.1-sources"
                              "~/java/zulujvm-11-src"))
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  ;; (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  ;; (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  )

(after! clojure-mode
;;; (define-clojure-indent
  ;;   (PUT 2)
  ;;   (POST 2)
  ;;   (GET 2)
  ;;   (PATCH 2)
  ;;   (DELETE 2)
  ;;   (context 2)
  ;;   (for-all 2)
  ;;   (checking 3)
  ;;   (>defn :defn)
  ;;   (>defn- :defn)
  ;;   (match 1)
  ;;   (cond 0)
  ;;   (case 1)
  ;;   (describe 1)
  ;;   (it 2)
  ;;   (fn-traced :defn)
  ;;   (defn-traced :defn)
  ;;   (assert-match 1))
  (add-to-list 'clojure-align-binding-forms "let-flow")
  ;; (setq clojure-indent-style 'align-arguments)
  (setq clojure-indent-style 'always-align)
  ;; (setq clojure-indent-style 'always-indent)
  ;; (setq cider-default-cljs-repl 'shadow)
  (put '>defn 'clojure-doc-string-elt 2)
  (put '>defn- 'clojure-doc-string-elt 2)
  (put 'defsys 'clojure-doc-string-elt 2)
  (put 'defn-traced 'clojure-doc-string-elt 2)
  ;; (setq clojure-align-forms-automatically t)

  ;; See if i use below
  (setq cljr-magic-require-namespaces
        '(("io" . "clojure.java.io")
          ("sh" . "clojure.java.shell")
          ("jdbc" . "clojure.java.jdbc")
          ("set" . "clojure.set")
          ("time" . "java-time")
          ("str" . "cuerdas.core")
          ("path" . "pathetic.core")
          ("walk" . "clojure.walk")
          ("zip" . "clojure.zip")
          ("async" . "clojure.core.async")
          ("component" . "com.stuartsierra.component")
          ("http" . "clj-http.client")
          ("url" . "cemerick.url")
          ("sql" . "honeysql.core")
          ("csv" . "clojure.data.csv")
          ("json" . "cheshire.core")
          ("s" . "clojure.spec.alpha")
          ("fs" . "me.raynes.fs")
          ("ig" . "integrant.core")
          ("cp" . "com.climate.claypoole")
          ("re-frame" . "re-frame.core")
          ("rf" . "re-frame.core")
          ("rf.db" . "re-frame.db")
          ("re" . "reagent.core")
          ("reagent" . "reagent.core")
          ("w" . "wing.core")
          ("gen" . "clojure.spec.gen.alpha"))))

(use-package! magit
  :bind ("C-c g" . magit-file-dispatch))

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((clojure . t)
   (emacs-lisp . t)))

(require 'org)
(require 'ob-clojure)

(setq org-babel-clojure-backend 'cider)
(require 'cider)

;; For more intense debugging

;; (defun doom--backtrace ()
;;   (let* ((n 0)
;;          (frame (backtrace-frame n))
;;          (frame-list nil)
;;          (in-program-stack nil))
;;     (while frame
;;       (when in-program-stack
;;         (push (cdr frame) frame-list))
;;       (when (eq (elt frame 1) 'doom-debugger)
;;         (setq in-program-stack t))
;;       (setq n (1+ n)
;;             frame (backtrace-frame n)))
;;     (reverse frame-list)))

;; (defun doom-debugger (error data)
;;   "A custom debugger for `debugger'.
;; Writes the backtrace to another buffer, in case it is lost for whatever reason."
;;   (with-current-buffer (get-buffer-create "*rescued-backtrace*")
;;     (let ((standard-output (current-buffer)))
;;       (prin1 error)
;;       (prin1 data)
;;       (mapc #'print (doom--backtrace)))
;;     (kill-new (buffer-string))
;;     (message "Backtrace copied to your clipboard"))
;;   (debug error data))

;; (setq debugger #'doom-debugger)

;; (toggle-debug-on-error)
