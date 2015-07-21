
;;; Tips for term applications
;;; http://emacs-fu.blogspot.com/2008/12/running-console-programs-inside-emacs.html
(defun djcb-term-start-or-switch (prg &optional use-existing)
  "* run program PRG in a terminal buffer. If USE-EXISTING is non-nil "
  " and PRG is already running, switch to that buffer instead of starting"
  " a new instance."
  (interactive)
  (let ((bufname (concat "*" prg "*")))
    (when (not (and use-existing
                 (let ((buf (get-buffer bufname)))
                   (and buf (buffer-name (switch-to-buffer bufname))))))
      (ansi-term prg prg))))

(defmacro djcb-program-shortcut (name key &optional use-existing)
  "* macro to create a key binding KEY to start some terminal program PRG; 
    if USE-EXISTING is true, try to switch to an existing buffer"
  `(global-set-key ,key 
     '(lambda()
        (interactive)
        (djcb-term-start-or-switch ,name ,use-existing))))

;; terminal programs are under Shift + Function Key
(djcb-program-shortcut "zsh"   (kbd "<S-f1>") t)  ; the ubershell
(djcb-program-shortcut "mutt"  (kbd "<S-f2>") t)  ; mail client
(djcb-program-shortcut "htop"  (kbd "<S-f3>") t)  ; my processes
;; (djcb-program-shortcut "slrn"  (kbd "<S-f4>") t)  ; nttp client
;; (djcb-program-shortcut "mc"    (kbd "<S-f5>") t)  ; midnight commander
;; (djcb-program-shortcut "raggle"(kbd "<S-f6>") t)  ; rss feed reader
;; (djcb-program-shortcut "irssi" (kbd "<S-f7>") t)  ; irc client



(global-set-key (kbd "C-2") 'set-mark-command)
(define-key global-map (kbd "C-M-h") 'mark-sexp)


;;; font size
;; using scroll to control font size
;; http://emacser.com/torture-emacs.htm
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

(setq outline-minor-mode-prefix [(control o)])


(global-set-key (kbd "C-c z") 'shell)
(global-set-key (kbd "C-z") 'eshell) 
(global-set-key (kbd "<f9>") 'rename-buffer)


(global-set-key (kbd "M-J") (lambda () (interactive) (enlarge-window 1)))
(global-set-key (kbd "M-K") (lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "M-H") (lambda () (interactive) (enlarge-window -1 t)))
(global-set-key (kbd "M-L") (lambda () (interactive) (enlarge-window 1 t)))

;; (global-set-key (kbd "M-j") 'windmove-down)
;; (global-set-key (kbd "M-k") 'windmove-up)
;; (global-set-key (kbd "M-h") 'windmove-left)
;; (global-set-key (kbd "M-l") 'windmove-right)

;; (global-set-key (kbd "C-<left>") 'windmove-left)   ;左边窗口
;; (global-set-key (kbd "C-<right>") 'windmove-right)  ;右边窗口
;; (global-set-key (kbd "C-<up>") 'windmove-up)     ; 上边窗口
;; (global-set-key (kbd "C-<down>") 'windmove-down)   ; 下边窗口



(defun bind-compile-key ()
  (local-set-key "\C-c\C-c" 'compile))
(add-hook 'c-mode-hook 'bind-compile-key) 
(add-hook 'c++-mode-hook 'bind-compile-key)


;;; unbind Alt+Tab,
;; Alt+Tab is used to switch between Virtualbox Client and Windows programs,
;; and it is translate fo C-M-i,
;; By unseting <M-tab> fail to unbind it
;; Finally, unset "C-M-i" works.
(global-unset-key (kbd "C-M-i"))
;; (global-unset-key (kbd "<M-tab>"))

;;; unbind Ctrl+z
(global-unset-key (kbd "C-x C-z"))
;; (global-unset-key (kbd "C-z"))

(global-unset-key (kbd "<M-tab>"))

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "C-c r") 'query-replace-regexp)

;;; avy
;;  ref: https://github.com/abo-abo/avy
;;  It will bind, for example, avy-isearch to C-' in isearch-mode-map, so that you can select one of the currently visible isearch candidates using avy.
(avy-setup-default)
;; extra key bindings for avy
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

;;; ref:
;;;     http://stackoverflow.com/questions/3124844/what-are-your-favorite-global-key-bindings-in-emacs

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Magit rules!
(global-set-key (kbd "C-x g") 'magit-status)

;; regexp count occurrences
;; http://stackoverflow.com/questions/11847547/emacs-regexp-count-occurrences
(global-set-key (kbd "C-c o") 'count-matches)
