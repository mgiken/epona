(push-loadpath "lib")

(require "epona/ctx.arc")
(require "test.arc")

; ctx ------------------------------------------------------------------------

(test is ctx nil)

; mkctx ---------------------------------------------------------------------

(test iso (mkctx (instring "GET /foo HTTP/1.1\r\n\r\n") "127.0.0.1")
          (inst 'context
                'req (inst 'request
                           'meth 'get
                           'path "/foo"
                           'prot  "HTTP/1.1"
                           'base  "/foo"
                           'qs    nil
                           'heads nil
                           'body  nil
                           'op    '/foo
                           'args  nil
                           'cooks nil
                           'ip    "127.0.0.1")
                'res (inst 'response)))

; arg ------------------------------------------------------------------------

(w/ctx (obj req (obj args '(("fook" "foov") ("bark" "barv"))))

(test is (arg 'fook) "foov")
(test is (arg 'bark) "barv")
(test is (arg 'bazk) nil)
(test is (arg 'bazk "bazv") "bazv")

)

; head -----------------------------------------------------------------------

(w/ctx (obj req (obj heads '(("fook" "foov") ("bark" "barv"))))

(test is (head 'fook) "foov")
(test is (head 'bark) "barv")
(test is (head 'bazk) nil)
(test is (head 'bazk "bazv") "bazv")

)

; cook -----------------------------------------------------------------------

(w/ctx (obj req (obj cooks '(("fook" "foov") ("bark" "barv"))))

(test is (cook 'fook) "foov")
(test is (cook 'bark) "barv")
(test is (cook 'bazk) nil)
(test is (cook 'bazk "bazv") "bazv")

)

; normalize-head-key ---------------------------------------------------------

(test is (normalize-head-key "") "")
(test is (normalize-head-key "foo") "Foo")
(test is (normalize-head-key "foo-foo") "Foo-Foo")

; sanitize-head-value --------------------------------------------------------

(test is (sanitize-head-value "") "")
(test is (sanitize-head-value "foo") "foo")
(test is (sanitize-head-value "foo\n") "foo")
(test is (sanitize-head-value "foo\r") "foo")
(test is (sanitize-head-value "foo\r\n") "foo")
(test is (sanitize-head-value "foo\n\r") "foo")

; sethead --------------------------------------------------------------------

(w/ctx (obj res (table))

(sethead 'fook "foov")
(test iso ctx!res!heads '(("Fook" "foov")))
(sethead "bark" "barv")
(test iso ctx!res!heads '(("Bark" "barv") ("Fook" "foov")))
(sethead "fook" "foov")
(test iso ctx!res!heads '(("Fook" "foov") ("Bark" "barv")))
(sethead "fook" "foov" t)
(test iso ctx!res!heads '(("Fook" "foov") ("Fook" "foov") ("Bark" "barv")))

)

; setbody --------------------------------------------------------------------

(w/ctx (obj res (table))

(setbody "foo")
(test is ctx!res!body "foo")

)

; setsta ---------------------------------------------------------------------

(w/ctx (obj res (table))

(setsta 404)
(test is ctx!res!sta 404)

)

; cookexpires ----------------------------------------------------------------

(redef seconds () 1335451200)
(test is (cookexpires -1) "Thu, 01-Jan-1970 00:00:00 GMT")
(test is (cookexpires 36000) "Fri, 27-Apr-2012 00:40:00 GMT")

; setcook --------------------------------------------------------------------

(w/ctx (obj res (table))

(setcook 'k1 "v1")
(test iso ctx!res!heads '(("Set-Cookie" "k1=v1")))
(setcook 'k2 "v2" 360000 "/" "example.com" t t)
(test iso ctx!res!heads
          '(("Set-Cookie" "k2=v2; \
expires=Mon, 30-Apr-2012 18:40:00 GMT; \
domaon=example.com; \
path=/; \
secure; httponly") ("Set-Cookie" "k1=v1")))

)

(done-testing)

; vim: ft=arc
