
(require 'auto-complete-config)
(ac-config-default)

(global-auto-complete-mode t)
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; Don't start completion automatically
;(setq ac-auto-start nil)
;(global-set-key "\M-/" 'ac-start)

;; Stop completion
(define-key ac-complete-mode-map "\M-/" 'ac-stop)

;; Completion by TAB
(define-key ac-complete-mode-map "\t" 'ac-complete)
(define-key ac-complete-mode-map "\r" nil)

;; Change sources for particular mode
;; ----------------------------------
;;  (add-hook 'emacs-lisp-mode-hook
;;   (lambda ()
;;     (setq ac-sources '(ac-source-words-in-buffer ac-source-symbols))))

(add-to-list 'ac-modes 'python-mode)
;;(add-to-list 'ac-modes 'matlab-mode)

(add-to-list 'ac-modes 'Latex-mode)
