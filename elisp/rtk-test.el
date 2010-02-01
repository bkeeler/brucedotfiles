; rtk-test.el
;;
;; Changes on May 03 2004 bjk
;;     -- Tests always go to *Test Output* buffer
;;     -- colorize tests
;;     -- new interactive function tablize-region
;;     -- new interactive function auto-tablize



;;
;; Tablizing
;;

(defun tablize-region (start end)
  "Run the region through table-ize.pl"
  (interactive "*r")
  (shell-command-on-region start end "perl -MAppropriateLibrary -MRTK::Text::Tableize -e 'print tableize(<>)'" nil t nil))

(defun auto-tablize ()
  "Run the current table through table-ize.pl"
  (interactive "*")
  (let ((saved-point (point)))   ; save-excursion won't help here
    (if (current-line-looks-like-table-p)
	(tablize-region
	 (save-excursion
	   (find-start-of-table))
	 (save-excursion
	   (find-end-of-table))))
    (goto-char saved-point)))

(defun find-start-of-table ()
  (interactive)
  (beginning-of-line)
  (while (and (current-line-looks-like-table-p)
	      (= (forward-line -1) 0)))
  (if (current-line-looks-like-table-p)
      (point)
    (forward-line 1)
    (point)))

(defun find-end-of-table ()
  (interactive)
  (beginning-of-line)
  (while (and (current-line-looks-like-table-p)
	      (= (forward-line 1) 0)))
  (point))
	      
(defun current-line-looks-like-table-p ()
  (let ((line-string (current-line-string)))
    (or
     (string-match "=>" line-string)
     (string-match "^[ \t]*$" line-string)
     (string-match "^\\s-*[[({].*\\S-" line-string))))

(defun current-line-string ()
  (buffer-substring-no-properties (line-beginning-position) (line-end-position)))



;;
;; Bouncing around between files
;;

(defun current-line-component ()
  (line-component (current-line-string)))

(defun line-component (line-string)
  (when (or
         (string-match "<&\\s-*['\"]\\([./a-zA-Z_0-9.-]+\\)['\"]" line-string)
         (string-match "->s?comp(\\s-*['\"]\\([./a-zA-Z_0-9.-]+\\)['\"]" line-string)
         (string-match "\\([./a-zA-Z_0-9.-]+\.html?\\)" line-string))
    (match-string 1 line-string)))

(defun goto-test-module ()
  "open the test module that corresponds to the current module"
  (interactive)
  (find-file (current-test-file-name)))

(defun goto-implementation-module ()
  "open the implementation module that corresponds to the current test module"
  (interactive)
  (find-file (current-implementation-file-name)))

(defun goto-module-on-current-line ()
  "open the module on the current line"
  (interactive)
  (save-excursion
    (let ((case-fold-search nil))
      (beginning-of-line)
      (let ((line-string (current-line-string)))
        (cond ((string-match "use\\s-+\\(Aliased\\s-+'\\)?\\(base\\s-+\\(qw.\\|('\\)\\)?\\([A-Za-z0-9_\\:]+\\)" line-string)
               (goto-module (match-string 4 line-string)))
              ((string-match "\\([A-Z][a-zA-Z0-9:]*\\)->" line-string)
               (goto-module-with-name-or-alias (match-string 1 line-string))))))))

(defun goto-module-with-name-or-alias (name-or-alias)
  (goto-char (point-min))
  (if (re-search-forward (concat "use\\s-+\\(Aliased\\s-+'\\)?\\(base\\s-+\\(qw.\\|('\\)\\)?\\([A-Za-z0-9_\\:]+" name-or-alias "\\)['\")/;]") nil t)
      (goto-module (buffer-substring (match-beginning 4) (match-end 4)))))

(defun goto-base-module ()
  "open the base class module"
  (interactive)
  (goto-module
   (save-excursion
     (goto-char (point-min))
     (re-search-forward "use\\s-+base\\s-+\\(['\"]\\|qw.\\s-*\\)\\([A-Za-z0-9_\\:]+\\)")
     (buffer-substring (match-beginning 2) (match-end 2)))))

(defun goto-component-on-current-line ()
  "open the Mason component referenced on the current line"
  (interactive)
  (let ((component (current-line-component)))
    (if component
        (find-file (component-file-name (current-line-component)))
      (message "Can't find a component listed on the current line"))))
    
(defun data-dump (begin end)
  "DataDumper function"
  (interactive "r")
  (let ((string (delete-and-extract-region begin end)))
    (insert (format "print Data::Dumper::Dumper(%s);" string))))

(defun goto-module (module-name)
  (find-file (module-file-name module-name)))

(defun module-buffer (module-name)
  (get-file-buffer (module-file-name module-name)))
   
(defun module-file-name (module-name)
   (module-to-path (current-base-path) module-name))

