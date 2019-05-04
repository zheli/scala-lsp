;;; packages.el --- scala-lsp layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst scala-lsp-packages
  '(
    (lsp-scala :require lsp-mode)
    ggtags
    counsel-gtags
    helm-gtags
    noflet
    ;; package org requires org-babel which requires ob-scala which requires ensime
    ;; org
    scala-mode
    sbt-mode
    ))

(defun scala-lsp/init-noflet ()
  (use-package noflet))

;; org-babel require ob-scala which requires ensime
;; (defun scala-lsp/pre-init-org ()
;;   (spacemacs|use-package-add-hook org
;;     :post-config (add-to-list 'org-babel-load-languages '(scala . t))))

(defun scala-lsp/init-sbt-mode ()
  (use-package sbt-mode
    :defer t
    :config
    ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
    ;; allows using SPACE when in the minibuffer
    (substitute-key-definition
     'minibuffer-complete-word
     'self-insert-command
     minibuffer-local-completion-map)
    :init (spacemacs/set-leader-keys-for-major-mode 'scala-mode
            "b." 'sbt-hydra
            "bb" 'sbt-command)))

(defun scala-lsp/init-scala-mode ()
  (use-package scala-mode
    :defer t
    :init
    (progn
      (dolist (ext '(".cfe" ".cfs" ".si" ".gen" ".lock"))
        (add-to-list 'completion-ignored-extensions ext)))
    :config
    (progn
      ;; Automatically insert asterisk in a comment when enabled
      (defun scala-lsp/newline-and-indent-with-asterisk ()
        (interactive)
        (newline-and-indent)
        (when scala-auto-insert-asterisk-in-comments
          (scala-indent:insert-asterisk-on-multiline-comment)))

      (evil-define-key 'insert scala-mode-map
        (kbd "RET") 'scala/newline-and-indent-with-asterisk)

      ;; Automatically replace arrows with unicode ones when enabled
      (defconst scala-unicode-arrows-alist
        '(("=>" . "⇒")
          ("->" . "→")
          ("<-" . "←")))

      (defun scala-lsp/replace-arrow-at-point ()
        "Replace the arrow before the point (if any) with unicode ones.
An undo boundary is inserted before doing the replacement so that
it can be undone."
        (let* ((end (point))
               (start (max (- end 2) (point-min)))
               (x (buffer-substring start end))
               (arrow (assoc x scala-unicode-arrows-alist)))
          (when arrow
            (undo-boundary)
            (backward-delete-char 2)
            (insert (cdr arrow)))))

      (defun scala-lsp/gt ()
        "Insert a `>' to the buffer.
If it's part of a right arrow (`->' or `=>'),replace it with the corresponding
unicode arrow."
        (interactive)
        (insert ">")
        (scala/replace-arrow-at-point))

      (defun scala-lsp/hyphen ()
        "Insert a `-' to the buffer.
If it's part of a left arrow (`<-'),replace it with the unicode arrow."
        (interactive)
        (insert "-")
        (scala/replace-arrow-at-point))

      (when scala-use-unicode-arrows
        (define-key scala-mode-map
          (kbd ">") 'scala/gt)
        (define-key scala-mode-map
          (kbd "-") 'scala/hyphen))

      (evil-define-key 'normal scala-mode-map "J" 'spacemacs/scala-join-line)

      ;; Compatibility with `aggressive-indent'
      (setq scala-indent:align-forms t
            scala-indent:align-parameters t
            scala-indent:default-run-on-strategy
            scala-indent:operator-strategy))))

(defun scala-lsp/init-lsp-scala ()
  (use-package lsp-scala
    :after scala-mode
    :demand t
    :config
    (add-hook 'scala-mode
              (lambda ()
                (setq-local lsp-prefer-flymake nil)))
    :hook ((scala-mode) . lsp)))

(defun scala-lsp/post-init-ggtags ()
  (add-hook 'scala-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun scala-lsp/post-init-counsel-gtags ()
  (spacemacs/counsel-gtags-define-keys-for-mode 'scala-mode))

(defun scala-lsp/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'scala-mode))

;;; packages.el ends here
