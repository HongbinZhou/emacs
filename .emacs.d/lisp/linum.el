;;; line number
;;  ref to: http://emacs-fu.blogspot.com/2008/12/showing-line-numbers.html
(global-linum-mode 0)
(global-set-key (kbd "C-<f5>") 'linum-mode)   
(add-hook 'python-mode-hook  (lambda() (linum-mode 1)))
(add-hook 'perl-mode-hook  (lambda() (linum-mode 1)))
(add-hook 'c-mode-common-hook (lambda() (linum-mode 1)))
