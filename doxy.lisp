(cl:in-package :doxy)

;;;
;;; Rewritten from dto's https://gitlab.com/dto/xelf/blob/master/doc.lisp
;;;


(declaim (special *renderer*))


(defgeneric document-class (renderer name docstring))
(defgeneric document-function (renderer name lambda-list docstring))
(defgeneric document-macro (renderer name lambda-list docstring))
(defgeneric document-generic (renderer name lambda-list docstring))
(defgeneric document-variable (renderer name docstring))


(defun %document-function (symbol)
  (let ((args (sb-introspect:function-lambda-list (or (and (symbolp symbol) (macro-function symbol))
						      (fdefinition symbol))))
        (reporter (cond
                    ((and (symbolp symbol) (macro-function symbol)) #'document-macro)
                    ((typep (fdefinition symbol) 'standard-generic-function) #'document-generic)
                    (t #'document-function))))
    (funcall reporter *renderer* symbol args (documentation symbol 'function))))


(defun %document-variable (symbol)
  (document-variable *renderer* symbol (documentation symbol 'variable)))


(defun %document-class (symbol)
  (let* ((class (find-class symbol))
         (docstring (documentation class t)))
    (document-class *renderer* symbol docstring)))


(defun document-all-symbols (symbols)
  (loop for sym in symbols
     when (fboundp sym)
     collect (cons sym (%document-function sym))
     when (fboundp `(setf ,sym))
     collect (let ((sym `(setf ,sym)))
               (cons sym (%document-function sym)))
     when (find-class sym nil)
     collect (cons sym (%document-class sym))
     when (boundp sym)
     collect (cons sym (%document-variable sym))))


(defun list-external-symbols (package-name)
  (let ((package (find-package package-name)))
    (loop for symbol being the external-symbol in package
       collect symbol)))


(defun collect-documentation (renderer &rest symbols)
  (let ((*renderer* renderer))
    (document-all-symbols symbols)))


(defun collect-package-documentation (renderer package-name)
  (collect-documentation renderer (list-external-symbols package-name)))
