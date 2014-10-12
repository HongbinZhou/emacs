
; load my-rxvt.el
; 
(add-hook 'after-make-frame-functions
          (lambda (new-frame)
           (with-selected-frame new-frame
            (unless (or noninteractive window-system)
              (if (string-match ".*256color" (getenv "TERM"))
                (progn
                  (setq term-file-prefix nil)
                  (load "term/rxvt")
                  (terminal-init-rxvt)))))))
