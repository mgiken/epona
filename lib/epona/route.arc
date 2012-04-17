; Routing Util.

(require "json.arc")
(require "re.arc")
(require "humble.arc")
(require "epona/ctx.arc")

(= route-fns* (obj get (table) post (table) put (table) delete (table))
   route-idx* (obj get nil     post nil     put nil     delete nil))

(mac render (ext . body)
  (let x (case ext
           html 'tostring:render-html
           atom 'tostring:render-atom
           json 'tojson
                'string)
    `(,x ,@body)))

(mac route-fn (args ext . body)
  `(fn (,@args)
     (point httperr_
       (point redirect_
         (point go_
           (sethd "Content-Type" ,mime-type.ext)
           (= ctx!o (render ,ext ,@body)))))))

(mac defop ((meth name (o ext 'html)) args . body)
  (when (isa name 'string)
    (= name (string "^" name "$"))
    (push name route-idx*.meth))
  `(= ((route-fns* ',meth) ',name) (route-fn ,args ,ext ,@body)))

(mac defp (name args . body)
  `(defop (get ,name) ,args ,@body))

(mac deffeed (name args . body)
  `(defop (get ,name atom) ,args ,@body))

(mac go (op (o msg))
  `(go_ (do (= ctx!meth 'get
               ctx!op   (sym ,op))
            (respond-page))))

(mac redirect (loc (o sta 301))
  `(redirect_ (= ctx!o   nil
                 ctx!hds (list (list "Location" ,loc))
                 ctx!sta ,sta)))

(mac fond     (loc) `(redirect ,loc 302))
(mac seeother (loc) `(redirect ,loc 303))

(mac httperr ((o sta 404))
  `(httperr_ (= ctx!o ,http-sta.sta
                ctx!hds (list (list "Content-Type" ,mime-type!html))
                ctx!sta ,sta)))

(mac badreq   () `(httperr 400))
(mac notfound () `(httperr 404))
(mac srverr   () `(httperr 500))

(= fns* (table) fnids* nil)

(def new-fnid ()
  (check (sym:rand-string 32) ~fns* (new-fnid)))

(def fnid (f (o lasts (+ (seconds) 259200)))  ; 3 day
  (atlet k (new-fnid)
    (= fns*.k f)
    (push (list k (seconds) lasts) fnids*)
    string.k))

(def harvest-fnids ()
  (pull (fn ((id created lasts))
          (when (> (since created) lasts)
            (wipe (fns* id))
            t))
        fnids*))

; TODO
(defmemo find-op (meth op)
  (aif (aand (is meth 'post) (fns* (sym arg!fnid)))
       it
       route-fns*.meth.op
       it
       ((afn (s x)
          (aif no.x
               nil
               (re-match-pat car.x s)
               (fn ()
                 (apply (route-fns*.meth car.x) cdr.it))
               (self s cdr.x))) string.op route-idx*.meth)))
