; とりあえず
(require "crypto.arc")
(require "re.arc")

(require "epona/conf.arc")
(require "epona/tag.arc")
(require "epona/route.arc")
(require "epona/req.arc")
(require "epona/res.arc")

(def hash-algo (id)
  (case id
    "6" sha512
        (err "Unkown hash algorithm")))

(def pwdgst (pw salt (o algo "6"))
  (with (hash hash-algo.algo
         dgst conf*!pwdgst-salt)
    (repeat conf*!pwdgst-stretches
      (= dgst (hash:string dgst salt pw conf*!pwdgst-salt)))
    dgst))

(def pwhash (pw (o algo "6"))
  (let salt (rand-string 128)
    (string "$" algo "$" salt "$" (pwdgst pw salt algo))))

(def pwcmp (pw0 pw1)
  (let (algo salt hashed) (tokens pw1 #\$)
    (is hashed (pwdgst pw0 salt algo))))

;(def logout ()
;  (awhen (get-doc cook!_a)
;    (del-doc it)))
;
;(def login (id pw)
;  (logout)
;  ; TODO
;  (let auth (find-doc1 "auth" "all" (obj key (string "\"" id "\"")))
;    (aand auth
;          (pwcmp arg!pw auth!password)
;          (save-doc (inst 'session 'data (obj auth_id auth!_id)))
;          (push (string "_a=" it!id)  response!cooks))))
;
;(deftag login-form
;  `(aform
;     (if (login arg!id arg!pw)
;         (redirect ,attr!afterward)
;         (do (= request!msg ,(attr 'msg "ログインに失敗しました"))
;             (go /login)))
;     (<fieldset
;       (<message)
;       (<label for "id" "Email Address")
;       (<input type "text" name "id")
;       (<label for "pw" "Password")
;       (<input type "password" name "pw")
;       (<input type "submit" value "Submit" name "submit"))))

; TODO
;(defp /login
;  (<login-form afterward "/"))
