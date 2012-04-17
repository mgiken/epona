; HTTP Server.

(require "epona/route.arc")

(mac prrn args
  `(pr ,@args #\return #\newline))

(def respond ()
  (prrn:http-sta-line ctx!sta)
  (each (k v) (rev ctx!hds)
    (prrn k ": " v))
  (prrn)
  (awhen ctx!o
    (unless (is ctx!meth 'head)
      (case type.it
        input (whilet b (readb it) (writeb b))
              (pr it)))
    (when (isa it 'input)
      (close it))))

(def respond-file ()
  (awhen (file-exists-in-pubdir ctx!op)
    (sethd "Content-Type"   mime-type.it)
    (sethd "Content-Length" file-size.it)
    (= ctx!o infile.it)))

(def respond-page ()
  (awhen (find-op ctx!meth ctx!op)
    (it)))

(def respond-err ((o sta 404))
  (sethd "Content-Type" mime-type!html)
  (= ctx!sta sta ctx!o http-sta.sta))

(def handle-request (s)
  (let (i o ip) (socket-accept s)
    (thread
      (after (w/ctx (mk-ctx i o ip)
               (w/stdout o
                 (or (respond-file)
                     (respond-page)
                     (respond-err))
                 (respond)))
             (close i o))
      (harvest-fnids))))

; TODO: timeout long thread
(def serve ((o port (if (bound 'port*) port*  8080)))
  (w/socket s port
    (prn "ready to serve port " port)
    (flushout)
    (while t
      (errsafe:handle-request s))))
