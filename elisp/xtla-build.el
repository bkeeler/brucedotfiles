;;; xtla-build.el --- compile-time helper.

;; Copyright (C) 2004 FSF.

;; Author: Steve Youngs <steve@youngs.au.com>

;; This file is part of Xtla.
;;
;; Xtla is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; Xtla is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is used to load needed libraries at compile-time.  Think of it
;; as the xtla version of Gnus' dgnushack.el file.  It gets loaded via
;; $EXTRA_OPTS in the Makefile.  It is currently only used for XEmacs
;; builds but it would be trivial to add things here for GNU/Emacs as
;; well.


;; Things needed to ensure a clean build for XEmacs.
(when (featurep 'xemacs)
  (if (emacs-version>= 21 5)
      (autoload 'setenv "process" nil t)
    (autoload 'setenv "env" nil t))
  (autoload 'ad-add-advice "advice")
  (autoload 'customize-group "cus-edit" nil t)
  (autoload 'dired "dired" nil t)
  (autoload 'dired-other-window "dired" nil t)
  (autoload 'easy-mmode-define-keymap "easy-mmode")
  (autoload 'minibuffer-prompt-end "completer")
  (autoload 'mouse-avoidance-point-position "avoid")
  (autoload 'read-passwd "passwd")
  (autoload 'regexp-opt "regexp-opt")
  (autoload 'reporter-submit-bug-report "reporter")
  (autoload 'tla--flash-line "xtla")
  (autoload 'tla-tree-root "xtla")
  (autoload 'view-file-other-window "view-less" nil t)
  (autoload 'view-mode "view-less" nil t)
  (autoload 'with-electric-help "ehelp")
  (defalias 'tla--mouse-avoidance-point-position 'mouse-avoidance-point-position))

;;; xtla-build.el ends here
;; arch-tag: dfc914ba-8da6-470b-995b-03b09cd66592
