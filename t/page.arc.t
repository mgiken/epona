(push-loadpath "lib")

(require "test.arc")
(require "epona/page.arc")

; <html5shim  ----------------------------------------------------------------

(test (tostring:<html5shim) "<!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]-->")
;(test (inc-css nil) nil iso)
;(test (inc-css '("foo")) '((<link rel "stylesheet" type "text/css" href "foo")) iso)
;(test (inc-css '("foo" "bar")) '((<link rel "stylesheet" type "text/css" href "foo") (<link rel "stylesheet" type "text/css" href "bar")) iso)
;(test (inc-js nil) nil iso)
;(test (inc-js '("foo")) '((<script src "foo" nil)) iso)
;(test (inc-js '("foo" "bar")) '((<script src "foo" nil) (<script src "bar" nil)) iso)

; <inc-css  ------------------------------------------------------------------

(test (tostring:<inc-css) "")
(test (tostring:<inc-css "foo") "<link rel=\"stylesheet\" type=\"text/css\" href=\"foo\">")
(test (tostring:<inc-css "foo" "bar") "<link rel=\"stylesheet\" type=\"text/css\" href=\"foo\"><link rel=\"stylesheet\" type=\"text/css\" href=\"bar\">")

; <inc-js  -------------------------------------------------------------------

(test (tostring:<inc-js) "")
(test (tostring:<inc-js "foo") "<script src=\"foo\"></script>")
(test (tostring:<inc-js "foo" "bar") "<script src=\"foo\"></script><script src=\"bar\"></script>")

; <page  ---------------------------------------------------------------------

(test (tostring:<page) "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><link rel=\"shortcut icon\" href=\"/favicon.ico\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page "foo") "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><link rel=\"shortcut icon\" href=\"/favicon.ico\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body>foo</body></html>")
(test (tostring:<page title "foo") "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>foo</title><link rel=\"shortcut icon\" href=\"/favicon.ico\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page css ("foo" "bar")) "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><link rel=\"stylesheet\" type=\"text/css\" href=\"foo\"><link rel=\"stylesheet\" type=\"text/css\" href=\"bar\"><link rel=\"shortcut icon\" href=\"/favicon.ico\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page js ("foo" "bar")) "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><link rel=\"shortcut icon\" href=\"/favicon.ico\"><script src=\"foo\"></script><script src=\"bar\"></script><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page meta ((name "keywords" content "foo") (name "robots" content "noindex"))) "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><meta name=\"keywords\" content=\"foo\"><meta name=\"robots\" content=\"noindex\"><link rel=\"shortcut icon\" href=\"/favicon.ico\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page link ((rel "alternate" title "foo" href "bar"))) "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Page</title><link rel=\"shortcut icon\" href=\"/favicon.ico\"><link rel=\"alternate\" title=\"foo\" href=\"bar\"><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body></body></html>")
(test (tostring:<page title "foo" css ("foo" "bar") js ("foo" "bar") meta ((name "keywords" content "foo")) link ((rel "alternate" title "foo" href "bar")) "foo") "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>foo</title><link rel=\"stylesheet\" type=\"text/css\" href=\"foo\"><link rel=\"stylesheet\" type=\"text/css\" href=\"bar\"><meta name=\"keywords\" content=\"foo\"><link rel=\"shortcut icon\" href=\"/favicon.ico\"><link rel=\"alternate\" title=\"foo\" href=\"bar\"><script src=\"foo\"></script><script src=\"bar\"></script><!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]--></head><body>foo</body></html>")

; deflayout ------------------------------------------------------------------
; TODO:

; <sitemanae -----------------------------------------------------------------

(test (tostring:<sitename) "<h1><a href=\"/\"><span>Untitled Site</span></a></h1>")
(test (tostring:<sitename url "/foo") "<h1><a href=\"/foo\"><span>Untitled Site</span></a></h1>")
(test (tostring:<sitename name "foo") "<h1><a href=\"/\"><span>foo</span></a></h1>")
(test (tostring:<sitename url "/foo" name "foo") "<h1><a href=\"/foo\"><span>foo</span></a></h1>")

; <copyright -----------------------------------------------------------------

(test (tostring:<copyright) (string "<div id=\"copyright\">&copy; " (datestring (seconds) "~Y ") "</div>"))
(test (tostring:<copyright owner "foo") (string "<div id=\"copyright\">&copy; " (datestring (seconds) "~Y ") "foo</div>"))
(test (tostring:<copyright url "/foo") (string "<div id=\"copyright\">&copy; " (datestring (seconds) "~Y ") "</div>"))
(test (tostring:<copyright owner "foo" url "/foo") (string "<div id=\"copyright\">&copy; " (datestring (seconds) "~Y ") "<a href=\"/foo\">foo</a></div>"))

; <globalnav -----------------------------------------------------------------
; TODO:

(run-test)

; vim: ft=arc
