; HTTP response.

(require "epona/mime.arc")
(require "epona/sta.arc")

(deftem response
  sta   200
  heads `(("Content-Type" ,mimetype!html))
  body  nil)

(mac prrn args
  `(pr ,@args #\return #\newline))

(def respond (meth sta heads body o)
  (w/stdout o
    (prrn:httpsta-line sta)
    (each (k v) (rev heads)
      (prrn k ": " v))
    (prrn)
    (awhen body
      (after
        (unless (is meth 'head)
          (case type.it
            input (whilet b (readb it) (writeb b))
                  (pr it)))
        (when (isa it 'input)
          (close it))))))
