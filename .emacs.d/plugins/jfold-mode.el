;; very goood
;;http://cjohansen.no/an-introduction-to-elisp
;;http://hyperpolyglot.org/lisp
;;http://www.gnu.org/software/emacs/manual/html_node/elisp/Type-Predicates.html

;;algorithm:
;;itemblock/inline --- tree node/not tree node
;;

;; need to deal with matches with length greater than one.
;; need to formalize tag more

;; !!!! important
;; tag-meta {open-re close-re get-match-pattern
;; from matched result ---> tag-meta --> tag
;;case sensitive or insensitive.


;;;Wed Jul 25 01:23:19 PDT 2012
;;; 1. fold tag definition from progammer, initialization.
;;; 2. two stage match
;;;    1. the first round match ==> find the tag definition, concrete match info (concrete tag,
;;;       pos, open/close
;;;    2. the second match ===> based on the first round, get the matched pair ---> item match
;;; 3. view
;;;    overlay (hide/show fold/unfold)
;;; 4. user control (key/mouse) interaction hookups.

;;								  +---------------------------------------------+			|
;; +------------+  +------------+ |+------------+  +------------+	   	     	|			|
;; |  tag-pair  |  |  sexp pair | ||   outline  |  |  indent    |	NOT	     	|			|
;; |match engine|  |match engine| ||match engine|  |match engine|   Implemented	|			|
;; +------------+  +------------+ |+------------+  +------------+	   	     	|			|
;;					    -----	  +---------------------------------------------+			|
;;				       /	 \	                                         					|
;;			          / engine\																|
;;			          |       |																|	 +-----------------+
;;			          \selector       			   +--------------------------------+		|	 |                 |
;;				       \	 /      			   |       Overlay Management       |		|	 |                 |
;;					    -----    				   |  +-----------+  +-------------+|		|	 |                 |
;;				  +-----------------+			   |  | creation  |  | fold/unfold ||	    |	 |    output       |
;;				  |    	   	   	    |			   |  +-----------+  +-------------+|	    |	 |   (screen)      |
;;		   	----->|  match engine  	+-------------->                                +-------+--->|                 |
;;		   ^	  |		plugin 	    |			   |                                |	    |	 |                 |
;;		   |	  +-----------------+			   |   +----------+ +-------------+ |	    |	 |                 |
;;		   |									   |   |navigation| | overlay edit| |	    |	 +-----------------+
;;		   |									   |   +----------+ +-------------+ |	    |
;;		   |									   |        ^         ^             |	    |	 +-----------------+
;;		   |									   +--------+---------+-------------+	    |	 |   input         |
;;		   |												|		  |					    |	 |  +---------+    |
;;		   |	*(main workflow path)		                |         |     +-----------+   |	 |  | keyboard|    |
;;		   +------------------------------------------------+---------+-----+ keymap  	| <-+----+  +---------+    |
;;																			+-----------+   |	 |  +---------+    |
;;																			   	   	   	  	|	 |  | mouse   |    |
;;																			             	|	 |  +---------+    |
;;																								 +-----------------+
;;
;;
;;
;;
;;

(defconst jfold-version "1.0.0"
  "Jfold Mode Version Number.")

;;(require 'font-lock)

(defface jfold-folded-face
  '((((class color) (background light))
     (:foreground "SlateBlue"))
    (((class color) (background dark))
     (:foreground "SlateBlue1"))
    (((class grayscale) (background light))
     (:foreground "DimGray"))
    (((class grayscale) (background dark))
     (:foreground "LightGray"))
    (t (:slant italic)))
  "Face for the display string of folded content."
  :group 'jfold)
(defvar jfold-folded-face 'jfold-folded-face)

(defface jfold-unfolded-face
  '((((class color) (background light))
     (:background "#f2f0fd"))
    (((class color) (background dark))
     (:background "#38405d"))
    (((class grayscale) (background light))
     (:background "LightGray"))
    (((class grayscale) (background dark))
     (:background "DimGray"))
    (t (:inverse-video t)))
  "Face for folded content when it is temporarily opened."
  :group 'jfold)
(defvar jfold-unfolded-face 'jfold-unfolded-face)

(defvar jfold-tooltip-message-max-length 50)

;;(defvar html-fold-tag-defs
(setq html-fold-tag-defs
  (list
   'name "html-fold-tags"
   'open-pattern "<\\([A-Za-z0-9]+\\)\\(\\s-\\(>\\|[^>]*[^/>]>\\)\\|>\\)\\|\\(<!--\\)"
   'close-pattern "</\\([A-Za-z0-9]+\\)\\s-*>\\|\\(-->\\)"
   'get-tag-name (lambda (tag-str is-open match-group)
		(if (or (equal tag-str "<!--") (equal tag-str "-->"))
		       "<!--...-->"
		     (let* (
			    (grp-begin (car (cdr (cdr match-group))))
			    (grp-end   (car (cdr (cdr (cdr match-group))))))
		       (concat "<"
			       (buffer-substring-no-properties grp-begin grp-end)
			       "...>"))))
   'get-close-pattern-for-open-value (lambda (open-tag-str)
				       (if (equal open-tag-str "<!--")
					   "-->"
					 (progn
					   (string-match "<\\([A-Za-z0-9]+\\).*>" open-tag-str)
					   (let ((value (match-string 1 open-tag-str)))
					     (concat "</" value "\\s-*>"))
					   ;;(list 'value value
					   ;; 'mat-pattern (concat "</" value ">")))
					   )
					 ))
   'get-open-pattern-for-open-value (lambda (open-tag-str)
				      (if (equal open-tag-str "<!--")
					  "<!--"
					(progn
					  (string-match "<\\([A-Za-z0-9]+\\).*>" open-tag-str)
					  (let ((value (match-string 1 open-tag-str)))
					    (concat "<" value "\\(\\s-\\(>\\|[^>]*[^/>]>\\)\\|>\\)"))
					   ;;(list 'value value
					   ;;  'mat-pattern (concat "<" value "\\s-+.*>")))
					  )
					))
   'get-close-pattern-for-close-value (lambda (close-tag-str)
					(if (equal close-tag-str "-->")
					    "-->"
					  (progn
					    (string-match "</\\([A-Za-z0-9]+\\).*>" close-tag-str)
					    (let ((value (match-string 1 close-tag-str)))
					      (concat "</" value "\\s+*>"))
					    ;;(list 'value value
					    ;; 'mat-pattern (concat "</" value ">")))
					    )
					  ))

   'get-open-pattern-for-close-value (lambda (close-tag-str)
				       (if (equal close-tag-str "-->")
					   "<!--"
					 (progn
					   (string-match "</\\([A-Za-z0-9]+\\).*>" close-tag-str)
					   (let ((value (match-string 1 close-tag-str)))
					     (concat "<" value "\\(\\s-\\(>\\|[^>]*[^/>]>\\)\\|>\\)"))
					   ;;(list 'value value
					   ;; 'mat-pattern (concat "<" value "\\(\\s-+.*>\\|>\\)")))
					   )
					 ))
   'folded-face jfold-folded-face
   'unfolded-face jfold-unfolded-face
   )
)

;;(defvar brace-fold-tag-defs
(setq brace-fold-tag-defs
  (list
   'name "brace-fold-tags"
   'open-pattern "{"
   'close-pattern "}"
   'get-tag-name (lambda (tag-str is-open match-group) "{...}")
   'get-close-pattern-for-open-value (lambda (open-tag-str) "}")
   'get-open-pattern-for-open-value (lambda (open-tag-str) "{")
   'get-close-pattern-for-close-value (lambda (close-tag-str) "}")
   'get-open-pattern-for-close-value (lambda (close-tag-str) "{")
   'get-open-pattern-for-comment (lambda () nil )
   'get-close-pattern-for-comment (lambda () nil )
   )
)

;;test
;;(funcall (plist-get html-fold-tag-defs 'get-close-pattern-for-open-value) "<html a=111 b=222>")
;;(funcall (plist-get html-fold-tag-defs 'get-open-pattern-for-close-value) "</html>")

;;(plist-get html-fold-tag-defs 'get-close-pattern-for-open-value)
(defvar re-fold-tag-list '()
  "* The list holds all the fold tag definitions")




(defvar _re-fold-tag-def-plist (list )) ;;; for matching references
;;(setq _re-fold-tag-def-plist (list ))
(defvar _re-pattern "")

(setq _re-fold-tag-def-plist '())
(setq _re-pattern "")

(defun re-paren-numbers (pattern-str)
  (let (
	(count 0)
	(index 0)
	(len (- (length pattern-str) 1))
	)
    (progn
      (while (< index len)
	(progn
	  (if (equal "\\(" (substring pattern-str index (+ 2 index)))
	      (progn
		(setq count (1+ count))
		(setq index (+ index 2)))
	    (setq index (1+ index)))

	  ;;(message "count %d index %d" count index)
	  )
	)
      count)))

(defun re-pattern-init (re-fold-tag-list &optional index)
  (let*
      (
       (pat (car re-fold-tag-list))
       (open-pattern  (if pat (plist-get pat 'open-pattern)))
       (close-pattern (if pat (plist-get pat 'close-pattern)))
       )
    (if pat
	(progn
	  (if (not index)
	      (progn
		(setq index 2)
		(setq _re-pattern
		      (concat "\\(" open-pattern
			      "\\)\\|\\("
			      close-pattern
			      "\\)"
			      ))
		)
	    (setq _re-pattern (concat _re-pattern "\\|\\(" open-pattern
				   "\\)\\|\\("
				   close-pattern
				   "\\)"
				   )))
	  (setq _re-fold-tag-def-plist (append _re-fold-tag-def-plist (list index (list t pat))))
	  (setq index (+ 2 index))
	  (setq index (+ (* 2 (re-paren-numbers open-pattern)) index))
	  (setq _re-fold-tag-def-plist (append _re-fold-tag-def-plist (list index (list nil pat))))
	  (setq index (+ 2 index))
	  (setq index (+ (* 2 (re-paren-numbers close-pattern)) index))
	  (re-pattern-init (cdr re-fold-tag-list) index)
	  ))))


(defun re-fold-get-match-def-info (match-data-info)
  (let ((grp (cdr (cdr match-data-info)))
	(match-def _re-fold-tag-def-plist)
	(flag t)
	(index 2)
	(tag-name "unknown")
	(match-grp (list ))
	(match-def-info nil))
    (progn
      (while (and flag grp)
	(if (car grp)
	    (progn
	      (setq flag nil)
	      (setq match-def-info
		    (list 'is-open (car (plist-get match-def index))
			  'tag-def (car (cdr (plist-get match-def index)))
			  'tag-begin (car grp)
			  'tag-end (car (cdr grp))
			  'tag-str (buffer-substring-no-properties (car grp)
				     (car (cdr grp)))
			   )
		    )
	      )
	  (progn
	    (setq grp (cdr (cdr grp)))
	    (setq index (+ 2 index)))))
      (if match-def-info
	  (progn
	    (setq tag-name (funcall (plist-get (plist-get match-def-info 'tag-def) 'get-tag-name)
				    (plist-get match-def-info 'tag-str)
				    (plist-get match-def-info 'is-open)
				    grp))
	    (plist-put match-def-info 'tag-name tag-name)
	    match-def-info)))))



(defun re-find-nearest-tag-info(&optional search-direction)
  (let* (
	 (pat _re-pattern)
	 (cur-pos (point))
	 (pos (if search-direction
		  (re-search-backward pat nil t)
		(re-search-forward pat nil t)))
	 )
    (if (not pos)
	nil
      (re-fold-get-match-def-info (match-data)))))




(defun re-find-the-match-item (match-def-info)
  (let* (
	 (counter 1)
	 (is-open (plist-get match-def-info 'is-open))
	 (mat-item nil)
	 (search-direct (if is-open nil t))
	 (mat-data (plist-get match-def-info 'tag-str))
	 (tag-def (plist-get match-def-info 'tag-def))
	 ;;(xx (princ tag-def))
	 ;; to get it from match-end and match-begin
	 (pattern
	 (if is-open
	     (concat "\\("
		     (funcall
		      (plist-get tag-def 'get-close-pattern-for-open-value)
		      mat-data)
		      "\\)\\|\\("
		     (funcall
		      (plist-get tag-def 'get-open-pattern-for-open-value)
		      mat-data)
		     "\\)"
		     )
	   (concat "\\("
		     (funcall
		      (plist-get tag-def 'get-close-pattern-for-close-value)
		      mat-data)
		      "\\)\\|\\("
		     (funcall
		      (plist-get tag-def 'get-open-pattern-for-close-value)
		      mat-data)
		     "\\)"
		     ))
	))
    ;;(save-excursion ;;for testing, in the functional form, it should be taken out to higher levels
;;	 (if (plist-get match-def-info 'is-open)
    (progn
      ;;(message "pattern --- %s" pattern)
      (while (> counter 0)
	(progn
	  ;;(message "counter is %d" counter)
	  (setq mat-item (re-find-item pattern search-direct))
	  (if (not mat-item)
	      (setq counter 0)
	    (if (equal (plist-get mat-item 'is-open) is-open)
		(setq counter (1+ counter))
	      (setq counter (1- counter))
	      )
	    )
	  )
	)
      (if mat-item
	  (progn
	    (append match-def-info (plist-get mat-item 'match))
	    )
	nil))))



(defun re-find-item (pattern &optional search-direct)
  ;;should analysis the group composition in the pattern, then decide which
  ;; item is found --- close or open.!!!!
  (let* (
	 (item nil)
	 (match-begin nil)
	 (match-and nil)
	 (match-str nil)
	 (mat-data (progn
		     (if search-direct
			 (re-search-backward pattern)
		       (re-search-forward pattern)
		       )
		     (match-data)))
	 )
    (if (not mat-data)
	nil
      (progn
	(setq match-begin (car mat-data))
	(setq match-end (car (cdr mat-data)))
	(setq match-str (buffer-substring-no-properties match-begin match-end))
	(setq mat-data (cdr (cdr mat-data)))
	(if (car mat-data) ;;close-tag
	  (setq item
		(list 'is-open nil
		      'match (list
			      'match-begin match-begin
			      'match-end match-end
			      'match-str match-str)
		      ))
	  (setq item (list 'is-open t
			   'match (list
				   'match-begin match-begin
				   'match-end match-end
				   'match-str match-str))))
	item))))

(defun re-get-match-pair-position (match-pair start)
  (if (plist-get match-pair 'is-open)
      (if start
	  (marker-position (plist-get match-pair 'tag-begin))
	(marker-position (plist-get match-pair 'match-end)))
    (if start
	  (marker-position (plist-get match-pair 'match-begin))
	(marker-position (plist-get match-pair 'tag-end)))))

(defun re-find-the-match-pair ()
  (let (
	(first-child-tag-def nil)
	(tag-def nil)
	(tag-match nil)
	(loop-flag t)
	(cur-pos (point))
	)
    (progn
      (save-excursion
	(while loop-flag
	  (progn
	    (setq tag-def (re-find-nearest-tag-info ))
	    ;;(princ tag-def)
	    (cond
	     ( (not tag-def)
		 (setq loop-flag nil))
	     ( t
	       (if (plist-get tag-def 'is-open)
		   (if (not first-child-tag-def)
		       (setq first-child-tag-def
			     (re-find-the-match-item tag-def))
		     (re-find-the-match-item tag-def))
		 (setq loop-flag nil))))
	  ) ;; get the close-tag
	))
      (save-excursion
	(cond

	 ( (and tag-def (not first-child-tag-def))
	   (setq tag-match (re-find-the-match-item tag-def)))
	 ( (and tag-def first-child-tag-def)
	   (if (equal cur-pos (re-get-match-pair-position first-child-tag-def t))
	       (setq tag-match first-child-tag-def)
	     (progn
	       (setq tag-match (re-find-the-match-item tag-def))
	       ;;still some issue ---> when the parent tag (tag-def) has no match open, the first-child-tag-def cannot be folded
	       )))
	 (first-child-tag-def (setq tag-match first-child-tag-def))
	 ))
      (if tag-match
	  (progn
	    (plist-put tag-match 'start-pos
		       (if (plist-get tag-match 'is-open)
			   (marker-position (plist-get tag-match 'tag-begin))
			 (marker-position (plist-get tag-match 'match-begin))))
	    (plist-put tag-match 'end-pos
		       (if (plist-get tag-match 'is-open)
			   (marker-position (plist-get tag-match 'match-end))
			 (marker-position (plist-get tag-match 'tag-end)))))
	);; get the matched open-tag
      tag-match
      )))

;;view part --- overlay management
(defun make-ov (tag-match)
  (let* (
	 (tag-name
	  (plist-get tag-match 'tag-name))
	 (tag-category (plist-get (plist-get tag-match 'tag-def) 'name))
	 (ov-start (if (plist-get tag-match 'is-open)
		       (plist-get tag-match 'tag-begin)
		     (plist-get tag-match 'match-begin)))
	 (ov-end (if (plist-get tag-match 'is-open)
		     (plist-get tag-match 'match-end)
		   (plist-get tag-match 'tag-end)))
	 (ov (make-overlay ov-start ov-end (current-buffer) t nil)))
    (overlay-put ov 'category tag-category)
    (overlay-put ov 'jfold t)
    (put-text-property 0 (length tag-name) 'face jfold-folded-face tag-name)
    (overlay-put ov 'display-name tag-name)
    (overlay-put ov 'mouse-face 'highlight)
    (overlay-put ov 'priority 1)
    ;;(overlay-put ov 'invisible t)
    ov))


(defun get-inner-overlay (pt)
  (let* (
	 (start -1)
	 (ov nil)
	 (ovs (overlays-at pt)))
    (dolist (elem ovs)
      (if (> (overlay-start elem) start)
	  (progn
	    (setq start (overlay-start elem))
	    (setq ov elem))))
    ov))

(defun ov-start-p (ov1 ov2)
  (let (
	(start1 (overlay-start ov1))
	(start2 (overlay-start ov2))
	)
    (> start1 start2)))
(defun assign-self-ov-priority (ov)  ;;naive algorithm
  (let (
	(child-ovs (overlays-in (overlay-start ov) (overlay-end ov)))
	(priority 0)
	elem
	)
    (progn
      (while child-ovs
	(progn
	  (setq elem (car child-ovs))
	  (setq child-ovs (cdr child-ovs))
	  (if (overlay-get elem 'jfold)
	      (if (< priority (overlay-get elem 'priority))
		  (setq priority (overlay-get elem 'priority))))))
      (overlay-put ov 'priority (1+ priority))
      (1+ priority))))

(defun reassign-parent-ov-priorities (pt pri-number) ;; parents have higher priorities than child.
  (let* (
	 (ovs (sort (overlays-at pt) 'ov-start-p))
	 ;;sort* is undefined on emacs 23.1.1 => changed to sort
	 (pn pri-number)
	 ov
	)
    (while ovs
      (progn
	(setq ov (car ovs))
	(setq ovs (cdr ovs))
	(if (overlay-get ov 'jfold)
	    (if (< pn (overlay-get ov 'priority))
		(setq ovs nil)
	      (progn
		(overlay-put ov 'priority pn)
		(setq pn (1+ pn)))))))))


;; control/framework/toggle fold command entry
(defun toggle-fold (&optional match-engine-fun)
  (let* ( pri-number
	  (new-pair nil)
	  (pt (point))
	  (ov nil)
	  (match-engine (if match-engine-fun
			    match-engine-fun
			  're-find-the-match-pair))
	  ;; (match-pair (sexp-find-match-pair))
	  ;; (match-pair (re-find-the-match-pair))
	  ;;funcall
	   (match-pair (funcall match-engine))
	  )
    (progn
      (if match-pair
	  (progn
	    (message (plist-get match-pair 'tag-name))
	    (setq pt
		  (plist-get match-pair 'start-pos))
	    ;;(message "the curpos: %d" pt)
	    (setq ov
		  (get-inner-overlay pt))
	    (cond
	     ( (not ov)
	       (setq new-pair t))
	     ( (< (overlay-start ov) pt)
	       (setq new-pair t)))

	    (if new-pair
		(progn  ;;new inner tag pair
		  (setq ov (make-ov match-pair))
		  (setq pri-number (assign-self-ov-priority ov))
		  (reassign-parent-ov-priorities (point) pri-number)
		  ))))
      (if (not ov)
	  (setq ov (get-inner-overlay pt)))

      (if ov
	  (toggle-overlay ov)
	  )
      )))

(defun toggle-overlay (ov)
  (if (overlay-get ov 'display)
      (show-overlay ov)
    (hide-overlay ov)
    ))

(defun hide-overlay (ov)
  (if (not (overlay-get ov 'display))
      (progn
	(overlay-put ov 'display
		(overlay-get ov 'display-name)
		     )
	(overlay-put ov 'mouse-face 'highlight)
	(if (< 0 jfold-tooltip-message-max-length)
	    (overlay-put ov 'help-echo
			 (concat
			  (get-fold-summary (overlay-start ov) (overlay-end ov))
			  "..."
			  )))
    )))

(defun show-overlay (ov)
  (if (overlay-get ov 'display)
      (progn
	(overlay-put ov 'display nil)
	(overlay-put ov 'mouse-face nil)
	(overlay-put ov 'help-echo nil)
	)
    ))

(defun get-fold-summary (start end)
  (let (
	 (msg-end (min (+ start jfold-tooltip-message-max-length) end (point-max))))
    (buffer-substring start msg-end)
     ))

(setq nav-ov-jump-state
      (list 'cur-index nil 'pos-vector nil))
(defvar jump-func-symbol '(lambda () (interactive) (nav-ov-jump)))  ;to avoid expose command functions.
(defun nav-ov-jump()
;;  (interactive)
;;  (princ last-command)
  (cond
   ((and (eq last-command jump-func-symbol);'nav-ov-jump)
	   (plist-get nav-ov-jump-state 'pos-vector))
    (let* (
	   (len (length (plist-get nav-ov-jump-state 'pos-vector)))
	   (cur (% (1+ (plist-get nav-ov-jump-state 'cur-index)) len))
	   (target-pos (aref (plist-get nav-ov-jump-state 'pos-vector) cur)))
      (progn
	(plist-put nav-ov-jump-state 'cur-index cur)
	(goto-char target-pos))))
   (t
    (let*
	( target-pos cur-index
	 (pt (point))
	 (ov (get-inner-overlay pt)))
      (cond
       	((not ov)
	 (progn
	   (plist-put nav-ov-jump-state 'pos-vector nil)
	   (message "not in folding region")
	   ))
	(t
	 (progn
	   (if (overlay-get ov 'display) ;;folded ov
	       (show-overlay ov))
	   (progn
	     (cond
	      ((or (equal pt (overlay-start ov))
		   (equal pt (overlay-end ov)))
	       (progn
		 (plist-put nav-ov-jump-state 'pos-vector
			    (vector (overlay-start ov) (overlay-end ov)))
		 (setq cur-index
		       (if (equal pt (overlay-start ov))
			   1
			 0))
		 ))
	      (t
	       (progn
		 (plist-put nav-ov-jump-state 'pos-vector
			    (vector (overlay-start ov) pt (overlay-end ov)))
		 (setq cur-index 2)
		 )))

	     (plist-put nav-ov-jump-state 'cur-index cur-index)
	     (setq target-pos (aref (plist-get nav-ov-jump-state 'pos-vector) cur-index))
	     (goto-char target-pos)))))))))



(defun jfold-toggle-fold ()
;;  (interactive)
  (toggle-fold))


(defun jfold-post-command()
  (if (memq this-command (list 'mouse-set-point))
      (let (
	    (ov (get-inner-overlay (point)))
	    )
	(progn
	  ;;(message "jfold-post mouse triggered")
	  (if ov
	      (show-overlay ov)
	    )))))


;;(setq counter 1)
;;(setq mat-tag nil)
;; work on tag level
(defun jfold-reload ()
  (setq html-fold-tag-defs nil)
  (setq re-fold-tag-list (list ))
  (setq brace-fold-tag-defs (list ))
  (setq re-fold-tag-list (list ))
  (setq _re-fold-tag-def-plist (list ))
  (setq _re-pattern "")

)

(defun jfold-hide-all ()
  (let (
	 (ovs (overlays-in (point-min) (point-max)))
	 )
    (dolist (elem ovs)
      (if elem
	  (if (overlay-get elem 'jfold)
	      (hide-overlay elem)
	    )))))


(defun jfold-show-all ()
  (let (
	 (ovs (overlays-in (point-min) (point-max)))
	 )
    (dolist (elem ovs)
      (if elem
	  (if (overlay-get elem 'jfold)
	      (show-overlay elem))))))


(defun delete-all-ovs ()
    (save-excursion
    (remove-overlays (beginning-of-buffer)
		     (end-of-buffer) 'jfold t)))
(defun jfold-delete-ov-at-point ()
  (save-excursion
    (delete-overlay (get-inner-overlay (point)))))

(defun show-ovs ()
  (let* (
	 (ovs (overlays-at (point)))
	)
    (dolist (elem ovs)
      (message "tag: %s priority: %d" (overlay-get elem 'display) (overlay-get elem 'priority))
      ;;(princ (list (overlay-get elem 'display) (overlay-get elem 'priority)))
      )))

(defun list-overlays-at (&optional pos)
  "Describe overlays at POS or point."
  (setq pos (or pos (point)))
  (let ((overlays (overlays-at pos))
	(obuf (current-buffer))
	(buf (get-buffer-create "*Overlays*"))
	(props '(priority window category face mouse-face display
			  help-echo modification-hooks insert-in-front-hooks
			  insert-behind-hooks invisible intangible
			  isearch-open-invisible isearch-open-invisible-temporary
			  before-string after-string evaporate local-map keymap
			  field))
	start end text)
    (if (not overlays)
	(message "None.")
      (set-buffer buf)
      (erase-buffer)
      (dolist (o overlays)
	(setq start (overlay-start o)
	      end (overlay-end o)
	      text (with-current-buffer obuf
		     (buffer-substring start end)))
	(when (> (- end start) 13)
	  (setq text (concat (substring text 1 10) "...")))
	(insert (format "From %d to %d: \"%s\":\n" start end text))
	(dolist (p props)
	  (when (overlay-get o p)
	    (insert (format " %15S: %S\n" p (overlay-get o p))))))
      (pop-to-buffer buf))))

;;minor mode
;;(defvar jfold-keymap
(setq jfold-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-o\C-o" '(lambda () (interactive) (toggle-fold)))
    (define-key map "\C-c\C-o\C-p" '(lambda () (interactive) (toggle-fold 'sexp-find-match-pair)))
    (define-key map "\C-c\C-o\C-s" '(lambda () (interactive) (jfold-show-all)))
    (define-key map "\C-c\C-o\C-h" '(lambda () (interactive) (jfold-hide-all)))
    (define-key map "\C-c\C-o\C-D" '(lambda () (interactive) (delete-all-ovs)))
    (define-key map "\C-c\C-o\C-r" '(lambda () (interactive) (jfold-delete-ov-at-point)))
    (define-key map "\C-c\C-o\C-l" '(lambda () (interactive) (list-overlays-at)))
    (define-key map "\C-c\C-n\C-t" jump-func-symbol);'nav-ov-jump)

    map))

(defvar jfold-mode nil
  "Mode variable for jfold minor mode")
(make-variable-buffer-local 'jfold-mode)

(defun jfold-mode (&optional arg)
  "JFold minor mode."
  (interactive "P")
  (setq jfold-mode
	(if (not arg)
	    (not jfold-mode)
	  (> (prefix-numeric-value arg) 0)))
  (cond
   (jfold-mode
    (progn
      (if (not (assq 'jfold-mode minor-mode-alist))
	  (progn
	    ;;(setq mode-name (append mode-name "/JFT"))
	    (add-to-list 'minor-mode-alist '(jfold-mode " JFold"))
	    ;;install the keymap
	    (add-to-list
	     'minor-mode-map-alist
	     (cons 'jfold-mode jfold-keymap)
	     )
	    )
	)
      (jfold-minor-mode-init)
      (use-local-map jfold-keymap)
      (add-hook 'post-command-hook 'jfold-post-command nil t);;loal buffer
      ;;(add-hook 'post-command-hook 'jfold-post-command) ;;global
      ))
   (t ;;unload jfold-mode
    ;; the jfold-keymap need to be removed!!
    (progn
      (if (assq 'jfold-mode minor-mode-alist)
	  (progn
	    ;;(setq mode-name (substring mode-name 0 -3))
	    (assq-delete-all 'jfold-mode minor-mode-alist)
	    (assq-delete-all 'jfold-mode minor-mode-map-alist)

	    ))
      (jfold-minor-mode-uninit)
      (remove-hook 'post-command-hook 'jfold-post-command t)
      )
    )))


(defun jfold-minor-mode-init()
  (progn
    ;;(make-variable-buffer-local 'jfold-folded-face)
    ;;(make-variable-buffer-local 'jfold-unfolded-face)

    ;;(make-variable-buffer-local 're-fold-tag-list)
    (make-variable-buffer-local '_re-fold-tag-def-plist)
    (make-variable-buffer-local '_re-pattern)

    (setq _re-fold-tag-def-plist '())
    (setq _re-pattern "")
    (re-pattern-init re-fold-tag-list)
    ))

;;module loading initialization
;;initialize the global variable re-fold-tag-list with built-in defaults
;;so that it can be also extended by the user.
(add-to-list 're-fold-tag-list html-fold-tag-defs)
(add-to-list 're-fold-tag-list brace-fold-tag-defs)

(defun jfold-minor-mode-uninit()
  (delete-all-ovs)
  (setq _re-fold-tag-def-plist '())
  (setq _re-pattern "")
  t
  )

(defun re-match-engine-test-init()
  (setq re-fold-tag-list (list ))
  (add-to-list 're-fold-tag-list html-fold-tag-defs)
  (add-to-list 're-fold-tag-list brace-fold-tag-defs)
  (setq _re-fold-tag-def-plist '())
  (setq _re-pattern "")
  (re-pattern-init re-fold-tag-list)
  )

(defun sexp-find-match-pair()
  (interactive)
  (let (
	(match-pair nil)
	(first-child-pair nil)
	(pattern "\\(\\s(\\)\\|\\(\\s)\\)")
	(loop-flag t)
	grp-data
	start-pos
	end-pos
	)
    (save-excursion
      (progn
	(cond
	 ((looking-at "\\s(");;open
	  (progn
	    (setq start-pos (point))
	    (setq start-char (buffer-substring-no-properties start-pos (1+ start-pos)))
	    (forward-sexp)
	    (setq end-pos  (1- (point)))
	    (setq end-char (buffer-substring-no-properties (1- (point)) (point)))
	    (setq match-pair
		  (list 'tag-name (concat start-char "..." end-char)
			'is-open t
			'tag-begin (copy-marker start-pos)
			'tag-end (copy-marker (1+ start-pos))
			'start-pos start-pos
			'match-begin (copy-marker end-pos)
			'match-end   (copy-marker (1+ end-pos))
			'end-pos end-pos
			'tag-def '(name "sexp-tag")
			))))
	 ((looking-at "\\s)");;close
	  (progn
	    (setq end-pos (point))
	    (setq end-char (buffer-substring-no-properties end-pos (1+ end-pos)))
	    (goto-char (1+ (point)))
	    (backward-sexp)
	    (setq start-pos   (point))
	    (setq start-char (buffer-substring-no-properties (point) (1+ (point))))
	    (setq match-pair
		  (list 'tag-name (concat start-char "..." end-char)
			'is-open t
			'tag-begin (copy-marker start-pos)
			'tag-end (copy-marker (1+ start-pos))
			'start-pos start-pos
			'match-begin (copy-marker end-pos)
			'match-end   (copy-marker (1+ end-pos))
			'end-pos end-pos
			'tag-def '(name "sexp-tag")
			))))
	 )
	match-pair))))

(provide 'jfold-mode)
;;;jfold-mode ends here