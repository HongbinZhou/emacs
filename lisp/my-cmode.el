(which-function-mode 1)

;;; outline-minor-mode
;; http://www.emacswiki.org/emacs/OutlineMinorMode
;; Outline-minor-mode key map
(define-prefix-command 'cm-map nil "Outline-")
					; HIDE
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
					; SHOW
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
					; MOVE
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(global-set-key "\M-o" cm-map)

(defun indent-all ()
    "Indent entire buffer."
    (interactive)
    (save-excursion
	(indent-region (point-min) (point-max) nil)))

(defun untabify-all ()
    "untabify entire buffer"
    (interactive)
    (save-excursion
	(if (not indent-tabs-mode)
		(untabify (point-min) (point-max)))
	nil))

(defun my-c-mode-common-hook ()
  (setq indent-tabs-mode nil)
  (setq c-default-style "bsd")
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (electric-indent-mode 1)
  (c-toggle-auto-hungry-state 1)
  ;;; smart-tab
  ;;; http://www.emacswiki.org/emacs/SmartTabs#Retab
  ;; (smart-tabs-insinuate 'c 'javascript)
  (whitespace-mode t)
  ;; (setq c-eldoc-includes "-Ie:\\workspace\\local\\vocvoc_embh\\ttssrc.a\\tts_main\\be\\embh\\inc")
  ;; (load "c-eldoc")
  (eldoc-mode t)
  (line-number-mode t)
  (hs-minor-mode t)
  (fold-dwim-org/minor-mode t)
  ;; handle trailing space
  (setq-default show-trailing-whitespace t)
  (setq-default require-final-newline t)
  (setq-default delete-trailing-lines nil)
  ;; (add-hook 'local-write-file-hooks 'delete-trailing-whitespace)
  ;; (add-hook 'local-write-file-hooks 'untabify-all)
  ;; (add-hook 'local-write-file-hooks 'indent-all)
  )

(add-hook 'c-mode-common-hook
          'my-c-mode-common-hook)

;;; Folding!!!
;;; http://stackoverflow.com/questions/1085170/how-to-achieve-code-folding-effects-in-emacs?rq=1
;;; Using fold-dwim.el
;;; Using fold-dwim-org.el


;;; M-x imenu
;;; M-x helm-imenu, this is great!

(require 'whitespace)
(setq whitespace-style '(tabs tab-mark)) ;turns on white space mode only for tabs


;;; ref: http://tuhdo.github.io/c-ide.html#sec-1-1

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

;;; https://github.com/syohex/emacs-helm-gtags
;;  helm-gtags-path-style(Default 'root)
;;  File path style, 'root or 'relative or 'absolute. You can only use 'absolute if you use Windows and set GTAGSLIBPATH environment variable. helm-gtags.el forces to use absolute style in such case.
;;; NOTE: The forward slash at the end is MUST!!

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (message "setting helm-gtags on Microsoft Windows ...")
    (setq helm-gtags-path-style 'absolute)
    (setenv "GTAGSLIBPATH" "E:/workspace/local/vocvoc_embh/")
    )))

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
     (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

;;; C-q [num in december]
(setq read-quoted-char-radix 10)
