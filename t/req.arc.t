(push-loadpath "lib")

(load "test.arc")
(load "epona/req.arc")

; parseargs  -----------------------------------------------------------------

(test (parseargs "") nil iso)
(test (parseargs "foo=foo&bar=bar") '(("foo" "foo") ("bar" "bar")) iso)
(test (parseargs "foo=%e3%81%82%e3%81%84%e3%81%86%e3%81%88%e3%81%8a") '(("foo" "あいうえお")) iso)

; parsebody  -----------------------------------------------------------------

(test (parsebody "" nil) nil iso)
(test (parsebody "" '(("content-type" "application/x-www-form-urlencoded"))) nil iso)
(test (parsebody "foo=foo&bar=bar" nil) nil iso)
(test (parsebody "foo=foo&bar=bar" '(("content-type" "application/x-www-form-urlencoded")))  '(("foo" "foo") ("bar" "bar")) iso)
(test (parsebody "foo=%e3%81%82%e3%81%84%e3%81%86%e3%81%88%e3%81%8a" '(("content-type" "application/x-www-form-urlencoded"))) '(("foo" "あいうえお")) iso)

; parsecooks  ----------------------------------------------------------------

(test (parsecooks "") nil iso)
(test (parsecooks "foo=foo; bar=bar;") '(("foo" "foo") ("bar" "bar")) iso)

(= head* "Host: example.com\r\nAccept: text/html\r\n\r\n")
(= body* "foo=foo&bar=bar\r\n")

; readheads  -----------------------------------------------------------------

(test (readheads (instring head*)) '(("host" "example.com") ("accept" "text/html")) iso)

; readbody  ------------------------------------------------------------------

(test (readbody (instring body*) '(("content-length" 15))) "foo=foo&bar=bar")
(test (readbody (instring body*) nil) nil)

; readreq  -------------------------------------------------------------------

(= req1* (string "GET /foo HTTP/1.1\r\n" head*))
(test (readreq (instring req1*) "192.168.0.1") (obj op '/foo heads '(("host" "example.com") ("accept" "text/html")) ip "192.168.0.1" path "/foo" prot "HTTP/1.1" meth 'get) istab)
(= req2* (string "GET /foo?bar=bar&baz=baz HTTP/1.1\r\n" head*))
(test (readreq (instring req2*) "192.168.0.1") (obj op '/foo heads '(("host" "example.com") ("accept" "text/html")) ip "192.168.0.1" args '(("bar" "bar") ("baz" "baz")) qs "bar=bar&baz=baz" prot "HTTP/1.1" meth 'get path "/foo?bar=bar&baz=baz") istab)
(= req3* (string "POST /foo HTTP/1.1\r\nContent-Length: 15\r\nContent-Type: application/x-www-form-urlencoded\r\n" head* body*))
(test (readreq (instring req3*) "192.168.0.1") (obj op '/foo heads '(("content-length" "15") ("content-type" "application/x-www-form-urlencoded") ("host" "example.com") ("accept" "text/html")) ip "192.168.0.1" body "foo=foo&bar=bar" args '(("foo" "foo") ("bar" "bar")) prot "HTTP/1.1" meth 'post path "/foo") istab)
(= req4* (string "POST /foo HTTP/1.1\r\nContent-Length: 15\r\n" head* body*))
(test (readreq (instring req4*) "192.168.0.1") (obj op '/foo heads '(("content-length" "15") ("host" "example.com") ("accept" "text/html")) ip "192.168.0.1" body "foo=foo&bar=bar" prot "HTTP/1.1" meth 'post path "/foo") istab)
(= req5* (string "GET /foo HTTP/1.1\r\nX-REAL-IP: 192.168.0.2\r\n" head*))
(test (readreq (instring req5*) "192.168.0.1") (obj op '/foo heads '(("x-real-ip" "192.168.0.2") ("host" "example.com") ("accept" "text/html")) ip "192.168.0.2" path "/foo" prot "HTTP/1.1" meth 'get) istab)
(= req6* (string "GET /foo HTTP/1.1\r\nCookie: foo=foo; bar=bar;\r\n" head*))
(test (readreq (instring req6*) "192.168.0.1") (obj op '/foo heads '(("cookie" "foo=foo; bar=bar;") ("host" "example.com") ("accept" "text/html")) ip "192.168.0.1" path "/foo" prot "HTTP/1.1" meth 'get cooks '(("foo" "foo") ("bar" "bar"))) istab)

; w/request  -----------------------------------------------------------------

(= req7* (inst 'request 'op '/foo 'heads '(("host" "example.com") ("accept" "text/html")) 'args '(("foo" "foo")) 'cooks '(("bar" "bar"))))
(test (w/request req7* arg!foo) "foo")
(test (w/request req7* arg!boo) nil)
(test (w/request req7* (arg 'boo "boo")) "boo")
(test (w/request req7* head!host) "example.com")
(test (w/request req7* head!foo) nil)
(test (w/request req7* (head 'foo "foo")) "foo")
(test (w/request req7* cook!bar) "bar")
(test (w/request req7* cook!foo) nil)
(test (w/request req7* (cook 'foo "foo")) "foo")

(run-test)

; vim: ft=arc
