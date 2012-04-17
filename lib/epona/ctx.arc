; Context.

(require "epona/assets.arc")
(require "epona/sta.arc")
(require "epona/mime.arc")

(implicit ctx)

(deftem ctx
  env   nil
  ip    nil
  meth  nil
  path  nil
  qs    nil
  op    nil
  sta   200
  hds   nil
  o     nil)

(def mk-env (i o)
  (let e (obj i i o o)
    (whiler l readline.i blank
      (awhen (pos #\: l)
        (= (e (subst "-" "_" (upcase:cut l 0 it))) (trim:cut l (+ it 1)))))
    e))

(def mk-ctx (i o ip)
  (withs ((meth path prot) (tokens:readline i)
          (base qs)        (tokens path #\?)
          env              (mk-env i o))
    (inst 'ctx 'env   env
               'ip    (aif env!x-real-ip it ip)
               'meth  (sym:downcase meth)
               'path  path
               ;'prot  prot
               ;'base  base
               'qs    qs
               'op    sym.base)))

(def hd (k (o d))
  (ctx!env string.k d))

(def parseargs (s)
  (map [map urldecode (tokens _ #\=)] (tokens s #\&)))

(def data ((o type))
  (let s (set-if-nil
           ctx!data
           (aand hd!CONTENT-LENGTH
                 (errsafe:int it)
                 (string:map [coerce _ 'char] (readbs it ctx!env!i))))
    (case type
      args (and (is hd!CONTENT-TYPE "application/x-www-form-urlencoded")
                (only.parseargs s))
      json (and (is hd!CONTENT-TYPE "application/json")
                (only.tojson s))
           s)))

(def args ()
  (set-if-nil
    ctx!args
    (join (only.parseargs ctx!qs) (data 'args))))

(def arg (k (o d))
  (or (alref (args) string.k) d))

(def cooks ()
  (set-if-nil
    ctx!cooks
    (aand hd!COOKIE
          (map [map urldecode (tokens trim._ #\=)] (tokens it #\;)))))

(def cook (k (o d))
  (or (alref (cooks) string.k) d))

(defmemo normalize-hdk (k)
  (string:intersperse #\- (map capitalize (tokens string.k #\-))))

(defmemo sanitize-hdv (v)
  (multisubst '(("\r" "") ("\n" "")) string.v))

(def sethd (k v (o unique t))
  (when unique (pull [is car._ normalize-hdk.k] ctx!hds))
  (push (list normalize-hdk.k sanitize-hdv.v) ctx!hds))

(def cookexpires (sec)
  (if (< sec 0)
      "Thu, 01-Jan-1970 00:00:00 GMT"
      (datestring (+ (- (seconds) zone-offset*) sec)
                  "~a, ~e-~b-~Y ~H:~M:~S GMT")))

(def setcook (k v (o e) (o p) (o d) (o s) (o h))
  (sethd "Set-Cookie"
         (string k "=" urlencode.v
           (when e (+ "; expires=" cookexpires.e))
           (when d (+ "; domaon=" d))
           (when p (+ "; path=" p))
           (when s "; secure")
           (when h "; httponly"))
         nil))
