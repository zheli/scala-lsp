;;; config.el --- Scala(lsp) Layer configuration File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Zhe Li <zhe@zhe-mt-macbook-pro>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; TODO Perhaps should call this scala-lsp-mode
(spacemacs|define-jump-handlers scala-mode)

(defvar scala-enable-eldoc nil
  "If non nil then eldoc-mode is enabled in the scala layer.")

(defvar scala-auto-insert-asterisk-in-comments nil
  "If non-nil automatically insert leading asterisk in multi-line comments.")

(defvar scala-use-unicode-arrows nil
  "If non-nil then `->`, `=>` and `<-` are replaced with unicode arrows.")

(defvar scala-auto-start-metals nil
  "If non nil then metals will be started when a scala file is opened.")
