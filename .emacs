;; Mason Crap BEGIN
(push "~/rtklisp" load-path)
(push "~/elisp" load-path)
;(push "/home/bjk/info" Info-directory-list)

(require 'mmm-mode)
(load-library "mmm-mason")
(load-library "mmm-sample")

(require 'scroll-in-place)

(require 'cyclebuffer)

;(require 'xtla-autoloads)
;; (set-face-background 'mmm-default-submode-face "gray97")
(set-face-background 'mmm-default-submode-face nil)
(add-to-list 'mmm-mode-ext-classes-alist
  '(html-mode "\\.html\\'" mason))         ;; Any .html file in html-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(html-mode nil html-js))                ;; Add js to any file in html-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(html-mode nil embedded-css))           ;; Add css to any file in html-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(html-mode "\\(auto\\|d\\)handler\\'" mason)) ;; Any handler in html-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(hm--html-mode nil mason))              ;; Any buffer in hm--html-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(sgml-mode nil mason))                  ;; Any buffer in sgml-mode
(add-to-list 'mmm-mode-ext-classes-alist
  '(nil "\\.\\(mason\\|html\\)\\'" mason)) ;; All .mason and .html files
(add-to-list 'mmm-mode-ext-classes-alist
  '(nil "\\.m[dc]\\'" mason))              ;; All .md and .mc files
(add-to-list 'mmm-mode-ext-classes-alist
  '(nil "\\`/var/www/mason/" mason))       ;; Any file in the directory
(setq mmm-global-mode 'maybe)
(add-to-list 'auto-mode-alist '("\\(auto\\|d\\)handler\\'" . html-mode))
;; Mason Crap END

(defalias 'perl-mode 'cperl-mode)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("/home/bjk/info")))
 '(case-fold-search t)
 '(column-number-mode t)
 '(cperl-brace-offset -4)
 '(cperl-close-paren-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-electric-linefeed nil)
 '(cperl-electric-parens-string "")
 '(cperl-font-lock t)
 '(cperl-hairy nil)
 '(cperl-indent-left-aligned-comments nil)
 '(cperl-indent-level 4)
 '(cperl-indent-parens-as-block t)
 '(cperl-message-electric-keyword nil)
 '(cperl-under-as-char t)
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(current-language-environment "ASCII")
 '(delete-selection-mode t)
 '(display-battery-mode nil)
 '(display-time-mode nil)
 '(frame-background-mode (quote dark))
 '(global-font-lock-mode t nil (font-lock))
 '(indent-tabs-mode nil)
 '(mmm-submode-decoration-level 0)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-mode t nil (mwheel))
 '(require-final-newline t)
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(tool-bar-mode nil nil (tool-bar))
 '(track-eol t)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 ;; '(default ((t (:stipple nil :background "black" :foreground "LightGrey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 111 :width normal :family "Bitstream Vera Sans Mono"))))
 '(cperl-array-face ((t (:foreground "yellow" :weight bold))) t)
 '(cperl-hash-face ((t (:foreground "orchid" :slant italic :weight bold))) t))
(add-to-list 'default-frame-alist '(foreground-color . "LightGrey"))
(add-to-list 'default-frame-alist '(background-color . "black"))
(add-to-list 'default-frame-alist '(cursor-color . "red"))

(put 'eval-expression 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)

;; Bruce's functions

(defun my-shell-command (command &optional output-buffer error-buffer)
  "IMPORIVED!"
  (interactive (list (read-from-minibuffer "Shell command: "
					   nil nil nil 'shell-command-history)
		     current-prefix-arg
		     shell-command-default-error-buffer))
  (shell-command (replace-regexp-in-string "%" (buffer-file-name) command) output-buffer error-buffer))


(defun kill-current-buffer-no-confirm ()
  "oo"
  (interactive)
  (kill-buffer (current-buffer)))

(defun copy-char-above ()
  "Copys character above the cursor"
  (interactive)
  (insert
   (save-excursion
     (let ((goal-column (current-column)))
       (previous-line 1)
       (following-char)))))
     
(byte-compile 'copy-char-above)

(defun kill-trailing-space (start end)
  "Kill trailing whitespace"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (while (re-search-forward "[ \t]+$" nil t)
	(replace-match "")))))

(defun quick-kill-trailing-space ()
  "Blah"
  (interactive)
  (kill-trailing-space (point-min) (point-max)))

(defun perl-indent-or-dabbrev (&optional arg)
  "C mode tab thing"
  (interactive "*P")
  (if (save-excursion
        (skip-chars-backward " \t")
        (not (bolp)))
      (dabbrev-expand arg)
    (cperl-indent-command arg)))

(defun scroll-down-one-line ()
  "Up one line"
  (interactive)
  (let ((scroll-default-lines 1))
    (scroll-up)))

(defun scroll-up-one-line ()
  "Up one line"
  (interactive)
  (let ((scroll-default-lines 1))
    (scroll-down)))

(defun isearch-yank-whole-word ()
  "Pull next whole word from buffer into search string."
  (interactive)
  (isearch-yank-string
   (save-excursion
     (and (not isearch-forward) isearch-other-end
	  (goto-char isearch-other-end))
     (buffer-substring-no-properties
      (progn (backward-word 1) (point)) (progn (forward-word 1) (point))))))

(define-key isearch-mode-map "\C-w" 'isearch-yank-whole-word)

(defun kill-current-line ()
  (interactive)
  (let ((target-column (current-column)))
    (beginning-of-line)
    (kill-line)
    (kill-line)
    (move-to-column target-column)))

(require 'redo)

(define-key esc-map "!" 'my-shell-command)
(global-set-key [f1]		'undo)
(global-set-key [C-f1]	'redo)
(global-set-key [S-f1]	'quick-kill-trailing-space)
(global-set-key [f2]		'replace-string)
(global-set-key [S-f2]	'query-replace)
(global-set-key [C-f2]	'query-replace-regexp)
(global-set-key [f3]		'font-lock-fontify-buffer)
(global-set-key [f4]		'switch-to-buffer)
(global-set-key [S-f4]	'insert-buffer)
(global-set-key [C-f4]	'kill-buffer)
(global-set-key [f5]		'goto-line)
(global-set-key [S-f5]	'what-line)
(global-set-key [f9]    'copy-char-above)
(global-set-key [f10]		'save-buffer)
  ;;(global-set-key 'f11	'my-server-edit)
  ;;(global-set-key '(shift f11)	'find-server-buffer)
(global-set-key [C-f11] 	'kill-current-buffer-no-confirm)
(global-set-key [pause]	'repeat-complex-command)
(defun nop () "Nop" (interactive))
(global-set-key [insert]	'nop)
(global-set-key [S-up]          'scroll-up-one-line)
(global-set-key [S-down]        'scroll-down-one-line)
(global-set-key [C-delete]      'kill-current-line)

(global-unset-key [?\C-z])
(global-unset-key [?\C-x ?\C-c])

(require 'rtkperl)
(load-library "RTAGS")
(global-unset-key [menu])
(global-set-key [menu ?t]  'rtktest-run-current-test)
(global-set-key [menu ?T]  'rtktest-run-current-module-test)
(global-set-key [menu ?S]  'rtktest-run-all-subsystem-tests)
(global-set-key [menu ?d]  'rtktest-gud-debug-current-test)
(global-set-key [menu ?a]  'rtkperl-auto-tablize)
(global-set-key [menu ?i]  'rtkperl-import-symbol)
(global-set-key [menu ?q]  'rtkperl-align-qw)
(global-set-key [menu ?c]  'rtkperl-check-module)
(global-set-key [menu ?s]  'rtkperl-align-sql)
(global-set-key [menu ?g ?m] 'rtkperl-find-module-at-point-fuzzy)
;(global-set-key [menu ?g ?m] 'rtkperl-find-module-on-current-line)
(global-set-key [menu ?g ?t] 'rtkperl-find-test-module)
(global-set-key [menu ?g ?i] 'rtkperl-find-implementation-module)
(global-set-key [menu ?g ?u] 'rtkperl-find-testutil-module)
(global-set-key [menu ?g ?b] 'rtkperl-find-base-module)
(global-set-key [menu ?g ?c] 'rtkperl-find-component-on-current-line)
(global-set-key [?\C-c ?c]  'rtkperl-check-module)
(global-set-key [M-n] 'cyclebuffer-forward)
(global-set-key [M-p] 'cyclebuffer-backward)

(require 'cua-rect)
(cua--init-rectangles)
(cua--rect-M/H-key ?z	'rtkperl-cua-power-two-rectangle)

(defun my-join-line ()
  (interactive)
  (join-line t))

(global-set-key (quote [25165930]) 'my-join-line)

(require 'cperl-mode)
(define-key cperl-mode-map [return] 'newline-and-indent)
(define-key cperl-mode-map [tab]    'perl-indent-or-dabbrev)
(setq signal-error-on-buffer-boundary nil)

(require 'which-func)

(defun my-cperl-mode-hook ()
  "CPerl hook"
  (imenu-add-menubar-index))

(defun cleanup-perl-subs (arg)
  "Cleanup perl subs"
  (replace-regexp-in-string ".*::" "" arg))

(setq which-func-cleanup-function 'cleanup-perl-subs)

(add-hook 'cperl-mode-hook 'my-cperl-mode-hook)


(put 'narrow-to-region 'disabled nil)
