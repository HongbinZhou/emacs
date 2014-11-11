
;;; Using Cask to maintain emacs package dependency
(require 'cask "~/.cask/cask.el")
(cask-initialize)


(add-to-list 'load-path "~/.emacs.d/plugins")    

(set-language-environment "UTF-8")
;; (set-language-environment 'Chinese-GBK)

;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))

;;; package setting
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
			 ))

(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;;; winner-mode
;; using Ctrl-c + <- (left arrow) to restore the latest frame orgnization
(when (fboundp 'winner-mode) 
  (winner-mode) 
  ;(windmove-default-keybindings)
  ) 

;;; autorevert stuff
(autoload 'auto-revert-mode "autorevert" nil t)
(autoload 'turn-on-auto-revert-mode "autorevert" nil nil)
(autoload 'global-auto-revert-mode "autorevert" nil t)
(global-auto-revert-mode 1)

;;; parenface
(require 'parenface)
(set-face-foreground 'parenface-paren-face "gray50")
(show-paren-mode t)
;; set show-paren-style as expression is better??
;; (setq show-paren-style 'parenthesis)
(setq show-paren-style 'expression)
(setq show-paren-delay 0)

;;; Highlight-blocks modex
;; (highlight-blocks-mode 1)

;;; make current file excutable
;;  http://emacswiki.org/emacs/MakingScriptsExecutableOnSave
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


(setq make-backup-files nil)

;;; mouse
(setq mouse-wheel-mode 1)
(setq focus-follows-mouse nil)
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el

;(desktop-save-mode 1)

;;; session
(require 'session) 
(when (require 'session nil t)
  (add-hook 'after-init-hook 'session-initialize)
  (add-to-list 'session-globals-exclude 'org-mark-ring))

(autoload 'session-jump-to-last-change "session" nil t)
(autoload 'session-initialize "session" nil t)
(eval-after-load "cus-load"
  '(progn (custom-add-load 'data 'session)
          (custom-add-load 'session 'session)))

(if (display-graphic-p)
   ; only valid within X
    (progn
      (tool-bar-mode -1)
      (set-scroll-bar-mode nil))
  (progn
					; no x
    ))

(put 'upcase-region 'disabled nil)


;(add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-20121104.1157/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

; default C-c SPC is conflict with org table
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(require 'undo-tree)
(global-undo-tree-mode)

(setq line-number-mode t)
(setq column-number-mode t)


;;; following extension cause halt when tramp ssh file which cannot connect from home
;(require 'save-visited-files)
;(turn-on-save-visited-files-mode)


;; ;;; smex
;; (require 'smex) ; Not needed if you use package.el
;; (smex-initialize) ; Can be omitted. This might cause a (minimal) delay
;;                   ; when Smex is auto-initialized on its first run.

;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; (global-set-key (kbd "C-c M-x") 'smex-update)
;; ;; This is your old M-x.
;; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; (defun smex-update-after-load (unused)
;;   (when (boundp 'smex-cache)
;;     (smex-update)))
;; (add-hook 'after-load-functions 'smex-update-after-load)

;; (setq shell-command-switch "-ic")

;;; Doubam-fm
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins"))
(autoload 'douban-music "douban-music-mode" nil t)

;; Display week, date and time
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)


;;; ediff,
;; ref to: http://www.emacswiki.org/emacs/EdiffMode
;;         http://stackoverflow.com/questions/1680750/is-there-any-way-to-get-ediff-to-not-open-its-navigation-interface-in-an-externa
;; This is what you probably want if you are using a tiling window
;; manager under X, such as ratpoison.
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; smart-window
;; (require 'smart-window)

;;; save minibuffer history
(savehist-mode 1)

;;; bookmark+
;;; let bookmark load after p4, so C-x p will be used as bookmark's prefix key
(require 'bookmark+)


;;; (setq browse-url-browser-function 'w3m-browse-url)
;;;  (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;;;  ;; optional keyboard short-cut
;;;  (global-set-key "\C-xm" 'browse-url-at-point)
;;; (define-key w3m-mode-map [mouse-2] 'w3m-mouse-view-this-url-new-session)



(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; (require 'occur-default-current-word)

;;; crontab-mode 
(add-to-list 'auto-mode-alist '("cron\\(tab\\)?\\."    . crontab-mode))

;;; https://github.com/capitaomorte/autopair
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers


;;; YASnippet
(require 'yasnippet)
(yas-global-mode 1)

;; PDFs visited in Org-mode are opened in Evince (and not in the default choice) http://stackoverflow.com/a/8836108/789593
(add-hook 'org-mode-hook
	  '(lambda ()
	     (delete '("\\.pdf\\'" . default) org-file-apps)
	     (add-to-list 'org-file-apps '("\\.pdf\\'" . "xpdf %s"))))

;;; https://github.com/leoliu/easy-kill
(global-set-key [remap kill-ring-save] 'easy-kill)
(global-set-key [remap mark-sexp] 'easy-mark)

(require 'powerline)
(powerline-default-theme)


;;; Thu May  8 14:02:33 2014    
;;; popwin.el, nice!
(require 'popwin)
(popwin-mode 1)


;;; Tue May 13 10:35:29 2014
;;; ace-window
;;; Usage:
;;;       swap window: C-u M-p
;;;       kill window: C-u C-u M-p
;;;       jump window: M-p <a,b,c,d,...>
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))


;;; ntcmd-mode
(add-to-list 'auto-mode-alist '("\\.bat$" . ntcmd-mode))
(add-to-list 'auto-mode-alist '("\\.cmd$" . ntcmd-mode))

;;; monky, for hg
;;; https://github.com/ananthakumaran/monky
;;; http://ananthakumaran.in/monky/index.html
;; (add-to-list 'load-path "path/to/monky/dir")
(require 'monky)
;; By default monky spawns a seperate hg process for every command.
;; This will be slow if the repo contains lot of changes.
;; if `monky-process-type' is set to cmdserver then monky will spawn a single
;; cmdserver and communicate over pipe.
;; Available only on mercurial versions 1.9 or higher

(setq monky-process-type 'cmdserver)

;;; ahg
(require 'ahg)

;;; using re-builder to do replace
;;; http://www.emacswiki.org/ReBuilder
(defun hbzhou/reb-query-replace (to-string)
  "Replace current RE from point with `query-replace-regexp'."
  (interactive
   (progn (barf-if-buffer-read-only)
	  (list (query-replace-read-to (reb-target-binding reb-regexp)
				       "Query replace"  t))))
  (with-current-buffer reb-target-buffer
    (query-replace-regexp (reb-target-binding reb-regexp) to-string)))

;;; projectile
(projectile-global-mode)

;;; fix c:/cygdrive/c/User/... path issues when use magit on windows
;;; https://github.com/magit/magit/issues/1318
(defadvice magit-expand-git-file-name
  (before magit-expand-git-file-name-cygwin activate)
  "Handle Cygwin directory names such as /cygdrive/c/*
by changing them to C:/*"
  (when (string-match "/cygdrive/\\([a-z]\\)/\\(.*\\)" filename)
(setq filename (concat (match-string 1 filename) ":/"
               (match-string 2 filename)))))
