; HTTP request.

(deftem request
  meth  nil
  path  nil
  prot  nil
  base  nil
  qs    nil
  heads nil
  body  nil
  op    nil
  args  nil
  cooks nil
  ip    nil)

(def parseargs (s)
  (map [map urldecode (tokens _ #\=)] (tokens s #\&)))

(def parsecooks (s)
  (map [map urldecode (tokens trim._ #\=)] (tokens s #\;)))

(def parsebody (s h)
  (when (findsubseq "x-www-form-urlencoded" (alref h "content-type"))
    (parseargs s)))

(def readheads (i)
  (accum a
    (whiler l readline.i blank
      (awhen (pos #\: l)
        (a (list (downcase:cut l 0 it)
                 (trim:cut l (+ it 1))))))))

(def readbody (i h)
  (aand (alref h "content-length")
        (errsafe:int it)
        (string:map [coerce _ 'char] (readbs it i))))

(def readreq (i ip)
  (withs ((meth path prot) (tokens:readline i)
          (base qs)        (tokens path #\?)
          heads            (readheads i)
          body             (readbody i heads))
    (inst 'request
          'meth  (sym:downcase meth)
          'path  path
          'prot  prot
          'base  base
          'qs    qs
          'heads heads
          'body  body
          'op    sym.base
          'args  (join (only.parseargs qs) (only.parsebody body heads))
          'cooks (only.parsecooks (alref heads "cookie"))
          'ip    (aif (alref heads "x-real-ip") it ip))))
