(require "files.arc")

(require "epona/assets.arc")
(require "epona/httpsta.arc")
(require "epona/mimetype.arc")

(implicit response)

(deftem response
  code  200
  heads `((Content-Type ,mimetype*!html) (Connection "close"))
  body  nil
  cooks nil)

(def prrn args
  (do1 (apply pr args)
       (writec #\return)
       (writec #\newline)))

(def sethead (key val)
  (when (alref response!heads key)
    (= response!heads (pull [is (car _) key] response!heads)))
  (push (list key (multisubst '(("\r" "") ("\n" "")) string.val))
        response!heads))

(def prcooks (cooks)
  (each v cooks 
    (prrn "Set-Cookie: " v)))

(def respond-head ()
  (prrn (httpsta response!code))
  (each (k v) response!heads (prrn k ": " v))
  (prcooks response!cooks)
  (prrn))

(def respond (o)
  (w/stdout o
    (respond-head)
    (awhen response!body
      pr.it)))

; TODO: need urlencode?
(def respond-redirect (o to (o code 302))
  (= response!code code)
  (sethead 'Location to)
  (respond o))

; TODO: response custom error page
(def respond-err (o (o code 404) (o msg))
  (= response!code code
     response!body (string code " " httpsta*.code))
  (respond o))

(def respond-file (o file meth)
  (awhen (file-exists-in-pubdir file)
    (sethead 'Content-Type mimetype.it)
    (sethead 'Content-Length file-size.it)
    (w/stdout o
      (respond-head)
      (unless (is meth 'head)
        (w/infile i it
          (whilet b readb.i
            (writeb b o)))))
    t))

(def respond-page (o (success redirect error))
  (if success  (do (= response!body success) respond.o)
      redirect (apply respond-redirect o redirect)
               (apply respond-err o error)))
