(push-loadpath "lib")

(load "test.arc")
(load "epona/tag.arc")

; pr-escaped -----------------------------------------------------------------

(test (tostring:pr-escaped nil) "")
(test (tostring:pr-escaped "") "")
(test (tostring:pr-escaped "foo") "foo")
(test (tostring:pr-escaped "<|>|&|\"|'") "&lt;|&gt;|&amp;|&quot;|&#39;")

; parse-attrs ----------------------------------------------------------------

(test (parse-attrs nil) '(nil nil) iso)
(test (parse-attrs '(id "id")) '((id "id") nil) iso)
(test (parse-attrs '(id "id" class "class")) '((id "id" class "class") nil) iso)
(test (parse-attrs '(id "id" "body")) '((id "id") ("body")) iso)
(test (parse-attrs '(id "id" class "class" "body")) '((id "id" class "class") ("body")) iso)
(test (parse-attrs '(id "id" "body1" "body2")) '((id "id") ("body1" "body2")) iso)
(test (parse-attrs '(nil "body")) '(nil ("body")) iso)
(test (parse-attrs '(nil "body1" "body2")) '(nil ("body1" "body2")) iso)
(test (parse-attrs '("body1" "body2")) '(nil ("body1" "body2")) iso)

; tag ------------------------------------------------------------------------

(test (tostring:tag foo nil) "<foo>")
(test (tostring:tag foo nil nil) "<foo></foo>")
(test (tostring:tag foo nil "bar") "<foo>bar</foo>")
(test (tostring:tag foo nil "<|>|&|\"|'") "<foo>&lt;|&gt;|&amp;|&quot;|&#39;</foo>")
(test (tostring:tag foo nil (raw "<|>|&|\"|'")) "<foo><|>|&|\"|'</foo>")
(test (tostring:tag foo ((id "id"))) "<foo id=\"id\">")
(test (tostring:tag foo ((id "id") (class "class"))) "<foo id=\"id\" class=\"class\">")
(test (tostring:tag foo ((id "id")) "bar") "<foo id=\"id\">bar</foo>")
(test (tostring:tag foo ((id "<|>|&|\"|'"))) "<foo id=\"&lt;|&gt;|&amp;|&quot;|&#39;\">")
(= x "bar")
(test (tostring:tag foo ((id x)) x) "<foo id=\"bar\">bar</foo>")
(def baz () "baz")
(test (tostring:tag foo ((id (baz))) (baz)) "<foo id=\"baz\">baz</foo>")

(test (tostring:w/markup 'html  (tag foo ((id "bar")))) "<foo id=\"bar\">")
(test (tostring:w/markup 'xhtml (tag foo ((id "bar")))) "<foo id=\"bar\" />")
(test (tostring:w/markup 'xml   (tag foo ((id "bar")))) "<foo id=\"bar\"/>")

; gentag ---------------------------------------------------------------------

(gentag foo)
(test (tostring:<foo) "<foo>")
(test (tostring:<foo nil) "<foo></foo>")
(test (tostring:<foo "bar") "<foo>bar</foo>")
(test (tostring:<foo "<|>|&|\"|'") "<foo>&lt;|&gt;|&amp;|&quot;|&#39;</foo>")
(test (tostring:<foo (raw "<|>|&|\"|'")) "<foo><|>|&|\"|'</foo>")
(test (tostring:<foo id "id") "<foo id=\"id\">")
(test (tostring:<foo id "id" nil) "<foo id=\"id\"></foo>")
(test (tostring:<foo id "id" "bar") "<foo id=\"id\">bar</foo>")
(test (tostring:<foo id x x) "<foo id=\"bar\">bar</foo>")
(test (tostring:<foo id (baz) (baz)) "<foo id=\"baz\">baz</foo>")
(gentag bar)
(test (tostring:<foo (<bar)) "<foo><bar></foo>")
(test (tostring:<foo id "id" (<bar)) "<foo id=\"id\"><bar></foo>")
(test (tostring:<foo id "id" (<bar "baz")) "<foo id=\"id\"><bar>baz</bar></foo>")
(test (tostring:<foo id x (<bar id x x)) "<foo id=\"bar\"><bar id=\"bar\">bar</bar></foo>")
(test (tostring:<foo id (baz) (<bar id (baz) (baz))) "<foo id=\"baz\"><bar id=\"baz\">baz</bar></foo>")
(gentag foo bar)
(test (tostring:<bar-foo) "<foo>")

; gentags --------------------------------------------------------------------

(gentags nil html div p)
(test (tostring:<html (<div (<p "foo"))) "<html><div><p>foo</p></div></html>")

(gentags foo html div p)
(test (tostring:<foo-html (<foo-div (<foo-p "foo"))) "<html><div><p>foo</p></div></html>")

(run-test)

; vim: ft=arc
