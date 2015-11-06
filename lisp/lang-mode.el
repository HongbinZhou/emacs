
;;; lua-mode
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)



;;; php mode
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("/*.\.php[345]?$" . php-mode)) auto-mode-alist))

;;; shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

;; ;;;yasnippet
;; ;(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20130218.2229")
;(require 'yasnippet)
;(yas-global-mode 1)

;;;flyspell
(setq-default ispell-program-name "aspell")

;;; c++/c
(setq compile-command "sh compile")

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (eshell-command
   (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))

;;; delete trailing space of given file
(defun hbzhou/delete-trailing-space-file (file)
  (interactive "F")
  (save-excursion
    (find-file file)
    (delete-trailing-whitespace)
    (write-file file)
    (kill-buffer (current-buffer))
    ))

;;; delete trailing space for all el files in given dir
(defun hbzhou/delete-trailing-space-dir-el (dir)
  (interactive "D")
  (mapc 'hb/delete-trailing-space-file
        (directory-files dir t ".el$")))

