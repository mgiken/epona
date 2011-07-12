(push-loadpath "lib")

(load "test.arc")
(load "epona/res.arc")

; prrn  ----------------------------------------------------------------------

(test (tostring:prrn "foo") "foo\r\n")
(test (tostring:prrn "") "\r\n")

; sethead  -------------------------------------------------------------------

(test (w/response (inst 'response)
        (sethead 'foo "foo")
        response!heads)
      '((foo "foo") (Content-Type "text/html; charset=utf-8") (Connection "close")) iso)

(test (w/response (inst 'response)
        (sethead 'Content-Type "foo")
        response!heads)
      '((Content-Type "foo") (Connection "close")) iso)

(test (w/response (inst 'response 'heads nil)
        (sethead 'foo "fo\no")
        response!heads)
      '((foo "foo")) iso)

(test (w/response (inst 'response 'heads nil)
        (sethead 'foo "fo\ro")
        response!heads)
      '((foo "foo")) iso)

(test (w/response (inst 'response 'heads nil)
        (sethead 'foo "fo\ro\n")
        response!heads)
      '((foo "foo")) iso)

; respond-head  --------------------------------------------------------------

(test (w/response (inst 'response)
        (tostring:respond-head))
      "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n")

(= res2* (inst 'response 'code 404 'body "Not Found"))
(test (w/response (inst 'response 'code 404 'body "Not Found")
        (tostring:respond-head))
      "HTTP/1.1 404 Not Found\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n")

; respond  -------------------------------------------------------------------

(test (w/response (inst 'response 'body "foo")
        (let o (outstring)
          (respond o)
          (inside o)))
      "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\nfoo")

; respond-redirect  ----------------------------------------------------------

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-redirect o "/foo")
          (inside o)))
      "HTTP/1.1 302 Found\r\nLocation: /foo\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n")

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-redirect o "/foo" 301)
          (inside o)))
      "HTTP/1.1 301 Moved Permanently\r\nLocation: /foo\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n")

; respond-err  ---------------------------------------------------------------

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-err o)
          (inside o)))
      "HTTP/1.1 404 Not Found\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n404 Not Found")

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-err o 500)
          (inside o)))
      "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n500 Internal Server Error")

; respond-file  --------------------------------------------------------------

(test (w/response (inst 'response)
        (let o (outstring)
          (= appdir* "/tmp")
          (respond-file o 'foo.txt 'get)
          (inside o)))
          "")

(test (w/response (inst 'response)
        (let o (outstring)
          (= appdir* "t/data")
          (respond-file o 'foo.txt 'get)
          (inside o)))
          "HTTP/1.1 200 OK\r\nContent-Length: 8\r\nContent-Type: text/plain; charset=utf-8\r\nConnection: close\r\n\r\nfoo.txt\n")

(test (w/response (inst 'response)
        (let o (outstring)
          (= appdir* "t/data")
          (respond-file o 'foo.txt 'head)
          (inside o)))
          "HTTP/1.1 200 OK\r\nContent-Length: 8\r\nContent-Type: text/plain; charset=utf-8\r\nConnection: close\r\n\r\n")

; respond-page  --------------------------------------------------------------

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-page o '("foo" nil nil))
          (inside o)))
      "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\nfoo")

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-page o '(nil ("/foo") nil))
          (inside o)))
      "HTTP/1.1 302 Found\r\nLocation: /foo\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n")

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-page o '(nil nil nil))
          (inside o)))
      "HTTP/1.1 404 Not Found\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n404 Not Found")

(test (w/response (inst 'response)
        (let o (outstring)
          (respond-page o '(nil nil (500)))
          (inside o)))
      "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/html; charset=utf-8\r\nConnection: close\r\n\r\n500 Internal Server Error")

(run-test)

; vim: ft=arc
