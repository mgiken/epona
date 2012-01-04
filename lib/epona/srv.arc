; TODO: test

(require "re.arc")

(require "epona/api.arc")
(require "epona/conf.arc")
(require "epona/req.arc")
(require "epona/res.arc")
(require "epona/route.arc")

(def handle-request-thread (i o ip)
  (w/request  (readreq i ip)
  (w/response (inst 'response)
    (aif (re-match "^/api(/.+)$" (string request!op))
         (dispatch-api o (sym:car it) request!meth)
         (or (respond-file o request!op request!meth)
             (respond-page o (dispatch))
             (respond-err o))))))

(def handle-request (s)
  (let (i o ip) (socket-accept s)
    (with (th1 nil th2 nil)
      (= th1 (thread
               (after (handle-request-thread i o ip)
                      (close i o)
                      (kill-thread th2))))
      (= th2 (thread
               (sleep srv-timeout*)
               (unless (dead th1)
                 (prn "srv thread took too long for " ip))
               ; TODO: write log
               (break-thread th1)
               (force-close i o))))))

(def serve ()
  (w/socket s srv-port*
    (prn "ready to serve port " srv-port*)
    (flushout)
    (= currsock* s)
    (while t
      (errsafe (handle-request s)))))
