(cl:defpackage :doxy
  (:use :cl :alexandria)
  (:export document-class
           document-function
           document-macro
           document-generic
           document-variable

           collect-documentation
           collect-package-documentation))
