(push-loadpath "lib")

(require "epona/dispatch.arc")
(require "test.arc")

; render ---------------------------------------------------------------------

(test is (render html "foo") "<!DOCTYPE html>foo")
(test is (render html (<p "foo")) "<!DOCTYPE html><p>foo</p>")
(test is (render atom (<feed "foo"))
         "<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<feed xmlns=\"http://www.w3.org/2005/Atom\">foo</feed>")
(test is (render json (obj a "a")) "{\"a\":\"a\"}")
(test is (render text "foo") "foo")

; genroutfn ------------------------------------------------------------------
; TODO: more test

(w/ctx (obj res (inst 'response))
  (= f (genroutefn () html "foo"))
  (test isa f 'fn)
  (test is (f) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "text/html"))
                 body  "<!DOCTYPE html>foo")))

; defop ----------------------------------------------------------------------

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))

(defop (get /) () "foo")
(test is dispatch-idx*!get nil)
(test isa dispatch-tbl*!get!/ 'fn)
(w/ctx (obj res (inst 'response))
  (test is (dispatch-tbl*!get!/) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "text/html"))
                 body  "<!DOCTYPE html>foo")))

(defop (post "/foo") () "foo")
(test iso dispatch-idx*!post '("^/foo$"))
(test isa (dispatch-tbl*!post "^/foo$") 'fn)
(w/ctx (obj res (inst 'response))
  (test is ((dispatch-tbl*!post "^/foo$")) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "text/html"))
                 body  "<!DOCTYPE html>foo")))

(defop (get /bar json) () (obj a "a"))
(test is dispatch-idx*!get nil)
(test isa dispatch-tbl*!get!/bar 'fn)
(w/ctx (obj res (inst 'response))
  (test is (dispatch-tbl*!get!/bar) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "application/json"))
                 body  "{\"a\":\"a\"}")))

; defp -----------------------------------------------------------------------

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))

(defp / () "foo")
(test is dispatch-idx*!get nil)
(test isa dispatch-tbl*!get!/ 'fn)
(w/ctx (obj res (inst 'response))
  (test is (dispatch-tbl*!get!/) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "text/html"))
                 body  "<!DOCTYPE html>foo")))

(defp "/foo" () "foo")
(test iso dispatch-idx*!get '("^/foo$"))
(test isa (dispatch-tbl*!get "^/foo$") 'fn)
(w/ctx (obj res (inst 'response))
  (test is ((dispatch-tbl*!get "^/foo$")) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "text/html"))
                 body  "<!DOCTYPE html>foo")))

; deffeed --------------------------------------------------------------------

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))

