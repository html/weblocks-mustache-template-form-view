;;;; weblocks-mustache-template-form-view.asd

(asdf:defsystem #:weblocks-mustache-template-form-view
  :serial t
  :description "Mustache-templated weblocks view class"
  :author "Olexiy Zamkoviy <olexiy.z@gmail.com>"
  :license "LLGPL"
  :version "0.0.2"
  :depends-on (:weblocks :cl-mustache)
  :components ((:file "package")
               (:file "weblocks-mustache-template-form-view")))

