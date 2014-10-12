;;; ansi-term config
;;  ref to: http://www.enigmacurry.com/category/emacs/2/
(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/zsh")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(add-hook 'term-mode-hook
          (lambda ()
	    (yas-minor-mode -1)	    ;;to fix tab error in term mode
	    ;; (define-key term-raw-map [?\M-x] 'execute-extended-command)
	    (define-key term-raw-map [?\M-x] 'smex)
            ))


;; close the frame when term dead
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(define-key term-raw-map (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map (kbd "C-y") 'term-paste)


;; ;; Use this for remote so I can specify command line arguments
;; (defun remote-term (new-buffer-name cmd &rest switches)
;;   (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
;;   (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
;;   (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
;;   (set-buffer term-ansi-buffer-name)
;;   (term-mode)
;;   ;; (term-char-mode)
;;   ;; (term-set-escape-char ?\C-x)
;;   (switch-to-buffer term-ansi-buffer-name))

;; (defun cdmgr1 ()
;;   (interactive) 
;;   (remote-term "cdmgr1" "ssh" "cdmgr1@peemt741"))

  ;; (defun track-shell-directory/procfs ()
  ;;   (shell-dirtrack-mode 0)
  ;;   (add-hook 'comint-preoutput-filter-functions
  ;;             (lambda (str)
  ;;               (prog1 str
  ;;                 (when (string-match comint-prompt-regexp str)
  ;;                   (cd (file-symlink-p
  ;;                        (format "/proc/%s/cwd" (process-id
  ;;                                                (get-buffer-process
  ;;                                                 (current-buffer)))))))))
  ;;             nil t))

  ;; (add-hook 'shell-mode-hook 'track-shell-directory/procfs)

 ;; (defun term-switch-to-shell-mode ()
 ;;  (interactive)
 ;;  (if (equal major-mode 'term-mode)
 ;;      (progn
 ;;        (shell-mode)
 ;;        (set-process-filter  (get-buffer-process (current-buffer)) 'comint-output-filter )
 ;;        (local-set-key (kbd "C-j") 'term-switch-to-shell-mode)
 ;;        (compilation-shell-minor-mode 1)
 ;;        (comint-send-input)
 ;;      )
 ;;    (progn
 ;;        (compilation-shell-minor-mode -1)
 ;;        (font-lock-mode -1)
 ;;        (set-process-filter  (get-buffer-process (current-buffer)) 'term-emulate-terminal)
 ;;        (term-mode)
 ;;        (term-char-mode)
 ;;        (term-send-raw-string (kbd "C-l"))
 ;;        )))


 ;;  (define-key term-raw-map (kbd "C-j") 'term-switch-to-shell-mode)
