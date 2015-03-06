
(defun python-add-breakpoint ()
   "Add a break point"
   (interactive)
   (newline-and-indent)
   (insert "import pdb; pdb.set_trace()")
   (highlight-lines-matching-regexp "^[ ]*import pdb; pdb.set_trace()"))
 
(define-key python-mode-map (kbd "C-c C-b") 'python-add-breakpoint)

(defun python-interactive ()
  "Enter the interactive Python environment"
  (interactive)
  (progn
    (insert "!import code; code.interact(local=vars())")
    (move-end-of-line 1)
    (comint-send-input)))

(global-set-key (kbd "C-c i") 'python-interactive)

;; (require 'isend)
(setq isend-skip-empty-lines nil)
(setq isend-strip-empty-lines nil)
(setq isend-delete-indentation t)
(setq isend-end-with-empty-line t)

(defadvice isend-send (after advice-run-code-sent activate compile)
  "Execute whatever sent to the (Python) buffer"
  (interactive)
  (let ((old-buf (buffer-name)))
    (progn
      (switch-to-buffer isend--command-buffer)
      (goto-char (point-max))
      (comint-send-input)
      (switch-to-buffer old-buf))))

;;; http://stackoverflow.com/questions/1587972/how-to-display-indentation-guides-in-emacs
(require 'highlight-indentation)
(add-hook 'python-mode-hook 'highlight-indentation-mode)
(add-hook 'js2-mode-hook 'highlight-indentation-mode)
