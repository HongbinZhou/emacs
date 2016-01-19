
;;; Using Cask to maintain emacs package dependency
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/plugins")

(set-language-environment "UTF-8")

;;; package setting
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
			 ("elpa" . "http://tromey.com/elpa/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("elpy" . "http://jorgenschaefer.github.io/packages/")
			 ))

;;; winner-mode
;; using Ctrl-c + <- (left arrow) to restore the latest frame orgnization
(when (fboundp 'winner-mode)
  (winner-mode)
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

(require 'undo-tree)
(global-undo-tree-mode)

(setq line-number-mode t)
(setq column-number-mode t)


;;; following extension cause halt when tramp ssh file which cannot connect from home
;(require 'save-visited-files)
;(turn-on-save-visited-files-mode)

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

;;; save minibuffer history
(savehist-mode 1)

;;; bookmark+
;;; let bookmark load after p4, so C-x p will be used as bookmark's prefix key
(require 'bookmark+)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

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

;;; mercurial
(require 'mercurial)

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


;;; open txt and tso log with utf-8 coding
;;; ref: http://emacswiki.org/emacs/ChangingEncodings
(modify-coding-system-alist 'file "\\.txt\\'" 'utf-8)
(modify-coding-system-alist 'file "\\.tso\\'" 'utf-8)
(modify-coding-system-alist 'file "\\.mlf\\'" 'utf-8)

;; setup files ending in “.tso” to open in nxml-mode
(add-to-list 'auto-mode-alist '("\\.tso\\'" . nxml-mode))

;;; ref: https://github.com/codemac/config/blob/master/emacs.d/boot.org#narrow-to-indirect-buffer
(defun hbzhou/narrow-to-region-indirect (start end)
  "Restrict editing in this buffer to the current region, indirectly."
  (interactive "r")
  (when (fboundp 'evil-exit-visual-state) ; There's probably a nicer way to do this
    (evil-exit-visual-state))
  (let ((buf (clone-indirect-buffer nil nil)))
    (with-current-buffer buf
      (narrow-to-region start end))
    (switch-to-buffer buf)))

(global-set-key (kbd "C-x n i") 'cm/narrow-to-region-indirect)

;;; Easy to copy code to show
(defun hbzhou/kill-with-linenum (beg end)
  (interactive "r")
  (save-excursion
    (goto-char end)
    (skip-chars-backward "\n \t")
    (setq end (point))
    (let* ((chunk (buffer-substring beg end))
           (chunk (concat
                   (format "╭──────── #%-d ─ %s ──\n│ "
                           (line-number-at-pos beg)
                           (or (buffer-file-name) (buffer-name)))
                   (replace-regexp-in-string "\n" "\n│ " chunk)
                   (format "\n╰──────── #%-d ─"
                           (line-number-at-pos end)))))
      (kill-new chunk)))
  (deactivate-mark))

;;; open file as root
(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (let ((thefile (ad-get-arg 0)))
    (if (string-prefix-p "/etc" thefile)
        (if (and (not (file-writable-p thefile))
                 (y-or-n-p (concat "File "
                                   thefile
                                   " is read-only.  Open it as root? ")))
            (cm/find-file-sudo thefile))))
  ad-do-it)

(defun cm/find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))

(set-default 'indicate-empty-lines t)

(setq ag-highlight-search t)


;;; https://github.com/abo-abo/swiper
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;;; https://github.com/abo-abo/hydra/wiki/Projectile
(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))

(defhydra hydra-projectile (:color teal
                            :hint nil)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
  ("a"   projectile-ag)
  ("b"   projectile-switch-to-buffer)
  ("c"   projectile-invalidate-cache)
  ("d"   projectile-find-dir)
  ("s-f" projectile-find-file)
  ("ff"  projectile-find-file-dwim)
  ("fd"  projectile-find-file-in-directory)
  ("g"   ggtags-update-tags)
  ("s-g" ggtags-update-tags)
  ("i"   projectile-ibuffer)
  ("K"   projectile-kill-buffers)
  ("s-k" projectile-kill-buffers)
  ("m"   projectile-multi-occur)
  ("o"   projectile-multi-occur)
  ("s-p" projectile-switch-project "switch project")
  ("p"   projectile-switch-project)
  ("s"   projectile-switch-project)
  ("r"   projectile-recentf)
  ("x"   projectile-remove-known-project)
  ("X"   projectile-cleanup-known-projects)
  ("z"   projectile-cache-current-file)
  ("`"   hydra-projectile-other-window/body "other window")
  ("q"   nil "cancel" :color blue))

(global-set-key (kbd "M-p") #'hydra-projectile/body)

(setq buffer-file-coding-system 'utf-8-unix)
