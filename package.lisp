;;;; package.lisp

(defpackage #:weblocks-mustache-template-form-view
  (:use #:cl #:weblocks)
  (:export #:mustache-template-form-view)
  (:import-from :weblocks-util #:gen-id #:object-class-name #:safe-apply))