(defun current-base-path ()
  (let ((file-name (buffer-file-name)))
    (string-match "\\(.+\\)/\\(perl_lib\\|web_src\\)" file-name)
    (concat (substring file-name (match-beginning 1) (match-end 1))
            "/perl_lib")))

(defun current-htdocs-base-path ()
  (let ((file-name (buffer-file-name)))
    (string-match "\\(.+/htdocs/\\)" file-name)
    (match-string 1 file-name)))

(defun file-directory (file)
  (progn
    (string-match "\\(.+\\)/[^/]+" file)
    (substring file (match-beginning 1) (match-end 1))))



;;
;;  Running tests 
;;

(defun run-current-module-test ()
  "runs rtk_test on the current module"
  (interactive)
  (goto-test-module)
  (let ((dir (file-directory (module-file-name (test-module-name (current-module-name)))))
        (module (current-module-name)))
    (save-excursion
      (and (module-buffer (test-module-name module))
           (set-buffer (module-buffer (test-module-name module)))
           (save-buffer)))
    (save-excursion
      (and (module-buffer (implementation-module-name module))
           (set-buffer (module-buffer (implementation-module-name module)))
           (save-buffer)))
    (run-module-test dir (test-module-name module))))

(defun run-current-test ()
  "runs rtk_test on the current test"
  (interactive)
  (goto-test-module)
  (let ((dir (file-directory (buffer-file-name)))
        (module (current-module-name))
        (test (current-test-name)))
    (save-buffer)
    (run-test dir test module)))

(defun current-module-name ()
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "^package\\s-+\\([A-Za-z0-9\\:_]+\\)")
    (buffer-substring (match-beginning 1) (match-end 1))))

(defun current-test-name ()
  (save-excursion
    (let ((test-sub-re "^sub\\s-\\(TEST[_A-Za-z0-9]*\\)\\b"))
      (or (re-search-backward test-sub-re nil t)
          (re-search-forward test-sub-re nil t))
      (match-string 1))))

(defun trim-module-name (name)
  (progn
    (string-match "[A-Za-z0-9_\\:]+\\:\\:\\([A-Za-z0-9_]+\\)" name)
    (substring name (match-beginning 1) (match-end 1))))

(defun run-test (dir function module)
  (let ((command (format "cd %s && rtk_test -h -f %s %s" dir function (trim-module-name module))))
    (run-test-shell command)))

(defun run-module-test (dir module)
  (let ((command (format "cd %s && rtk_test -c -h %s" dir (trim-module-name module))))
    (run-test-shell command)))

(defun run-all-tests ()
  (interactive)
  (let ((command (format "cd %s/RTK/SCM && rtk_test -c -h" (current-base-path))))
    (run-test-shell command)))

