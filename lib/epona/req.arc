(implicit request)

(defs arg  (k (o dv)) (or (alref request!args  string.k) dv)
      head (k (o dv)) (or (alref request!heads string.k) dv)
      cook (k (o dv)) (or (alref request!cooks string.k) dv))

(deftem request
  meth  nil
  path  nil
  prot  nil
  heads nil
  body  nil
  op    nil
  qs    nil
  args  nil
  cooks nil
  ip    nil)

(def parseargs (s)
  (map [map urldecode (tokens _ #\=)] (tokens s #\&)))

(def parsebody (s heads)
  (when (findsubseq "x-www-form-urlencoded" (alref heads "content-type"))
    (parseargs s)))

(def parsecooks (s)
  (map [tokens trim._ #\=] (tokens s #\;)))

(def readheads (i)
  (accum a
    (whiler line readline.i blank
      (awhen (pos #\: line)
        (a (list (downcase:cut line 0 it)
                 (trim:cut line (+ it 1))))))))

(def readbody (i heads)
  (aand (alref heads "content-length")
        (errsafe:int it)
        (string:map [coerce _ 'char] (readbs it i))))

(def readreq (i ip)
  (withs ((meth path prot) (tokens:readline i)
          (base qs)        (tokens path #\?)
           heads           (readheads i)
           body            (readbody i heads))
    (inst 'request 'meth  (sym:downcase meth)
                   'path  path
                   'prot  prot
                   'heads heads
                   'body  body
                   'op    sym.base
                   'qs    qs
                   'args  (join (only.parseargs qs) (only.parsebody body heads))
                   'cooks (only.parsecooks (alref heads "cookie"))
                   'ip    (aif (alref heads "x-real-ip") it ip))))