(deffeed /foo () "foo")
(test is dispatch-idx*!get nil)
(test isa dispatch-tbl*!get!/foo 'fn)
(w/ctx (obj res (inst 'response))
  (test is (dispatch-tbl*!get!/foo) 'respond)
  (test iso ctx!res
            (obj sta   200
                 heads '(("Content-Type" "application/atom+xml"))
                 body  "<?xml version=\"1.0\" encoding=\"utf-8\"?>foo")))

; new-fnid -------------------------------------------------------------------

(redef rand-string (x) "foo")
(test is (new-fnid) 'foo)

; fnid -----------------------------------------------------------------------

(redef rand-string (x) "foo")
(redef seconds () 100)
(test is (fnid (fn () "foo")) "foo")
(test iso fn-ids* '((foo 100 86500)))
(test isa fn-tbl*!foo 'fn)

; harvest-fnids --------------------------------------------------------------

(push '(bar 10 1) fn-ids*)
(= fn-tbl*!bar (fn () "bar"))
(test iso fn-ids* '((bar 10 1) (foo 100 86500)))
(test isa fn-tbl*!bar 'fn)
(harvest-fnids)
(test iso fn-ids* '((foo 100 86500)))
(test is fn-tbl*!bar nil)

; find-op --------------------------------------------------------------------

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))
(defp / () "foo")
(defp "/bar" () "bar")
(test isa (find-op 'get '/) 'fn)
(test isa (find-op 'get '/bar) 'fn)
(test is (find-op 'get '/foo) nil)

; find-fn --------------------------------------------------------------------

(= fn-tbl* (table)
   fn-ids* nil)
(fnid (fn () "foo"))
(test isa (find-fn 'post "foo") 'fn)
(test is (find-fn 'post "foo") nil)
(test is (find-fn 'post "bar") nil)

; fnid-field -----------------------------------------------------------------

(test is (tostring:pr-node:fnid-field "foo")
         "<input name=\"fnid\" type=\"hidden\" value=\"foo\">")

; aform ----------------------------------------------------------------------

(w/ctx (obj req (obj path "foo"))
  (test is (tostring:pr-node:aform "foo" "foo")
           "<form action=\"foo\" method=\"post\">\
<input name=\"fnid\" type=\"hidden\" value=\"foo\">foo</form>"))

; notify ---------------------------------------------------------------------

(w/ctx (obj notify '("foo"))
  (test is (tostring:pr-node:notify)
           "<div class=\"notify\"><p>foo</p></div>"))
(w/ctx (obj notify '("foo" bar))
  (test is (tostring:pr-node:notify)
           "<div class=\"notify bar\"><p>foo</p></div>"))

; dispatch -------------------------------------------------------------------

(= appdir* "t/data")
(let (meth sta heads body)
     (dispatch (obj req (inst 'request 'meth 'get 'op 'foo.txt)
                    res (inst 'response)))
  (test is meth 'get)
  (test is sta 200)
  (test iso heads '(("Content-Length" "4") ("Content-Type" "text/plain")))
  (test isa body 'input))
(let (meth sta heads body)
     (dispatch (obj req (inst 'request 'meth 'get 'op '/foo)
                    res (inst 'response)))
  (test is meth 'get)
  (test is sta 404)
  (test iso heads '(("Content-Type" "text/html")))
  (test is body "404 Not Found"))

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))
(defp / () "foo")
(let (meth sta heads body)
     (dispatch (obj req (inst 'request 'meth 'get 'op '/)
                    res (inst 'response)))
  (test is meth 'get)
  (test is sta 200)
  (test iso heads '(("Content-Type" "text/html")))
  (test is body "<!DOCTYPE html>foo"))

(let (meth sta heads body)
     (dispatch (obj req (inst 'request 'meth 'get 'op '/)
                    res (inst 'response)))
  (test is meth 'get)
  (test is sta 200)
  (test iso heads '(("Content-Type" "text/html")))
  (test is body "<!DOCTYPE html>foo"))

(= fn-tbl* (table)
   fn-ids* nil)
(redef rand-string (x) "bar")
(w/ctx (obj req (inst 'request 'meth 'post 'op '/
                              'args '(("fnid" "bar")))
            res (inst 'response))
  (aform "bar" "bar")
  (let (meth sta heads body)
    (dispatch ctx)
    (test is meth 'post)
    (test is sta 200)
    (test iso heads '(("Content-Type" "text/html")))
    (test is body "<!DOCTYPE html>bar")))

; go -------------------------------------------------------------------------

(defp /go () "go")
(w/ctx (obj req (obj 'meth 'get) res (inst 'response))
  (let (meth sta heads body)
       (point go_ (go "/go" "foo" "bar"))
    (test is meth 'get)
    (test is sta 200)
    (test iso heads '(("Content-Type" "text/html")))
    (test is body "<!DOCTYPE html>go"))
  (test iso ctx!notify '("foo" "bar")))

; redirect -------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point redirect_ (redirect "/foo")) t)
  (test iso ctx!res
            (obj sta   301
                 heads '(("Location" "/foo") ("Content-Type" "text/html"))
                 body  nil)))

; fond -----------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point redirect_ (fond "/foo")) t)
  (test iso ctx!res
            (obj sta   302
                 heads '(("Location" "/foo") ("Content-Type" "text/html"))
                 body  nil)))

; seeother -------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point redirect_ (seeother "/foo")) t)
  (test iso ctx!res
            (obj sta   303
                 heads '(("Location" "/foo") ("Content-Type" "text/html"))
                 body  nil)))

; httperr --------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point httperr_ (httperr)) t)
  (test iso ctx!res
            (obj sta   404
                 heads '(("Content-Type" "text/html"))
                 body  "404 Not Found")))

; badreq ---------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point httperr_ (badreq)) t)
  (test iso ctx!res
            (obj sta   400
                 heads '(("Content-Type" "text/html"))
                 body  "400 Bad Request")))

; notfound -------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point httperr_ (notfound)) t)
  (test iso ctx!res
            (obj sta   404
                 heads '(("Content-Type" "text/html"))
                 body  "404 Not Found")))

; srverr ---------------------------------------------------------------------

(w/ctx (obj res (inst 'response))
  (test is (point httperr_ (srverr)) t)
  (test iso ctx!res
            (obj sta   500
                 heads '(("Content-Type" "text/html"))
                 body  "500 Internal Server Error")))


(done-testing)

; vim: ft=arc
