(push-loadpath "lib")

(load "test.arc")
(load "epona/mimetype.arc")

; mimetype  ------------------------------------------------------------------

(test (mimetype "foo.html") "text/html; charset=utf-8")
(test (mimetype "foo.htm")  "text/html; charset=utf-8")
(test (mimetype "foo.css")  "text/css; charset=utf-8")
(test (mimetype "foo.txt")  "text/plain; charset=utf-8")
(test (mimetype "foo.xml")  "application/xml; charset=utf-8")
(test (mimetype "foo.atom") "application/atom+xml; charset=utf-8")
(test (mimetype "foo.rss")  "application/rss+xml; charset=utf-8")
(test (mimetype "foo.js")   "application/x-javascript; charset=utf-8")
(test (mimetype "foo.swf")  "application/x-shockwave-flash")
(test (mimetype "foo.pdf")  "application/pdf")
(test (mimetype "foo.gif")  "image/gif")
(test (mimetype "foo.jpeg") "image/jpeg")
(test (mimetype "foo.jpg")  "image/jpeg")
(test (mimetype "foo.png")  "image/png")
(test (mimetype "foo.tif")  "image/tiff")
(test (mimetype "foo.tiff") "image/tiff")
(test (mimetype "foo.ico")  "image/x-icon")
(test (mimetype "foo.svg")  "image/svg+xml")
(test (mimetype "foo.foo")  "application/octet-stream")

(run-test)

; vim: ft=arc
