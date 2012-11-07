;;;; weblocks-mustache-template-form-view.lisp

(in-package #:weblocks-mustache-template-form-view)

;;; "weblocks-mustache-template-form-view" goes here. Hacks and glory await!

(defclass mustache-template-form-view (form-view)
  ((template :initform nil :initarg :template)
   (put-template-into-form :initarg :surround-with-form-template :initform t)))

(setf (find-class 'mustache-template-form-view-field) (find-class 'form-view-field))

(defmethod mustache-template-form-view-template ((view mustache-template-form-view))
  (with-slots (template) view
    (etypecase template
      (function template)
      ; XXX: not tested
      (string (mustache:mustache-compile template)))))

(defmacro capture-weblocks-output (&body body)
  `(let ((*weblocks-output-stream* (make-string-output-stream)))
     ,@body 
     (get-output-stream-string *weblocks-output-stream*)))

(defun add-mustache-suppliers (list)
  (loop for i in list append 
        (list 
          i
          (cons (intern 
                  (format nil "~A-SUPPLIED-P" (string (car i))) "KEYWORD")
                (not (null (cdr i)))))))

(defmethod with-view-header :around ((view mustache-template-form-view) 
                                     obj widget body-fn &rest args &key
                                     (method (form-view-default-method view))
                                     (action (form-view-default-action view))
                                     (fields-prefix-fn (view-fields-default-prefix-fn view))
                                     (fields-suffix-fn (view-fields-default-suffix-fn view))
                                     validation-errors
                                     &allow-other-keys)

  (with-slots (template put-template-into-form) view
    (if template 

      (let ((form-id (gen-id))
            (header-class (format nil "view form mustache-form ~A"
                                  (attributize-name (object-class-name obj)))))
        (when (>= (count-view-fields view)
                  (form-view-error-summary-threshold view))
          (setf header-class (concatenate 'string header-class " long-form")))

        (if put-template-into-form
          (let* ((form-title (when (view-caption view)
                               (format nil (view-caption view) (humanize-name (object-class-name obj)))))
                 (form-validation-summary (capture-weblocks-output (render-validation-summary view obj widget validation-errors)))
                 (form-view-buttons (capture-weblocks-output (apply #'render-form-view-buttons view obj widget args)))
                 (prefix-output (capture-weblocks-output (safe-apply fields-prefix-fn view obj args)))
                 (suffix-output (capture-weblocks-output (safe-apply fields-suffix-fn view obj args)))
                 (form-body (capture-weblocks-output (apply body-fn view obj args)))
                 (mustache-args `((:form-title . ,form-title)
                                  (:form-validation-summary . ,form-validation-summary)
                                  (:form-view-buttons . ,form-view-buttons)
                                  (:prefix-output . ,prefix-output)
                                  (:suffix-output . ,suffix-output)
                                  (:form-body . ,form-body)))
                 (form-body
                   (let ((mustache:*mustache-output* (make-string-output-stream)))
                     (funcall template (add-mustache-suppliers mustache-args))
                     (get-output-stream-string mustache:*mustache-output*))))
            (weblocks:with-html-form (method action
                                             :id (when (form-view-focus-p view) form-id)
                                             :class header-class
                                             :enctype (form-view-default-enctype view)
                                             :extra-submit-code (render-form-submit-dependencies *form-submit-dependencies*)
                                             :use-ajax-p (form-view-use-ajax-p view))
                                     (write-string form-body weblocks:*weblocks-output-stream*)))
          (error "Unimplemented"))
        (when (form-view-focus-p view)
          (send-script (ps* `((@ ($ ,form-id) focus-first-element))))))

      (call-next-method))))
