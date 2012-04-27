; HTTP Server.

(require "epona/dispatch.arc")

(= timeout* 30)

(def handle (i o ip)
  (let (meth sta heads body) (dispatch (mkctx i ip))
    (respond meth sta heads body o))
  (harvest-fnids))

(def accept-and-handle (s)
  (let (i o ip) (socket-accept s)
    (with (th1 nil th2 nil)
      (= th1 (thread
               (after (handle i o ip)
                 (close i o)
                 (kill-thread th2))))
      (= th2 (thread
               (sleep timeout*)
               (unless (dead th1)
                 (prn "srv thread took too long for " ip))
               (break-thread th1)
               (force-close i o))))))

(def serve ((o port (if (bound 'port*) port*  8080)))
  (w/socket s port
    (while t
      (errsafe:accept-and-handle s))))
