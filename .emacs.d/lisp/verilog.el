;;;verilog mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'ac-modes 'verilog-mode)
;; Load verilog mode only when needed
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v should be in verilog mode
(setq auto-mode-alist (cons  '("\\.v\\'" . verilog-mode) auto-mode-alist))
;; Any files in verilog mode should have their keywords colorized
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))
(add-hook 'verilog-mode-hook '(lambda () (add-hook 'local-write-file-hooks
                                                   (lambda() (untabify (point-min) (point-max))))))
(setq verilog-indent-level           2
      verilog-indent-level-module      2
      verilog-indent-level-declaration 2
      verilog-indent-level-behavioral  2
      verilog-indent-level-directive   1
      verilog-case-indent              2
      verilog-auto-newline             t
      verilog-auto-indent-on-newline   t
      verilog-tab-always-indent        t
      verilog-auto-endcomments         t
      verilog-minimum-comment-distance 40
      verilog-indent-begin-after-if    t
      verilog-auto-lineup              '(all))

(setq verilog-tool 'verilog-lint-only)
(setq verilog-linter "verilator --lint-only")
;(setq verilog-coverage "coverage ...")
;(setq verilog-simulator "verilator ... ")
;(setq verilog-compiler "verilator ... "

