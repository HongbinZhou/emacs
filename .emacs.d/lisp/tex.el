;;;auctex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
;; (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook (lambda ()
                             (TeX-fold-mode 1)))
(setq TeX-fold-command-prefix [(control i)])
(add-hook 'LaTeX-mode-hook (lambda()
                             (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
                             (setq TeX-command-default "XeLaTeX")
                             (setq TeX-save-query nil )
                             (setq TeX-show-compilation t)
                             ))



;; #+LaTeX_CLASS: beamer in org files
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             ;; beamer class, for presentations
             '("beamer"
               "\\documentclass[11pt]{beamer}
               \\mode<presentation>
               \\usetheme{Warsaw}
               \\usepackage{beamerinnerthemecircles}
               \\usepackage{hyperref}
               \\usepackage{color}
               \\usepackage{xeCJK} 
               \\usepackage{fontspec}
               \\usepackage{listings}
               \\setmainfont{Times New Roman}
               \\setsansfont{Arial}
               \\setmonofont{Courier New}
               \\setCJKmainfont[BoldFont={Adobe Heiti Std},ItalicFont={Adobe Kaiti Std}]{Adobe Song Std} 
               \\setCJKsansfont{Adobe Heiti Std}
               \\setCJKmonofont{Adobe Kaiti Std}
               \\setCJKfamilyfont{song}{Adobe Song Std}
               \\setCJKfamilyfont{hei}{Adobe Heiti Std}
               \\setCJKfamilyfont{fs}{Adobe Fangsong Std} 
               \\setCJKfamilyfont{kai}{Adobe Kaiti Std}
               \\setCJKfamilyfont{li}{Adobe Kaiti Std}
               \\setCJKfamilyfont{you}{Adobe Kaiti Std}
               \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
               frame=single,
               basicstyle=\\small,
               showspaces=false,showstringspaces=false,
               showtabs=false,
               keywordstyle=\\color{blue}\\bfseries,
               commentstyle=\\color{red},
               }\n
               \\usepackage{verbatim}\n
               \\institute{{{{MediaSoC}}}}\n          
               \\subject{{{{beamersubject}}}}\n"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}"
                "\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}")))

(setq org-latex-to-pdf-process 
      '("xelatex -interaction nonstopmode %f"
        "xelatex -interaction nonstopmode %f")) ;; for multiple passes
