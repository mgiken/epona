(push-loadpath "lib")

(load "test.arc")
(load "epona/assets.arc")

; file-exists-in-pubdir  -----------------------------------------------------

(test (do (= appdir* nil sysdir* nil) (file-exists-in-pubdir "http://example.com/foo.txt")) nil)
(test (do (= appdir* nil sysdir* nil) (file-exists-in-pubdir "bar.txt")) nil)
(test (do (= appdir* nil sysdir* nil) (file-exists-in-pubdir "foo.txt")) nil)
(test (do (= appdir* nil sysdir* nil) (file-exists-in-pubdir "foo.v12345.txt")) nil)
(test (do (= appdir* nil sysdir* nil) (file-exists-in-pubdir "bar.v12345.txt")) nil)

(test (do (= appdir* "t/data" sysdir* nil) (file-exists-in-pubdir "http://example.com/foo.txt")) nil)
(test (do (= appdir* "t/data" sysdir* nil) (file-exists-in-pubdir "bar.txt")) nil)
(test (do (= appdir* "t/data" sysdir* nil) (file-exists-in-pubdir "foo.txt")) (qualified-path:string appdir* "/pub/foo.txt"))
(test (do (= appdir* "t/data" sysdir* nil) (file-exists-in-pubdir "foo.v12345.txt")) (qualified-path:string appdir* "/pub/foo.txt"))
(test (do (= appdir* "t/data" sysdir* nil) (file-exists-in-pubdir "bar.v12345.txt")) nil)

(test (do (= appdir* nil sysdir* "t/data") (file-exists-in-pubdir "http://example.com/foo.txt")) nil)
(test (do (= appdir* nil sysdir* "t/data") (file-exists-in-pubdir "bar.txt")) nil)
(test (do (= appdir* nil sysdir* "t/data") (file-exists-in-pubdir "foo.txt")) (qualified-path:string sysdir* "/pub/foo.txt"))
(test (do (= appdir* nil sysdir* "t/data") (file-exists-in-pubdir "foo.v12345.txt")) (qualified-path:string sysdir* "/pub/foo.txt"))
(test (do (= appdir* nil sysdir* "t/data") (file-exists-in-pubdir "bar.v12345.txt")) nil)

; assets  --------------------------------------------------------------------

(test (do (= appdir* "t/data" sysdir* nil) (assets "foo.txt")) (string "foo.v" (mtime "t/data/pub/foo.txt") ".txt"))
(test (do (= appdir* nil sysdir* nil) (assets "foo.txt")) "foo.txt")
(test (do (= appdir* "t/data" sysdir* nil) (assets "bar.txt")) "bar.txt")

(run-test)

; vim: ft=arc
