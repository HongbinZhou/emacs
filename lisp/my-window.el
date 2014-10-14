
;; ;;;;窗口大小调节
;; (global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
;; (global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-S-<down>") 'shrink-window)
;; (global-set-key (kbd "C-S-<up>") 'enlarge-window)


;; resize window
(defun v-resize (key)
  "interactively resize the window"
  (interactive "cHit =/- to enlarge/shrink")
  (cond
   ((eq key (string-to-char "="))
    (enlarge-window 1)
    (call-interactively 'v-resize))
   ((eq key (string-to-char "-"))
    (enlarge-window -1)
    (call-interactively 'v-resize))
   ((eq key ?\r) (discard-input))
   (t (call-interactively 'v-resize))))

(defun h-resize (key)
  "interactively resize the window horizontally"
  (interactive "cHit =/- to enlarge/shrink horizontally")
  (cond
   ((eq key (string-to-char "="))
    (enlarge-window-horizontally 1)
    (call-interactively 'h-resize))
   ((eq key (string-to-char "-"))
    (enlarge-window-horizontally -1)
    (call-interactively 'h-resize))
   ((eq key ?\r) (discard-input))
   (t (call-interactively 'h-resize))))

(global-set-key (kbd "C-c C-v =") 'v-resize)
(global-set-key (kbd "C-c C-h =") 'h-resize)


;;; toggle window split
;;; http://www.emacswiki.org/emacs/ToggleWindowSplit
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(define-key ctl-x-4-map "t" 'toggle-window-split)
