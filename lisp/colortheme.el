;;; color-theme
;; (require 'color-theme)
;(setq color-theme-is-cumulative nil)
;(defun mb/pick-color-theme (frame)
;  (select-frame frame)
;    (let ((color-theme-is-global nil))
;      (if (window-system frame)
;         (color-theme-vim-colors)
;       (color-theme-pok-wob))))
;
;(add-hook 'after-make-frame-functions 'mb/pick-color-theme)
;
;;; For when started with emacs or emacs -nw rather than emacs --daemon
;(let ((color-theme-is-global nil))
;  (color-theme-initialize)
;  (if window-system
;      (eval-after-load "color-theme"
;     '(color-theme-vim-colors))
;    (color-theme-pok-wob)))
