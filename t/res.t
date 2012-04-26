(push-loadpath "lib")

(require "epona/res.arc")
(require "test.arc")

; response -------------------------------------------------------------------

(test iso (inst 'response)
          (obj sta 200 heads '(("Content-Type" "text/html"))))

; prrn -----------------------------------------------------------------------

(test is (tostring:prrn "") "\r\n")
(test is (tostring:prrn "foo") "foo\r\n")
(test is (tostring:prrn "foo" "bar") "foobar\r\n")
(test is (tostring:prrn "foo" 'bar) "foobar\r\n")

; respond --------------------------------------------------------------------

(= h '(("Content-Type" "text/html")))
(test is (tostring:respond 'head 200 h "foo" (stdout))
         "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n")
(test is (tostring:respond 'get 200 h "foo" (stdout))
         "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nfoo")
(test is (tostring:respond 'post 303 h "bar" (stdout))
         "HTTP/1.1 303 See Other\r\nContent-Type: text/html\r\n\r\nbar")
(test is (tostring:respond 'get 200 h (instring "foo") (stdout))
         "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nfoo")
(push '("foo" "bar") h)
(test is (tostring:respond 'get 200 h "foo" (stdout))
         "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nfoo: bar\r\n\r\nfoo")

(done-testing)

; vim: ft=arc
