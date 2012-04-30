; Dispatch request.

(require "json.arc")
(require "re.arc")
(require "epona/asset.arc")
(require "epona/ctx.arc")
(require "epona/page.arc")

(mac render (ext . body)
  (let x (case ext
           html 'tostring:render-html
           atom 'tostring:render-atom
           json 'tojson
                'string)
    `(,x ,@body)))

(mac genroutefn (args ext . body)
  `(fn (,@args)
     (point httperr_
       (point redirect_
         (point go_
           (sethead "Content-Type" ,mimetype.ext)
           (setbody (render ,ext ,@body))
           )))
     'respond))

(= dispatch-tbl* (obj get (table) post (table) put (table) delete (table))
   dispatch-idx* (obj get nil     post nil     put nil     delete nil))

(mac defop ((meth name (o ext 'html)) args . body)
  (when (isa name 'string)
    (= name (string "^" name "$"))
    (push name dispatch-idx*.meth))
  `(= ((dispatch-tbl* ',meth) ',name) (genroutefn ,args ,ext ,@body)))

(mac defp (name args . body)
  `(defop (get ,name) ,args ,@body))

(mac deffeed (name args . body)
  `(defop (get ,name atom) ,args ,@body))

(= fn-tbl* (table)
   fn-ids* nil)

(def new-fnid ()
  (check (sym:rand-string 32) ~fn-tbl* (new-fnid)))

(def fnid (f (o lasts (+ (seconds) 86400)))  ; 1 day
  (atlet k (new-fnid)
    (= fn-tbl*.k f)
    (push (list k (seconds) lasts) fn-ids*)
    string.k))

(def harvest-fnids ()
  (pull (fn ((id created lasts))
          (when (> (since created) lasts)
            (wipe (fn-tbl* id))
            t))
        fn-ids*))

(defmemo find-op (meth op)
  (aif dispatch-tbl*.meth.op
       it
       ((afn (s x)
          (aif no.x
               nil
               (re-match-pat car.x s)
               (fn ()
                 (apply (dispatch-tbl*.meth car.x) cdr.it))
               (self s cdr.x))) string.op dispatch-idx*.meth)))

(def find-fn (meth id)
  (awhen (aand (is meth 'post) (fn-tbl* sym.id))
    (wipe (fn-tbl* sym.id))
    it))

(def fnid-field (id)
  (hidden-field "fnid" id))

(mac aform (f . body)
  `(<form 'method "post" 'action ctx!req!path
     (fnid-field (fnid (genroutefn nil html ,f)))
     ,@body))

(def notify ()
  (let (msg type) ctx!notify
    (when msg
      (<div 'class (aif type (+ "notify " it) "notify")
      (<p msg)))))

(def dispatch (ctx)
  (w/ctx ctx
    (aif (file-exists-in-pubdir ctx!req!op)
         (do (sethead "Content-Type"   mimetype.it)
             (sethead "Content-Length" file-size.it)
             (setbody infile.it))
         (find-fn ctx!req!meth arg!fnid)
         (it)
         (find-op ctx!req!meth ctx!req!op)
         (it)
         (do (sethead "Content-Type" mimetype!html)
             (setsta 404)
             (setbody (httpsta 404))))
    (list ctx!req!meth ctx!res!sta ctx!res!heads ctx!res!body)))

(mac go (op . args)
  `(go_ (do (= ctx!req!meth 'get
               ctx!req!op   (sym ,op)
               ctx!notify   (list ,@args))
            (dispatch ctx))))

(mac redirect (loc (o sta 301))
  `(redirect_ (do (setsta ,sta)
                  (sethead "location" ,loc)
                  (setbody nil)
                  t)))

(mac fond     (loc) `(redirect ,loc 302))
(mac seeother (loc) `(redirect ,loc 303))

(mac httperr ((o sta 404))
  `(httperr_ (do (setsta ,sta)
                 (setbody ,httpsta.sta)
                 t)))

(mac badreq   () `(httperr 400))
(mac notfound () `(httperr 404))
(mac srverr   () `(httperr 500))
