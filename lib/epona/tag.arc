(implicit markup 'html)

(def pr-escaped (x)
  (each c x
    (pr (case c #\<  "&lt;"
                #\>  "&gt;"
                #\&  "&amp;"
                #\"  "&quot;"
                #\'  "&#39;"
                c))))

(def tag-attrs (attrs)
  (map (fn (kv) `(do (pr " ")
                     (pr-escaped:string ',kv.0)
                     (pr "=\"")
                     (pr-escaped:string ,kv.1)
                     (pr "\"")))
       attrs))

(def start-tag (name attrs)
  `(do (pr ,(string "<" name))
       ,@(tag-attrs attrs)
       (pr ">")))

(def empty-tag (name attrs)
  `(do (pr ,(string "<" name))
       ,@(tag-attrs attrs)
       (pr:case markup
         html  ">"
         xml   "/>"
         xhtml " />")))

; TODO
(def tag-body (body)
  (map [if atom._
           `(pr-escaped ,_)
           (is _.0 'raw)
           `(pr ,_.1)
           (tags* _.0)
           macex._
           ;(isa (eval _.0) 'fn) ; TODO
           ;`(do ,@(tag-body (list eval._)))
           `(pr-escaped ,_)]
       body))

(def end-tag (name)
  `(pr ,(string "</" name ">")))

(mac tag (name attrs . body)
  (if body
      `(do ,(start-tag name attrs)
           ,@(tag-body body)
           ,(end-tag name))
      `(do ,(empty-tag name attrs))))

(def parse-attrs (x)
  (aif (is (len x) 1)
       (list nil x)
       (no car.x)
       (list nil cdr.x)
       (pos [or (is len._ 1) (no _.0) (~isa _.0 'sym)] pair.x)
       (let (a c) (split x (* 2 it))
           (list a c))
       (list x nil)))

(= tags* (table))

; TODO: confuse me
(mac deftag (name . body)
  (let tag (sym:+ #\< name)
    (= tags*.tag t)
     `(mac ,tag args
        (withs ((attrs children) parse-attrs.args
;                attr-pairs pair.attrs ; TODO: gemsym
;                attr (fn (k (o v)) (or (alref attr-pairs k) v))
                ;each-children (fn (f) (let x (map [f _] children) `(do ,@x)))
                attr     (listtab pair.attrs)
;                setattr  (fn (k v) (= attr.k v))
                getattrs (fn () (let x nil ; TODO flat1
                                  (each _ tablist.attr
                                  (push _.1 x) (push _.0 x)
                                  ) x
                                  ));) ; TODO: bad name
                ;;;getattrs (fn () (flat:tablist attr));) ; TODO: bad name
                ;attrs (fn () (flat:tablist attr));)
;                ,args    (if (acons ',args); TODO: TEST
;                             (map [attr _] ',args)
;                             children);`(list ,@children))) ; TODO
                             ;`(list ,@children)));`(list ,@children))) ; TODO
                )
          (let r (last:list ,@body)
            (if (isa car.r 'cons)
                (cons 'do r)
                r))))))

(mac gentag (name (o prefix))
  (w/uniq g
    (let g (if prefix (string prefix "-" name) name)
      `(deftag ,g
         `(tag ,',name ,pair.attrs ,@children)))))

(mac gentags (prefix . args)
  (each name args
    (eval `(gentag ,name ,prefix))))
