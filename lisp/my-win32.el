(setenv "PATH"
	(concat
	 "C:/Python27" ";"
	 "C:/cygwin64/bin" ";"
	 "C:/cygwin64/usr/sbin" ";"
	 "C:/Program Files/Git/bin" ";"
	 "C:/Program Files (x86)/Git/bin" ";"
	 (getenv "PATH")
	 ))

(server-start)
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary "C:/Program Files (x86)/Aspell/dict")

(global-set-key (kbd "C-x C-c") 'my-done)
(defun my-done ()
  (interactive)
  (server-edit)
  (make-frame-invisible nil t))

;; Prevent issues with the Windows null device (NUL)
;; when using cygwin find with rgrep.
(defadvice grep-compute-defaults (around grep-compute-defaults-advice-null-device)
  "Use cygwin's /dev/null as the null-device."
  (let ((null-device "/dev/null"))
        ad-do-it))
(ad-activate 'grep-compute-defaults)

;;; no need ??
;; ;; Teach emacs to understand cygwin paths. This should come last
;; (require 'setup-cygwin)

;; (require 'cygwin-mount)
;; (cygwin-mount-activate)

(add-to-list 'auto-mode-alist '("\\.bat\\'" . bat-mode))
