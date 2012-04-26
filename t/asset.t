(push-loadpath "lib")

(require "epona/asset.arc")
(require "test.arc")

; file-exists-in-pubdir  -----------------------------------------------------

(= appdir* "")
(test is (file-exists-in-pubdir "http://example.com/foo.txt") nil)
(test is (file-exists-in-pubdir "bar.txt") nil)
(test is (file-exists-in-pubdir "foo.txt") nil)
(test is (file-exists-in-pubdir "foo.v12345.txt") nil)
(test is (file-exists-in-pubdir "bar.v12345.txt") nil)

(= appdir* "t/data")
(test is (file-exists-in-pubdir "http://example.com/foo.txt") nil)
(test is (file-exists-in-pubdir "bar.txt") nil)
(test is (file-exists-in-pubdir "foo.txt") "t/data/pub/foo.txt")
(test is (file-exists-in-pubdir "foo.v12345.txt") "t/data/pub/foo.txt")
(test is (file-exists-in-pubdir "bar.v12345.txt") nil)

; asset  ---------------------------------------------------------------------

(= appdir* "")
(test is (asset "http://example.com/foo.txt") "http://example.com/foo.txt")
(test is (asset "foo.txt") "foo.txt")
(test is (asset "bar.txt") "bar.txt")

(= appdir* "t/data")
(test is (asset "http://example.com/foo.txt") "http://example.com/foo.txt")
(test is (asset "foo.txt")
         (string "foo.v" (mtime "t/data/pub/foo.txt") ".txt"))
(test is (asset "bar.txt") "bar.txt")

(done-testing)

; vim: ft=arc
