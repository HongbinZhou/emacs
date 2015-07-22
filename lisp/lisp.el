
;;; paredit
(autoload 'paredit-mode "paredit"
          "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))

(keyboard-translate ?\( ?\[)
(keyboard-translate ?\[ ?\()
(keyboard-translate ?\) ?\])
(keyboard-translate ?\] ?\))
(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-sexp))

;(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "[") 'paredit-open-parenthesis))
;(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "]") 'paredit-close-parenthesis))
;(eval-after-load 'paredit '(define-key paredit-mode-map (kbd "(") 'paredit-open-bracket))
;(eval-after-load 'paredit '(define-key paredit-mode-map (kbd ")") 'paredit-close-bracket))




;; ;; slime users
;; (add-hook 'slime-repl-mode-hook
;;           #'(lambda ()
;;               (turn-on-cldoc-mode)
;;               (define-key slime-repl-mode-map " " nil)))
;; (add-hook 'slime-mode-hook
;;           #'(lambda () (define-key slime-mode-map " " nil)))
;; (setq slime-use-autodoc-mode nil)

;; (setq cldoc-argument-case 'downcase
;;       cldoc-idle-delay 0.2)
;; (setq slime-autodoc-use-multiline-p t)

;; (setq  slime-compile-file-options  '(:fasl-directory  "/tmp/slime-fasls/"))
;; (make-directory  "/tmp/slime-fasls/"  t)

;; ;;; slime-helper
;; (load (expand-file-name "~/.quicklisp/slime-helper.el"))

;; ;; slime-autodoc-mode
;; (slime-setup  '(slime-autodoc))



;; ;;; slime
;; ;; (setq inferior-lisp-program "/usr/bin/cmucl")
;; (setq inferior-lisp-program "/usr/bin/mit-scheme")
;; (require 'slime)
;; (slime-setup)
;; (global-set-key (kbd "\C-c s") 'slime-selector)
;; (setq slime-protocol-version 'ignore)


;; (setq slime-lisp-implementations
;;       '((mit-scheme ("mit-scheme") :init mit-scheme-init)))

;; (defun mit-scheme-init (file encoding)
;;   (format "%S\n\n"
;; 	  `(begin
;; 	    (load-option 'format)
;; 	    (load-option 'sos)
;; 	    (eval
;; 	     '(construct-normal-package-from-description
;; 	       (make-package-description '(swank) '(())
;; 					 (vector) (vector) (vector) false))
;; 	     (->environment '(package)))
;; 	    (load ,(expand-file-name
;; 		    "contrib/swank-mit-scheme.scm" ; <-- insert your path
;; 		    slime-path)
;; 		  (->environment '(swank)))
;; 	    (eval '(start-swank ,file) (->environment '(swank))))))

;; (defun mit-scheme ()
;;   (interactive)
;;   (slime 'mit-scheme))

;; (defun find-mit-scheme-package ()
;;   (save-excursion
;;     (let ((case-fold-search t))
;;       (and (re-search-backward "^[;]+ package: \\((.+)\\).*$" nil t)
;; 	   (match-string-no-properties 1)))))

;; (setq slime-find-buffer-package-function 'find-mit-scheme-package)
;; (add-hook 'scheme-mode-hook (lambda () (slime-mode 1)))
