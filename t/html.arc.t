(push-loadpath "lib")

(require "test.arc")
(require "epona/html.arc")

; doctype  -------------------------------------------------------------------

(test (tostring:doctype) "<!DOCTYPE html>")

; tags  ----------------------------------------------------------------------

(test (tostring:<html (<head (<title "foo")) (<body "bar")) "<html><head><title>foo</title></head><body>bar</body></html>")

(run-test)

; vim: ft=arc
