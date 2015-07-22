
;;; tramp
(require 'tramp)

;; (setq tramp-default-method "rlogin")
;; (setq tramp-default-host "rhas44")
;; (setq tramp-default-user "hbzhou")


;; (add-to-list 'tramp-remote-path "/linux/depot/xclip-0.10/bin/xclip")
(setq explicit-shell-file-name nil)
;(setq explicit-shell-file-name "/remote/us01home40/hbzhou/bin/zsh")

(defun us01-shell ()
  "Run zsh in am04 site"
  (interactive)
  (let ((explicit-shell-file-name "/remote/us01home40/hbzhou/bin/zsh"))
    (call-interactively 'shell)))

(defun am04-shell ()
  "Run zsh in am04 site"
  (interactive)
  (let ((explicit-shell-file-name "/remote/am04home1/cdmgr/hbzhou/bin/zsh"))
    (call-interactively 'shell)))
(defun my-find-file-at-point-with-line ()
  "Opens the file at point and goes to line-number."
  (interactive)
  (let ((fname (ffap-file-at-point)))
    (if fname
      (let ((line
             (save-excursion
               (goto-char (cadr ffap-string-at-point-region))
               (and (re-search-backward ":\\([0-9]+\\)"
                                        (line-beginning-position) t)
                    (string-to-int (match-string 1))))))
        ;; (message "file:%s,line:%s" fname line)
        (when (and (tramp-tramp-file-p default-directory)
                   (= ?/ (aref fname 0)))
          ;; if fname is an absolute path in remote machine, it will not return a tramp path,fix it here.
          (let ((pos (position ?: default-directory)))
            (if (not pos) (error "failed find first tramp indentifier ':'"))
            (setf pos (position ?: default-directory :start (1+ pos)))
            (if (not pos) (error "failed find second tramp indentifier ':'"))
            (setf fname (concat (substring default-directory 0 (1+ pos)) fname))))
        (message "fname:%s" fname)
        (find-file-existing fname)
        (when line (goto-line line)))
      (error "File does not exist."))))
(global-set-key (kbd "C-x f") 'my-find-file-at-point-with-line)

;; Open files with root
(defun cm/rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
             (file-remote-p (buffer-file-name) 'method)
             (buffer-name)))))

(add-hook 'find-file-hook
          'cm/rename-tramp-buffer)