(require 'ansi-color)
(setenv "COLOR_TESTS" "yes")

(defun rtk-debug-current-test ()
  (require 'gud)
  (interactive)
  (perldb (format "rtk_test -h -f %s -m %s" (current-test-name) (file-name-nondirectory buffer-file-name))))

(defvar rtktest-buffer nil)
(defvar rtktest-base-path nil)

(defun run-test-shell (command)
  (save-excursion
    (let ((max-mini-window-height 1))
      (setq rtktest-base-path (current-base-path))
      (setq rtktest-buffer (get-buffer-create "*rtk_test*"))
      (display-buffer rtktest-buffer t)
      (set-buffer rtktest-buffer)
      (erase-buffer)
      ; Not inserting the command into the buffer, because
      ; rtktest-mode ends up thinking that CVSWORK is the directory
      ; being cd'd to (insert-string command)
      (ansi-color-for-comint-mode-on)
      (make-comint-in-buffer "rtk_test" rtktest-buffer shell-file-name nil shell-command-switch command)
      (set-process-sentinel (get-buffer-process rtktest-buffer) 'run-test-shell-stop))))

(defun run-test-shell-stop (process event)
  (save-excursion
    (set-buffer rtktest-buffer)
    (rtktest-mode)))

(defun rtk-run-test-command (test-name)
  (let* ((module-file-name (file-name-nondirectory buffer-file-name))
         (dir (file-directory buffer-file-name))
         (buffer (get-buffer-create "*rtk_test*"))
         (command (format "cd %s && rtk_test -h" dir)))
    (if (or (null test-name) (= 0 (length test-name)))
        (setq command (concat command " -c"))
      (setq command (concat command " -f " test-name)))
    (setq command (concat command " " module-file-name))
    command))

(defun test-module-name (module)
  (if (string-match "\\:\\:TEST\\:\\:" module)
      module
    (let ((base-module (trim-module-name module))
          (parent-module (parent-module-name module)))
      (format "%s::TEST::%s" parent-module base-module))))

(defun current-test-file-name ()
  (let ((file-name (buffer-file-name)))
    (if (string-match "/TEST/" file-name)
        file-name
      (replace-regexp-in-string "\\(.+\\)/\\(.+\\.pm\\)$" "\\1/TEST/\\2" file-name))))

(defun current-implementation-file-name ()
  (replace-regexp-in-string "/TEST/" "/" (buffer-file-name)))

(defun implementation-module-name (module)
  (if (string-match "\\:\\:TEST\\:\\:" module)
      (format "%s::%s" (parent-module-name (parent-module-name module)) (trim-module-name module))
    module))

(defun parent-module-name (module)
  (progn
    (string-match "\\(.*\\)\\:\\:[A-Za-z0-9_]+" module)
    (substring module (match-beginning 1) (match-end 1))))

(defun module-to-path (base-dir module)
  (format "%s/%s.pm" base-dir (replace-regexp-in-string "\\:\\:" "/" module)))

(defun component-file-name (component-name)
  (component-to-path (current-htdocs-base-path) component-name))

(defun component-to-path (base-dir component-name)
  (if (equal (substring component-name 0 1) "/")
      (concat base-dir component-name)
    (concat (file-directory (buffer-file-name)) "/" component-name)))



;;
;; rtk-test-mode
;;
(defvar rtktest-mode-map (make-sparse-keymap)
  "Keymap for Test Output mode.")
(define-key rtktest-mode-map [mouse-2] 'rtktest-follow-mouse)
(define-key rtktest-mode-map "\r" 'rtktest-follow)

(defcustom rtktest-mode-hook nil
  "Hook run by `rtktest-mode'."
  :type 'hook
  :group 'rtk)

(defun rtktest-mode ()
  "Major mode for viewing test output and navigating references in it.
Entry to this mode runs the normal hook `rtktest-mode-hook'.
Commands:
\\{rtktest-mode-map}"
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max))
  (kill-all-local-variables)
  (use-local-map rtktest-mode-map)
  (setq mode-name "RTKTest")
  (setq major-mode 'rtktest-mode)
  (rtktest-scan-test-names)
  (rtktest-scan-for-warning-line-numbers)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults nil)         ; font-lock would defeat xref
;  (view-mode)
;  (make-local-variable 'view-no-disable-on-exit)
;  (setq view-no-disable-on-exit t)
  (run-hooks 'rtktest-mode-hook))

(defun rtktest-scan-test-names ()
  "Scan for symbols like TEST_FOO and set up xrefs"
  (interactive)
  (let ((module-name nil))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\(Testing \\(RTK::[:a-zA-Z0-9]+\\)\\)\\|\\(TEST_[A-Za-z0-9_]+\\)" nil t)
        (if (match-beginning 1)
            (setq module-name (match-string 2))
          (add-text-properties (match-beginning 3) (match-end 3)
                               (list 'mouse-face 'highlight
                                     'rtktest-xref (list (match-string 3)
                                                         module-name))))))))

(defun rtktest-scan-for-warning-line-numbers ()
  "Scan for die/warn output and hyperlink as appropriate"
  (interactive)
  (let ((real-base-path nil))
    (save-excursion
      (goto-char (point-min))
      (and (re-search-forward "[/a-zA-Z0-9_-]+")
           (setq real-base-path (match-string 0)))
      (while (re-search-forward (concat real-base-path 
                                        "/\\([a-zA-Z/0-9_.-]+\\),? line \\([0-9]+\\)") nil t)
        (add-text-properties (match-beginning 0) (match-end 0)
                             (list 'mouse-face 'highlight
                                   'rtktest-warn (list (match-string 1) (match-string 2))))))))

(defun rtktest-follow-mouse (click)
  "Follow the test link that you click on."
  (interactive "e")
  (let* ((start (event-start click))
	 (window (car start))
	 (pos (car (cdr start))))
    (with-current-buffer (window-buffer window)
      (rtktest-follow pos))))

(defun rtktest-follow (&optional pos)
  "Follow the test link at POS, defaulting to point."
  (interactive "d")
  (unless pos
    (setq pos (point)))
  (and (get-text-property pos 'rtktest-xref)
       (let* ((xref-data (get-text-property pos 'rtktest-xref))
              (test (car xref-data))
              (module (car (cdr xref-data)))
              (module-path (module-to-path rtktest-base-path module)))
         (find-file module-path)
         (goto-char (point-min))
         (search-forward (concat "sub " test)) ))
  (and (get-text-property pos 'rtktest-warn)
       (let* ((warn-data (get-text-property pos 'rtktest-warn))
              (module (car warn-data))
              (line (car (cdr warn-data)))
              (path (concat rtktest-base-path "/" module)))
         (find-file path)
         (goto-line (string-to-int line)))))
         
         
    
