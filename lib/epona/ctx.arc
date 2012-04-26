; Context.

(require "epona/req.arc")
(require "epona/res.arc")

(implicit ctx)

(deftem context
  req nil
  res nil)

(def mkctx (i ip)
  (inst 'context 'req (readreq i ip) 'res (inst 'response)))

(defs arg  (k (o d)) (or (alref ctx!req!args  string.k) d)
      head (k (o d)) (or (alref ctx!req!heads string.k) d)
      cook (k (o d)) (or (alref ctx!req!cooks string.k) d))

(defmemo normalize-head-key (x)
  (string:intersperse #\- (map capitalize (tokens string.x #\-))))

(defmemo sanitize-head-value (x)
  (multisubst '(("\r" "") ("\n" "")) string.x))

(def sethead (k v (o duplicate))
  (unless duplicate (pull [is car._ normalize-head-key.k] ctx!res!heads))
  (push (list normalize-head-key.k sanitize-head-value.v) ctx!res!heads))

(def cookexpires (sec)
  (if (< sec 0)
      "Thu, 01-Jan-1970 00:00:00 GMT"
      (datestring (+ (- (seconds) zone-offset*) sec)
                  "~a, ~e-~b-~Y ~H:~M:~S GMT")))

(def setcook (k v (o e) (o p) (o d) (o s) (o h))
  (sethead "Set-Cookie"
           (string k "=" urlencode.v
             (when e (+ "; expires=" cookexpires.e))
             (when d (+ "; domaon=" d))
             (when p (+ "; path=" p))
             (when s "; secure")
             (when h "; httponly"))
           t))
