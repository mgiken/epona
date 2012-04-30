(push-loadpath "lib")

(require "epona/req.arc")
(require "test.arc")

; parseargs  -----------------------------------------------------------------

(test iso (parseargs "") nil)
(test iso (parseargs "foo=foo&bar=bar") '(("foo" "foo") ("bar" "bar")))
(test iso (parseargs "foo=%e3%81%82%e3%81%84%e3%81%86%e3%81%88%e3%81%8a")
          '(("foo" "あいうえお")))

; parsecooks  ----------------------------------------------------------------

(test iso (parsecooks "") nil)
(test iso (parsecooks "foo=foo; bar=bar;") '(("foo" "foo") ("bar" "bar")))

; parsebody  -----------------------------------------------------------------

(= h '(("content-type" "application/x-www-form-urlencoded")))
(test iso (parsebody "" nil) nil)
(test iso (parsebody "" h) nil)
(test iso (parsebody "foo=foo&bar=bar" nil) nil)
(test iso (parsebody "foo=foo&bar=bar" h)  '(("foo" "foo") ("bar" "bar")))
(test iso (parsebody "foo=%e3%81%82%e3%81%84%e3%81%86%e3%81%88%e3%81%8a" h)
          '(("foo" "あいうえお")))

; readheads ------------------------------------------------------------------

(test iso (readheads (instring "Foo-foo: foo\r\nbar: bar\r\n\r\n"))
          '(("foo-foo" "foo") ("bar" "bar")))

; readbody -------------------------------------------------------------------

(test is (readbody (instring "12345") '(("content-length" 5))) "12345")
(test is (readbody (instring "") '(("content-length" 0))) "")
(test is (readbody (instring "12345") nil) nil)

; readreq --------------------------------------------------------------------

(= h "Foo-foo: foo\r\nbar: bar\r\n\r\n" b "foo=foo&bar=bar\r\n")
(= r (string "GET /foo HTTP/1.1\r\n" h))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'get
                'path  "/foo"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    nil
                'heads '(("foo-foo" "foo") ("bar" "bar"))
                'body  nil
                'op    '/foo
                'args  nil
                'cooks nil
                'ip    "127.0.0.1"))

(= r (string "GET /foo?bar=bar&baz=baz HTTP/1.1\r\n" h))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'get
                'path  "/foo?bar=bar&baz=baz"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    "bar=bar&baz=baz"
                'heads '(("foo-foo" "foo") ("bar" "bar"))
                'body  nil
                'op    '/foo
                'args  '(("bar" "bar") ("baz" "baz"))
                'cooks nil
                'ip    "127.0.0.1"))

(= r (string "POST /foo HTTP/1.1\r\nContent-Length: 15\r\n\
Content-Type: application/x-www-form-urlencoded\r\n" h b))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'post
                'path  "/foo"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    nil
                'heads '(("content-length" "15")
                         ("content-type" "application/x-www-form-urlencoded")
                         ("foo-foo" "foo")("bar" "bar"))
                'body  "foo=foo&bar=bar"
                'op    '/foo
                'args  '(("foo" "foo") ("bar" "bar"))
                'cooks nil
                'ip    "127.0.0.1"))

(= r (string "POST /foo HTTP/1.1\r\nContent-Length: 15\r\n" h b))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'post
                'path  "/foo"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    nil
                'heads '(("content-length" "15")
                         ("foo-foo" "foo") ("bar" "bar"))
                'body  "foo=foo&bar=bar"
                'op    '/foo
                'args  nil
                'cooks nil
                'ip    "127.0.0.1"))

(= r (string "GET /foo HTTP/1.1\r\nX-REAL-IP: 192.168.0.1\r\n" h))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'get
                'path  "/foo"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    nil
                'heads '(("x-real-ip" "192.168.0.1")
                         ("foo-foo" "foo") ("bar" "bar"))
                'body  nil
                'op    '/foo
                'args  nil
                'cooks nil
                'ip    "192.168.0.1"))

(= r (string "GET /foo HTTP/1.1\r\nCookie: foo=foo; bar=bar;\r\n" h))
(test iso (readreq (instring r) "127.0.0.1")
          (inst 'request
                'meth  'get
                'path  "/foo"
                'prot  "HTTP/1.1"
                'base  "/foo"
                'qs    nil
                'heads '(("cookie" "foo=foo; bar=bar;")
                         ("foo-foo" "foo") ("bar" "bar"))
                'body  nil
                'op    '/foo
                'args  nil
                'cooks '(("foo" "foo") ("bar" "bar"))
                'ip    "127.0.0.1"))

(done-testing)

; vim: ft=arc
