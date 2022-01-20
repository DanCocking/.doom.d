;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)
;; (setq doom-font (font-spec : family "SauceCodePro Nerd Font Mono" : size 15))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq projectile-project-search-path '("~/.config/" "~/Projects/"))

;; simple settings

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-margin 2)                            ; It's nice to maintain a little margin

;; (display-time-mode 1)                             ; Enable time in the mode-line

;; (unless (string-match-p "^Power N/A" (battery))   ; On laptops...
;;   (display-battery-mode 1))                       ; it's nice to know how much power you have

;; (global-subword-mode 1)                           ; Iterate through CamelCase words


;; setting line number shit
(setq display-line-numbers-type 'relative)
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



(setq which-key-idle-delay 0.25)
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(after! company
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1)
  (setq company-show-quick-access t))


(setq yas-triggers-in-field t)

(use-package! string-inflection
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (map! :leader :prefix ("c~" . "naming convention")
        :desc "cycle" "~" #'string-inflection-all-cycle
        :desc "toggle" "t" #'string-inflection-toggle
        :desc "CamelCase" "c" #'string-inflection-camelcase
        :desc "downCase" "d" #'string-inflection-lower-camelcase
        :desc "kebab-case" "k" #'string-inflection-kebab-case
        :desc "under_score" "_" #'string-inflection-underscore
        :desc "Upper_Score" "u" #'string-inflection-capital-underscore
        :desc "UP_CASE" "U" #'string-inflection-upcase)
  (after! evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (define-key evil-normal-state-map (kbd "g~") 'evil-operator-string-inflection)))

;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(map! "C-/" #'+comment-line)

(use-package! key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-one-key-delay 0.20 ; same key (e.g. xx)
        key-chord-two-keys-delay 0.05))
(after! key-chord

  (key-chord-define-global "fj" 'send-doom-leader)
  (key-chord-define-global "gh" 'send-doom-local-leader)

  (setq dk-keymap (make-sparse-keymap))
  (setq sl-keymap (make-sparse-keymap))

  (key-chord-define-global "dk" dk-keymap)
  (key-chord-define-global "sl" sl-keymap)

  (defun add-to-keymap (keymap bindings)
    (dolist (binding bindings)
      (define-key keymap (kbd (car binding)) (cdr binding))))

  (defun add-to-dk-keymap (bindings)
    (add-to-keymap dk-keymap bindings))

  (defun add-to-sl-keymap (bindings)
    (add-to-keymap sl-keymap bindings))

  (add-to-dk-keymap
   '(("." . jump-to-register)
     ("/" . org-recoll-search)
     ("<SPC>" . rgrep)
     ("a" . my/org-agenda)
     ("b" . my/set-brightness)
     ("c" . my/open-literate-private-config-file)
     ("d" . dired-jump)
     ("k" . doom/kill-this-buffer-in-all-windows)
     ("m" . my/mathpix-screenshot-to-clipboard)
     ("n" . narrow-or-widen-dwim)
     ("o" . ibuffer)
     ("p" . my/publish-dangirsh.org)
     ("r" . my/set-redshift)
     ("s" . save-buffer)
     ("t" . +vterm/here)
     ("T" . google-translate-at-point)
     ("v" . neurosys/open-config-file)
     ("w" . google-this-noconfirm)
     ("x" . sp-splice-sexp)))

  (key-chord-define-global ",." 'end-of-buffer)
  ;; FIXME: accidentally triggered too often
  (key-chord-define-global "zx" 'beginning-of-buffer)


  (key-chord-define-global "jk" 'evil-normal-state)
  (key-chord-define-global "kj" 'evil-normal-state)

  (key-chord-define-global "qw" 'delete-window)
  (key-chord-define-global "qp" 'delete-other-windows)
  (key-chord-define-global ",," 'doom/open-scratch-buffer)

  (key-chord-define-global "fk" 'other-window)
  (key-chord-define-global "jd" 'rev-other-window)

  (key-chord-define-global "JJ" 'previous-buffer)
  (key-chord-define-global "KK" 'next-buffer)


  (key-chord-define-global "hm" 'helpful-at-point)
  (key-chord-define-global "hk" 'helpful-key)
  (key-chord-define-global "hv" 'helpful-variable)

  ;; no bueno: e.g. "pathfinder", "highfidelity"
  ;; (key-chord-define-global "hf" 'helpful-function)

  (key-chord-define-global "vn" 'split-window-vertically-and-switch)
  (key-chord-define-global "vm" 'split-window-vertically-and-switch) ; ergodox
  (key-chord-define-global "hj" 'split-window-horizontally-and-switch)

  (key-chord-define-global "jm" 'my/duplicate-line-or-region)
  (key-chord-define-global "fv" 'comment-line)

  (key-chord-define-global "kl" 'er/expand-region)

  (key-chord-define-global "xx" 'execute-extended-command)
  (key-chord-define-global "xf" 'find-file)

  (key-chord-define-global "jp" 'my/insert-jupyter-python-block))

(use-package! info-colors
  :commands (info-colors-fontify-node))
(add-hook 'Info-selection-hook 'info-colors-fontify-node)
(setq +zen-text-scale 0.8)
(use-package! selectic-mode
  :commands selectic-mode)

;; (use-package! org-pretty-table
;;   :commands (org-pretty-table-mode global-org-pretty-table-mode))

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers nil
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))


(setq org-directory "~/.org"                      ; let's put files here
      org-use-property-inheritance t              ; it's convenient to have properties inherited
      org-log-done 'time                          ; having the time a item is done sounds convenient
      org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
      org-export-in-background t                  ; run export processes in external emacs process
      org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
      org-export-with-sub-superscripts '{})       ; don't treat lone _ / ^ as sub/superscripts, require _{} / ^{}
(add-hook 'org-mode-hook 'turn-on-flyspell)

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh" "C"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))


  ;; org roam config
  (setq org-directory (concat (getenv "HOME") "/Documents/notes/"))

  (use-package org-roam
    :after org
    :init (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
    :custom
    (org-roam-directory (file-truename org-directory))
    :config
    (org-roam-setup)
    :bind (("C-c f" . org-roam-node-find)
           ("C-c n r" . org-roam-node-random)
           (:map org-mode-map
                 (("C-c i" . org-roam-node-insert)
                  ("C-c n o" . org-id-get-create)
                  ("C-c t" . org-roam-tag-add)
                  ("C-c n a" . org-roam-alias-add)
                  ("C-c n l" . org-roam-buffer-toggle)))))

  (setq org-roam-capture-templates '(("d" "default" plain "%?"
                                      :if-new
                                      (file+head "${slug}.org"
                                                 "#+title: ${title}\n#+date: %u\n#+lastmod: \n\n")
                                      :immediate-finish t
                                      :unnarrowed t)

                                     ("a" "algoritm" plain "%?"
                                      :if-new
                                      (file+head "${slug}.org"
                                                 "#+title: ${title}\n#+date: %u\n#+filetags: :Algorithms:\n#+lastmod: %T\n\n* Basics\n\nData Structure: \nTime Complexity: O(%^{Time Complexity})\nSpace Complexity: O(%^{Space Complexity})\nType: %^{What Type Of Algoritm}\n\n* Typical Uses\n\n* How It Works\n\n* Implementation\n")
                                      :unnarrowed t)
                                     )
        time-stamp-start "#\\+lastmod: [\t]*")

  (use-package deft
    :config
    (setq deft-directory org-directory
          deft-recursive t
          deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
          deft-use-filename-as-title t)
    :bind
    ("C-c n d" . deft))
(map! :leader "r" #'quickrun)
(setq confirm-kill-emacs nil)

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(defun my-org-latex-yas ()
  "Activate org and LaTeX yas expansion in org-mode buffers."
  (yas-minor-mode)
  (yas-activate-extra-mode 'latex-mode))

(add-hook 'org-mode-hook #'my-org-latex-yas)

(after! org
  (setq time-stamp-active t
        org-hide-emphasis-markers t
    time-stamp-start "#\\+lastmod:[ \t]*"
    time-stamp-end "$"
    time-stamp-format "\[%04Y-%02m-%02d %3a %02H:%02M\]")
(add-hook 'before-save-hook 'time-stamp))

(after! ccls
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  ;; (setq ccls-sem-higlight-method 'font-lock)
  ;; alternatively,
  (setq ccls-sem-highlight-method 'overlay)

  ;; For rainbow semantic highlighting
  (ccls-use-default-rainbow-sem-highlight)
  ;; ccls-sem-function-colors
  ;; ccls-sem-macro-colors
  ;; ;; ...
  ;; ccls-sem-member-face  ;; defaults to t :slant italic

  ;; ;; To customize faces used
  ;; (face-spec-set 'ccls-sem-member-face
  ;;                '((t :slant "normal"))
  ;;                'face-defface-spec)
  ) ; optional as ccls is the default in Doom
