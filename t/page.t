(push-loadpath "lib")

(require "epona/page.arc")
(require "test.arc")

(= appdir* "t/data")

; extag ----------------------------------------------------------------------

(test is (tostring:pr-node:<link 'href "/css/foo.css")
         (string "<link href=\"/css/foo.v"
                 (mtime "t/data/pub/css/foo.css")
                 ".css\">"))
(test is (tostring:pr-node:<script 'src "/js/foo.js")
         (string "<script src=\"/js/foo.v"
                 (mtime "t/data/pub/js/foo.js")
                 ".js\">"))
(test is (tostring:pr-node:<img 'src "/js/foo.js")
         (string "<img src=\"/js/foo.v"
                 (mtime "t/data/pub/js/foo.js")
                 ".js\">"))

; html5shim ------------------------------------------------------------------

(test is (tostring:pr-node:html5shim)
         "<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->")

; inc-css --------------------------------------------------------------------

(test is (tostring:pr-node:inc-css) "")
(test is (tostring:pr-node:inc-css "foo")
         (string "<link href=\"/css/foo.v"
                 (mtime "t/data/pub/css/foo.css")
                 ".css\" rel=\"stylesheet\" type=\"text/css\">"))
(test is (tostring:pr-node:inc-css "foo" "bar")
         (string "<link href=\"/css/foo.v"
                 (mtime "t/data/pub/css/foo.css")
                 ".css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/css/bar.css\" rel=\"stylesheet\" type=\"text/css\">"))

; inc-js --------------------------------------------------------------------

(test is (tostring:pr-node:inc-js) "")
(test is (tostring:pr-node:inc-js "foo")
         (string "<script src=\"/js/foo.v"
                 (mtime "t/data/pub/js/foo.js")
                 ".js\"></script>"))
(test is (tostring:pr-node:inc-js "foo" "bar")
         (string "<script src=\"/js/foo.v"
                 (mtime "t/data/pub/js/foo.js")
                 ".js\"></script>\
<script src=\"/js/bar.js\"></script>"))


; ga -------------------------------------------------------------------------

(test is (tostring:pr-node:ga "UA-12345-1")
          "<script>var _gaq=_gaq||[];\
_gaq.push(['_setAccount','UA-12345-1']);\
_gaq.push(['_trackPageview']);\
(function() {var ga=document.createElement('script');\
ga.async=true;\
ga.src='https://ssl.google-analytics.com/ga.js';\
var s=document.getElementsByTagName('script')[0];\
s.parentNode.insertBefore(ga,s);\
})();</script>")

; page -----------------------------------------------------------------------

(test is (tostring:pr-node:page "foo")
         "<html lang=\"jp\">\
<head>\
<meta charset=\"utf-8\">\
<title>Untitled Page</title>\
<link href=\"/css/app.css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/favicon.ico\" rel=\"shortcut icon\">\
<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->\
</head>\
<body>foo</body>\
</html>")


; TODO: more test

; deflayout ------------------------------------------------------------------

(deflayout foo-page "foo" ((<p "hd")) ((<p "ft")))

(test is (tostring:pr-node:foo-page "foo")
         "<html lang=\"jp\">\
<head>\
<meta charset=\"utf-8\">\
<title>foo</title>\
<link href=\"/css/app.css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/favicon.ico\" rel=\"shortcut icon\">\
<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->\
</head>\
<body>\
<header id=\"header\"><p>hd</p></header>\
<div id=\"content\">foo</div>\
<footer id=\"footer\"><p>ft</p></footer>\
</body>\
</html>")
(test is (tostring:pr-node:foo-page 'title "title" "foo")
         "<html lang=\"jp\">\
<head>\
<meta charset=\"utf-8\">\
<title>title | foo</title>\
<link href=\"/css/app.css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/favicon.ico\" rel=\"shortcut icon\">\
<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->\
</head>\
<body>\
<header id=\"header\"><p>hd</p></header>\
<div id=\"content\">foo</div>\
<footer id=\"footer\"><p>ft</p></footer>\
</body>\
</html>")

(deflayout bar-page "foo" ((<p "hd")) ((<p "ft")) " - ")

(test is (tostring:pr-node:bar-page "foo")
         "<html lang=\"jp\">\
<head>\
<meta charset=\"utf-8\">\
<title>foo</title>\
<link href=\"/css/app.css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/favicon.ico\" rel=\"shortcut icon\">\
<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->\
</head>\
<body>\
<header id=\"header\"><p>hd</p></header>\
<div id=\"content\">foo</div>\
<footer id=\"footer\"><p>ft</p></footer>\
</body>\
</html>")
(test is (tostring:pr-node:bar-page 'title "title" "foo")
         "<html lang=\"jp\">\
<head>\
<meta charset=\"utf-8\">\
<title>title - foo</title>\
<link href=\"/css/app.css\" rel=\"stylesheet\" type=\"text/css\">\
<link href=\"/favicon.ico\" rel=\"shortcut icon\">\
<!--[if lt IE 9]>\
<script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script>\
<![endif]-->\
</head>\
<body>\
<header id=\"header\"><p>hd</p></header>\
<div id=\"content\">foo</div>\
<footer id=\"footer\"><p>ft</p></footer>\
</body>\
</html>")

; sitename -------------------------------------------------------------------

(test is (tostring:pr-node:sitename "foo")
         "<h1><a href=\"/\" title=\"foo\">foo</a></h1>")
(test is (tostring:pr-node:sitename "foo" "/foo")
         "<h1><a href=\"/foo\" title=\"foo\">foo</a></h1>")

; copyright ------------------------------------------------------------------

(test is (tostring:pr-node:copyright "foo")
         (string "<p class=\"copyright\">&copy; "
                 (datestring (seconds) "~Y ")
                 "foo</p>"))

; hidden-field ---------------------------------------------------------------

(test is (tostring:pr-node:hidden-field "foo")
         "<input name=\"foo\" type=\"hidden\" value=\"\">")
(test is (tostring:pr-node:hidden-field "foo" "bar")
         "<input name=\"foo\" type=\"hidden\" value=\"bar\">")

; fnid-field -----------------------------------------------------------------

(test is (tostring:pr-node:fnid-field "foo")
         "<input name=\"fnid\" type=\"hidden\" value=\"foo\">")

; abtn -----------------------------------------------------------------------

(test is (tostring:pr-node:abtn "foo") "<a class=\"button\" title=\"foo\">foo</a>")
(test is (tostring:pr-node:abtn "foo" "bar" "baz")
         "<a class=\"button baz\" id=\"bar\" title=\"foo\">foo</a>")

; sbtn -----------------------------------------------------------------------

(test is (tostring:pr-node:sbtn "foo")
         "<input class=\"button\" title=\"foo\" type=\"submit\" value=\"foo\">")
(test is (tostring:pr-node:sbtn "foo" "bar" "baz")
         "<input class=\"button baz\" id=\"bar\" name=\"bar\" \
title=\"foo\" type=\"submit\" value=\"foo\">")

; notify ---------------------------------------------------------------------

(test is (tostring:pr-node:notify "foo")
         "<div class=\"notify\"><p>foo</p></div>")
(test is (tostring:pr-node:notify "foo" "bar")
         "<div class=\"notify bar\"><p>foo</p></div>")

(done-testing)

; vim: ft=arc
