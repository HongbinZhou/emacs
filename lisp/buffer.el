;;; buffer name
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;;; window-number
(autoload 'window-number-mode "window-number"
          "A global minor mode that enables selection of windows according to
          numbers with the C-x C-j prefix.  Another mode,
          `window-number-meta-mode' enables the use of the M- prefix."
          t)

(autoload 'window-number-meta-mode "window-number"
          "A global minor mode that enables use of the M- prefix to select
          windows, use `window-number-mode' to display the window numbers in
          the mode-line."
          t)
(window-number-mode 1) 
(window-number-meta-mode 1)

;;; buffer-extension
;   ref: http://www.emacswiki.org/emacs/buffer-extension.el
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins"))
(require 'buffer-extension)


;;;ido
;(require 'ido)
;(ido-mode t)
;(setq ido-max-dir-file-cache 0) ;; 不让缓存目录,否则目录改变他也不知道
;(setq ido-enable-regexp t)      ;; 可以用正则表达式找文件

(require 'helm-config)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;; helm switch buffer is slow!!X
(global-set-key (kbd "C-x b") 'helm-buffers-list)
;;;ido
(global-set-key (kbd "C-x M-b") 'ido-switch-buffer)

(helm-mode 1)
(set-face-attribute 'helm-lisp-show-completion t :background "seashell")

;; Enable helm pcomplete
;; ref: https://github.com/emacs-helm/helm/wiki
(add-hook 'eshell-mode-hook
	  #'(lambda ()
	      (define-key eshell-mode-map
		[remap eshell-pcomplete]
		'helm-esh-pcomplete)))

(setq enable-recursive-minibuffers t)
;; http://www.reddit.com/r/emacs/comments/1q6zx2/disable_helmfindfiles_path_autocompletion/
(setq helm-ff-auto-update-initial-value nil)

(setq helm-idle-delay 0.3
      helm-quick-update t
      helm-candidate-number-limit 25
      helm-su-or-sudo "sudo"
      helm-allow-skipping-current-buffer nil)
(setq helm-mp-matching-method 'multi2)
(setq helm-M-x-requires-pattern 0)
(setq helm-ff-transformer-show-only-basename nil)


;;; helm-swoop
;;; https://github.com/ShingoFukuyama/helm-swoop
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

;;; helm-M-x
(global-set-key (kbd "M-x") 'helm-M-x)


;; swapping TAB with M-TAB and C-z with TAB:
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-M-i") 'helm-select-action)

;; enable recentf-mode
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") 'helm-recentf)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
