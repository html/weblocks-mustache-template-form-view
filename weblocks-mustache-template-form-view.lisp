;;;; weblocks-mustache-template-form-view.lisp

(in-package #:weblocks-mustache-template-form-view)

;;; "weblocks-mustache-template-form-view" goes here. Hacks and glory await!

(defclass mustache-template-form-view (form-view)
  ())

(setf (find-class 'mustache-template-form-view-field) (find-class 'form-view-field))
