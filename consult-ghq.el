;;; consult-ghq.el --- ghq with consult -*- lexical-binding: t; -*-

;; Copyright (C) 2010-2018 Youhei SASAKI <uwabami@gfd-dennou.org>

;; Author: Youhei SASAKI <uwabami@gfd-dennou.org>
;; $Lastupdate: 22021-06-08 13:34:40$
;; Version: 0.0.2
;; Package-Requires: ((emacs "27.1") (consult "0.8"))
;; Keywords: tools
;; URL: https://github.com/uwabami/consult-ghq

;; This file is not part of GNU Emacs.
;;
;; License:
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentry:

;; original version is https://github.com/masutaka/emacs-helm-ghq

;;; Code:

(defgroup consult-ghq nil
  "ghq with ido interface"
  :prefix "consult-ghq-"
  :group 'consult)

(defcustom consult-ghq-command
  "ghq"
  "*A ghq command"
  :type 'string
  :group 'consult-ghq)

(defcustom consult-ghq-command-arg-root
  '("root")
  "*Arguments for getting ghq root path using ghq command"
  :type '(repeqt string)
  :group 'consult-ghq)

(defcustom consult-ghq-short-list nil
  "*Whether display full path or short path"
  :type 'boolean
  :group 'consult-ghq)

(defun consult-ghq--command-arg-list ()
  (if consult-ghq-short-list
      '("list")
    '("list" "--full-path")))

(defun consult-ghq--open-dired (file)
  (dired
   (if consult-ghq-short-list
       (format "%s%s" (consult-ghq--get-root) file)
     (format "%s" file))))

(defun consult-ghq--get-root ()
  (with-temp-buffer
    (unless (zerop (apply #'call-process
                          consult-ghq-command nil t nil
                          consult-ghq-command-arg-root))
      (error "Failed: Can't get ghq's root"))
    (replace-regexp-in-string "\n+$" "/"
                              (buffer-substring-no-properties
                               (goto-char (point-min))(goto-char (point-max))))))

(defun consult-ghq--list-candidates ()
  (with-temp-buffer
    (unless (zerop (apply #'call-process
                          consult-ghq-command nil t nil
                          (consult-ghq--command-arg-list)))
      (error "Failed: Can't get ghq list candidates"))
    (let ((paths))
      (goto-char (point-min))
      (while (not (eobp))
        (push
         (buffer-substring-no-properties
          (line-beginning-position) (line-end-position))
         paths)
        (forward-line 1))
      (reverse paths))))

;;; autoload
(defun consult-ghq-open ()
  "Use `completing-read' to \\[dired] a ghq list"
  (interactive)
  (find-file
   (consult--read
    (or (consult-ghq--list-candidates)
        (user-error "No ghq repository"))
    :prompt "Find recent file: "
    :sort nil
    :require-match t
    :category 'file
    :state (consult--file-preview)
    )))


(provide 'consult-ghq)
;;; consult-ghq.el ends here
