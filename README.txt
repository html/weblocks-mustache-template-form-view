This is an attempt to use templates in weblocks forms.

Here is small example from my project. This is mustache view and weblocks form view which uses mustache view.
At this time only this way of usage is guaranteed, other cases not tested.

(mustache:defmustache simple-search-form-view 
                      (yaclml:with-yaclml-output-to-string 
                        (<:h1 
                          (<:as-is "{{form-title}}"))
                        (<:as-is "{{{form-validation-summary}}}")
                        (<:div :class "pull-left"
                               (<:as-is "{{{form-body}}}")) 
                        (<:div :class "pull-left" :style "padding-top:5px;"
                               (<:as-is "{{{form-view-buttons}}}"))))

(defview test-view (:persistp nil 
                    ; Following two strings matter
                    :type mustache-template-form 
                    :template #'simple-search-form-view

                    :buttons '((:submit . "Search")) 
                    :caption "Searching ...")
 (compare-value :label "" :present-as input)
 (switch-to-complex 
  :label "" 
  :present-as html 
  :reader (lambda (&rest args)
      ; ...
      )))

Apart from form-title, form-validation-summary, form-view-buttons and others some additional predicates assigned 
like form-title-supplied-p, form-validation-summary-supplied-p which can be used as mustache predicates, see following example.

(mustache:defmustache simple-form-view-using-advanced-stuff
 "Some test form {{#form-title-supplied-p}} We have form title and it is {{form-title}} {{/form-title-supplied-p}} {{form-body}}")

All variables assigned for forms are 

* form-title 
* form-validation-summary 
* form-view-buttons 
* prefix-output 
* suffix-output 
* form-body 

and their corresponding predicates also.
