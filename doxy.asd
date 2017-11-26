(asdf:defsystem :doxy
  :version "0.0.1"
  :author "David O'Toole <dto@xelf.me>, Pavel Korolev <dev@borodust.org>"
  :license "MIT"
  :depends-on (alexandria)
  :serial t
  :components ((:file "packages")
               (:file "doxy")))
