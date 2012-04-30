(push-loadpath "lib")

(require "epona/auth.arc")
(require "test.arc")

; pwdgst  --------------------------------------------------------------------

(= auth-key* "CIjrrxAfa9rs7SKjTtfELMHnsEVD3M9B5RDurFAoQDH9aIejnSdGeSU4OM6ggzaKyppEk4eqUWa5ECdQT7jGtCVxIeZ4eXx14QAtbnZxrjdWCy9erHxBaKR7UgI5fMac")
(test is (pwdgst sha512 "foo" 5000 "NVqFuJemV8giYUAZ")
         "4eed124a0dda332568c7a72cd2bbb857d7dcbc6f15f27ea995351faca05cc1aebb0f35e0c24d3a3a3cfa80338aed2f1a552f4aadfcf90371c4d71cec20b29c70")

(= auth-key* "")
(test is (pwdgst sha512 "foo" 5000 "NVqFuJemV8giYUAZ")
         "b243ab550b1e57a4bfbc7bdb4618ec322449301864d34a9ecd2fe32d3a66883643f680ccffb84c254fb2a26418f91e6f77b07b71fae2e8fd5f5978b5ac2cf84b")
(test is (pwdgst sha512 "foo" 1 "6j2eqKHTFoRJXEF7")
         "887dd9ff34178866537d413b43b061009565d494fe349dd10cce353882ba4772e734e43a21f269e4b1d0350b03e60854832faf8c7431e36f633249136a0f0162")


; hash-algo  -----------------------------------------------------------------

(test is (hash-algo 6) sha512)

; pwhash  --------------------------------------------------------------------

(test isnt (pwhash "foo") (pwhash "foo"))

; hash-rounds  ---------------------------------------------------------------

(test is (hash-rounds "rounds=5000") 5000)
(test is (hash-rounds "rounds=1") 1)

; pwcmp  ---------------------------------------------------------------------

(= auth-rounds* 10)
(test is (pwcmp "foo" (pwhash "foo")) t)
(test is (pwcmp "bar" (pwhash "foo")) nil)

(= auth-rounds* 5000)
(test is (pwcmp "bar" (pwhash "bar")) t)
(test is (pwcmp "baz" (pwhash "bar")) nil)

(done-testing)

; vim: ft=arc
