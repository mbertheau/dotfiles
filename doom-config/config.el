;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Markus Bertheau"
      user-mail-address "mbertheau@gmail.com")

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
(setq doom-font (font-spec :family "Ubuntu Mono" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/media/psf/Home/OneDrive - machtfit GmbH/org/")

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

(setq confirm-kill-emacs nil)

(setq scroll-margin 40)

(setq doom-localleader-key ",")

(after! which-key
  (setq which-key-idle-delay 0.1))

(after! org
  (setq org-startup-indented nil)
  (setq org-hide-emphasis-markers t)
  (add-to-list 'org-capture-templates '("f" "Feedback an Engineer"))
  (add-to-list 'org-capture-templates '("ft" "Feedback an TK" checkitem (file+headline "MAs/TK.org" "New feedback") ""))
  (add-to-list 'org-capture-templates '("fa" "Feedback an AE" checkitem (file+headline "MAs/AE.org" "New feedback") ""))
  (add-to-list 'org-capture-templates '("fo" "Feedback an OM" checkitem (file+headline "MAs/OM.org" "New feedback") ""))
  (add-to-list 'org-capture-templates '("fk" "Feedback an KK" checkitem (file+headline "MAs/KK.org" "New feedback") ""))
  (add-to-list 'org-capture-templates '("k" "Idea for Knowledge Sharing" item (file+headline "Knowledge Sharing.org" "New items")))
  (map! :map org-mode-map
        :localleader
        "," 'org-ctrl-c-ctrl-c))

(after! evil-org
  (setq evil-org-special-o/O '(table-row item))
  (setq! evil-org-key-theme '(textobjects insert navigation additional return todo heading calendar))
  (evil-org-set-key-theme))

(map! :leader
      :desc "Switch to window #1" "1" 'winum-select-window-1
      :desc "Switch to window #2" "2" 'winum-select-window-2
      :desc "Switch to window #3" "3" 'winum-select-window-3
      :desc "Switch to window #4" "4" 'winum-select-window-4
      :desc "Switch to window #5" "5" 'winum-select-window-5
      :desc "Switch to window #6" "6" 'winum-select-window-6
      :desc "Switch to window #7" "7" 'winum-select-window-7
      :desc "Switch to window #8" "8" 'winum-select-window-8
      :desc "Switch to window #9" "9" 'winum-select-window-9)

(after! rainbow-identifiers
  (setq rainbow-identifiers-cie-l*a*b*-lightness 90)
  (setq rainbow-identifiers-cie-l*a*b*-saturation 90)
  (setq rainbow-identifiers-choose-face-function 'rainbow-identifiers-cie-l*a*b*-choose-face))

(add-hook! 'prog-mode-hook 'rainbow-identifiers-mode)

;; (add-hook! 'prog-mode-hook 'color-identifiers-mode)

(after! magit
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (setq magit-bury-buffer-function 'magit-restore-window-configuration))

(after! lispy
  ;; behave like lispyville's slurp/barf-cp theme in lispy special as well
  (lispy-define-key lispy-mode-map "<" #'lispy-slurp-or-barf-left)
  (lispy-define-key lispy-mode-map ">" #'lispy-slurp-or-barf-right)

  ;; have lispy-visit use projectile to find files within the project
  (setq lispy-visit-method 'projectile))

(after! lispyville
  (lispy-define-key lispy-mode-map "m" #'lispy-view)
  (lispy-define-key lispy-mode-map "v" #'lispyville-toggle-mark-type)
  (setq lispyville-key-theme
        '(operators ;; test non-normal. What would that be?
          c-w
          prettify     ;; prettifies for example with ==
          text-objects ;; test - weiter testen
          (atom-motions t)
          additional-motions ;; Hmm, not so sure yet.
          ;; commentary         ;; non-sensical in clojure :(
          slurp/barf-cp ;; vorher hatte ich -lispy - das geht ganz gut so finde ich
          additional-wrap ;; test, also try additional-wrap as an alternative
          additional
          ;; arrows                        ;; mal ausprobieren - geht nicht
          mark-toggle))
  (setq lispyville-key-theme '())
  (lispyville-set-key-theme))

(use-package! magit-delta
  :hook (magit-mode . magit-delta-mode))

(after! helm-rg
  (setq helm-rg-display-buffer-normal-method #'switch-to-buffer)
  (setq helm-rg-default-extra-args "--no-header"))
