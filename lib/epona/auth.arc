(require "crypto.arc")

(= auth-key*    nil
   auth-algo*   6
   auth-rounds* 5000)

(def pwdgst (algo pw rounds salt)
  (let dgst auth-key*
    (repeat rounds
      (= dgst (algo:string "$" salt "$" dgst "$" pw "$" auth-key* "$")))
    dgst))

(def hash-algo (id)
  (case int.id
    6 sha512
        (err "Unkown hash algorithm" id)))

(def pwhash (pw (o algo auth-algo*) (o rounds auth-rounds*))
  (let salt (rand-string 16)
    (string "$" algo "$rounds=" rounds "$" salt "$"
            (pwdgst (hash-algo algo) pw rounds salt))))

(def hash-rounds (s)
  (int ((tokens s #\=) 1)))

(def pwcmp (pw pwhash)
  (let (algo rounds salt hashed) (tokens pwhash #\$)
    (is hashed (pwdgst (hash-algo algo) pw (hash-rounds rounds) salt))))
