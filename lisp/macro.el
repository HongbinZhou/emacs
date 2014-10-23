
;; ref: http://www.emacswiki.org/emacs/KeyboardMacrosTricks
(defun save-macro (name)                  
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "SName of the macro :") ; ask for the name of the macro    
  (kmacro-name-last-macro name)	     ; use this name for the macro    
  ;; (find-file user-init-file)  ; open ~/.emacs or other user init file
  (find-file "~/.emacs.d/lisp/macro.el")  
  (goto-char (point-max))     ; go to the end of the .emacs
  (newline)		      ; insert a newline
  (insert-kbd-macro name)     ; copy the macro 
  (newline)		      ; insert a newline
  (switch-to-buffer nil))     ; return to the initial buffer

(fset 'today-work
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([3 19 return 3 23 return] 0 "%d")) arg)))

