
;;; Tue May 27 15:14:02 2014
;;  link: http://haskell.github.io/haskell-mode/manual/latest/

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;; https://github.com/haskell/haskell-mode/wiki/Haskell-Interactive-Mode-Tags
(custom-set-variables '(haskell-tags-on-save t))

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)


(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))

(custom-set-variables '(haskell-process-type 'cabal-repl))
