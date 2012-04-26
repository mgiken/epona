(push-loadpath "lib")

(require "epona/sta.arc")
(require "test.arc")

; http-sta  ------------------------------------------------------------------

(test is (httpsta 100) "100 Continue")
(test is (httpsta 101) "101 Switching Protocols")
(test is (httpsta 200) "200 OK")
(test is (httpsta 201) "201 Created")
(test is (httpsta 202) "202 Accepted")
(test is (httpsta 203) "203 Non-Authoritative Information")
(test is (httpsta 204) "204 No Content")
(test is (httpsta 205) "205 Reset Content")
(test is (httpsta 206) "206 Partial Content")
(test is (httpsta 300) "300 Multiple Choices")
(test is (httpsta 301) "301 Moved Permanently")
(test is (httpsta 302) "302 Found")
(test is (httpsta 303) "303 See Other")
(test is (httpsta 304) "304 Not Modified")
(test is (httpsta 305) "305 Use Proxy")
(test is (httpsta 307) "307 Temporary Redirect")
(test is (httpsta 400) "400 Bad Request")
(test is (httpsta 401) "401 Unauthorized")
(test is (httpsta 402) "402 Payment Required")
(test is (httpsta 403) "403 Forbidden")
(test is (httpsta 404) "404 Not Found")
(test is (httpsta 405) "405 Method Not Allowed")
(test is (httpsta 406) "406 Not Acceptable")
(test is (httpsta 407) "407 Proxy Authentication Required")
(test is (httpsta 408) "408 Request Timeout")
(test is (httpsta 409) "409 Conflict")
(test is (httpsta 410) "410 Gone")
(test is (httpsta 411) "411 Length Required")
(test is (httpsta 412) "412 Precondition Failed")
(test is (httpsta 413) "413 Request Entity Too Large")
(test is (httpsta 414) "414 Request-URI Too Long")
(test is (httpsta 415) "415 Unsupported Media Type")
(test is (httpsta 416) "416 Requested Range Not Satisfiable")
(test is (httpsta 417) "417 Expectation Failed")
(test is (httpsta 500) "500 Internal Server Error")
(test is (httpsta 501) "501 Not Implemented")
(test is (httpsta 502) "502 Bad Gateway")
(test is (httpsta 503) "503 Service Unavailable")
(test is (httpsta 504) "504 Gateway Timeout")
(test is (httpsta 505) "505 HTTP Version Not Supported")
(test is (httpsta 999) "999 Unknown Status Code")

; http-sta-line  -------------------------------------------------------------

(test is (httpsta-line 100) "HTTP/1.1 100 Continue")
(test is (httpsta-line 101) "HTTP/1.1 101 Switching Protocols")
(test is (httpsta-line 200) "HTTP/1.1 200 OK")
(test is (httpsta-line 201) "HTTP/1.1 201 Created")
(test is (httpsta-line 202) "HTTP/1.1 202 Accepted")
(test is (httpsta-line 203) "HTTP/1.1 203 Non-Authoritative Information")
(test is (httpsta-line 204) "HTTP/1.1 204 No Content")
(test is (httpsta-line 205) "HTTP/1.1 205 Reset Content")
(test is (httpsta-line 206) "HTTP/1.1 206 Partial Content")
(test is (httpsta-line 300) "HTTP/1.1 300 Multiple Choices")
(test is (httpsta-line 301) "HTTP/1.1 301 Moved Permanently")
(test is (httpsta-line 302) "HTTP/1.1 302 Found")
(test is (httpsta-line 303) "HTTP/1.1 303 See Other")
(test is (httpsta-line 304) "HTTP/1.1 304 Not Modified")
(test is (httpsta-line 305) "HTTP/1.1 305 Use Proxy")
(test is (httpsta-line 307) "HTTP/1.1 307 Temporary Redirect")
(test is (httpsta-line 400) "HTTP/1.1 400 Bad Request")
(test is (httpsta-line 401) "HTTP/1.1 401 Unauthorized")
(test is (httpsta-line 402) "HTTP/1.1 402 Payment Required")
(test is (httpsta-line 403) "HTTP/1.1 403 Forbidden")
(test is (httpsta-line 404) "HTTP/1.1 404 Not Found")
(test is (httpsta-line 405) "HTTP/1.1 405 Method Not Allowed")
(test is (httpsta-line 406) "HTTP/1.1 406 Not Acceptable")
(test is (httpsta-line 407) "HTTP/1.1 407 Proxy Authentication Required")
(test is (httpsta-line 408) "HTTP/1.1 408 Request Timeout")
(test is (httpsta-line 409) "HTTP/1.1 409 Conflict")
(test is (httpsta-line 410) "HTTP/1.1 410 Gone")
(test is (httpsta-line 411) "HTTP/1.1 411 Length Required")
(test is (httpsta-line 412) "HTTP/1.1 412 Precondition Failed")
(test is (httpsta-line 413) "HTTP/1.1 413 Request Entity Too Large")
(test is (httpsta-line 414) "HTTP/1.1 414 Request-URI Too Long")
(test is (httpsta-line 415) "HTTP/1.1 415 Unsupported Media Type")
(test is (httpsta-line 416) "HTTP/1.1 416 Requested Range Not Satisfiable")
(test is (httpsta-line 417) "HTTP/1.1 417 Expectation Failed")
(test is (httpsta-line 500) "HTTP/1.1 500 Internal Server Error")
(test is (httpsta-line 501) "HTTP/1.1 501 Not Implemented")
(test is (httpsta-line 502) "HTTP/1.1 502 Bad Gateway")
(test is (httpsta-line 503) "HTTP/1.1 503 Service Unavailable")
(test is (httpsta-line 504) "HTTP/1.1 504 Gateway Timeout")
(test is (httpsta-line 505) "HTTP/1.1 505 HTTP Version Not Supported")
(test is (httpsta-line 999) "HTTP/1.1 999 Unknown Status Code")
(test is (httpsta-line 999 "foo") "foo 999 Unknown Status Code")

(done-testing)

; vim: ft=arc
