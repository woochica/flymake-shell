;;; flymake-shell.el --- Flymake Shell mode

;;; Commentary:
;;
;; You may find more info at:
;; http://www.emacswiki.org/emacs/FlymakeShell
;;
;; Usage:
;; (require 'flymake-shell)
;; (add-hook 'sh-mode-hook 'flymake-shell-load)
;;

;;; History:
;; 

(require 'flymake)

;;; Code:
(defgroup flymake-shell nil
  "Customizations for Flymake Shell."
  :group 'flymake)

(defcustom flymake-shell-of-choice
  "/bin/bash"
  "Path of shell."
  :type '(file :must-match t)
  :group 'flymake-shell)

(defcustom flymake-shell-arguments
  (list "-n")
  "Shell arguments to invoke syntax checking."
  :type 'string
  :group 'flymake-shell)

(defconst flymake-allowed-shell-file-name-masks
  '(("\\.sh$" flymake-shell-init))
  "Filename extensions that switch on flymake-shell mode syntax checks."
  :group 'flymake-shell)

(defcustom flymake-shell-err-line-pattern-re
  '(("^\\(.+\\): line \\([0-9]+\\): \\(.+\\)$" 1 2 nil 3))
  "Regexp matching JavaScript error messages."
  :group 'flymake-shell)

(defun flymake-shell-init ()
  "Return list of the command and its arguments used to syntax check."
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list
     flymake-shell-of-choice (append flymake-shell-arguments (list local-file)))))
 
(defun flymake-shell-load ()
  "Load Flymake Shell."
  (setq flymake-allowed-file-name-masks
        (append flymake-allowed-file-name-masks flymake-allowed-shell-file-name-masks))
  (setq flymake-err-line-patterns
        (append flymake-err-line-patterns flymake-shell-err-line-pattern-re))
  (flymake-mode t)
  (local-set-key (kbd "C-c d") 'flymake-display-err-menu-for-current-line))

(provide 'flymake-shell)

;;; flymake-shell.el ends here
