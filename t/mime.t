(push-loadpath "lib")

(require "epona/mime.arc")
(require "test.arc")

; mimetype  ------------------------------------------------------------------

(test is (mimetype "foo.txt")    "text/plain")
(test is (mimetype "foo.html")   "text/html")
(test is (mimetype "foo.css")    "text/css")
(test is (mimetype "foo.js")     "application/x-javascript")
(test is (mimetype "foo.json")   "application/json")
(test is (mimetype "foo.pdf")    "application/pdf")
(test is (mimetype "foo.atom")   "application/atom+xml")
(test is (mimetype "foo.gif")    "image/gif")
(test is (mimetype "foo.jpg")    "image/jpeg")
(test is (mimetype "foo.png")    "image/png")
(test is (mimetype "foo.ico")    "image/x-icon")
(test is (mimetype "foo.svg")    "image/svg+xml")
(test is (mimetype "foo.foo")    "application/octet-stream")
(test is (mimetype "foo" "foo")  "foo")
(test is (mimetype "txt")        "text/plain")
(test is (mimetype "html")       "text/html")

(done-testing)

; vim: ft=arc
