(push-loadpath "lib")

(require "epona/srv.arc")
(require "test.arc")

; serve ----------------------------------------------------------------------

(= appdir* "t/data")
(defp /foo () "foo")

(= th (thread (serve 9999)))
(sleep 1)  ; wait for run server

(test is (tostring:system "curl http://127.0.0.1:9999/ 2>/dev/null")
         "404 Not Found")
(test is (tostring:system "curl http://127.0.0.1:9999/foo 2>/dev/null")
         "<!DOCTYPE html>foo")
(test is (tostring:system "curl http://127.0.0.1:9999/foo.txt 2>/dev/null")
         "foo\n")

(kill-thread th)

(done-testing)

; vim: ft=arc
