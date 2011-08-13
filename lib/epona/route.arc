; TODO: test

(require "re.arc")
(require "epona/html.arc")
(require "epona/req.arc")

(= route-map* (table) route-idx* nil)
(= fns* (table) fnids* nil timed-fnids* nil)

; TODO: test
(mac defp (name . body)
  (w/uniq (gs gr ge)
    (when (isa name 'string)
      (= name (string "^" name "$")) ;TODO: test
      (push name route-idx*))
    `(= (route-map* ',name)
        (fn ()
          (withs (,gs nil
                  ,gr nil
                  ,ge (point _httperr
                        (= ,gr (point _redirect
                                 (= ,gs (tostring ,@body))))))
            (list ,gs ,gr ,ge))))))

; TODO: cache & test
(def find-op (op)
  (aif route-map*.op
       (list it)
       ((afn (lst)
          (aif no.lst
               nil
               (re-match-pat car.lst string.op)
               (cons (route-map* car.lst) cdr.it)
               (self cdr.lst))) route-idx*)))

;(def dispatch ()
;  (awhen (find-op req!op)
;    (= req!pargs cdr.it)
;    (car.it)))

; TODO
; HEAD, GET, POSTのみ処理する?
(def dispatch ()
  (if (is req!meth 'post)
      (awhen (fns*:sym:arg 'fnid)
        ; TODO: httperr, redirect
        (list (tostring:it) nil nil))
      (awhen (find-op req!op)
        (= req!pargs cdr.it)
        (car.it))))

(mac redirect args
  `(_redirect '(,@args)))

(mac httperr args
  (if args
      `(_httperr '(,@args))
      `(_httperr '(404))))

; ----------------------------------------------------------------------------
; XXX:
; TODO: test

(def new-fnid ()
  (check (sym:rand-string 20) ~fns* (new-fnid)))

(def fnid (f)
  (atlet key (new-fnid)
    (= (fns* key) f)
    (push key fnids*)
    key))

(def timed-fnid (lasts f)
  (atlet key (new-fnid)
    (= fns*.key f)
    (push (list key (seconds) lasts) timed-fnids*)
    key))

(mac afnid (f)
  `(atlet it (new-fnid)
     (= fns*.it ,f)
     (push it fnids*)
     it))

(def harvest-fnids ((o n 50000))  ; was 20000
  (when (len> fns* n)
    (pull (fn ((id created lasts))
            (when (> (since created) lasts)
              (wipe (fns* id))
              t))
          timed-fnids*)
    (atlet nharvest (trunc (/ n 10))
      (let (kill keep) (split (rev fnids*) nharvest)
        (= fnids* (rev keep))
        (each id kill
          (wipe (fns* id)))))))

(def fnid-field (id)
  (<input type "hidden" name "fnid" value id) nil)

;;;;;;;; f should be a fn of one arg, which will be http request args.
;;;;; (def fnform (f bodyfn (o redir))
;;;;;   (tag (form method 'post action (if redir rfnurl2* fnurl*))
;;;;;     (fnid-field fnid.f)
;;;;;     (bodyfn)))

;; Could also make a version that uses just an expr, and var capture.
;; Is there a way to ensure user doesn't use "fnid" as a key?

; FIXME
(mac aform (f . body)
  (w/uniq ga
    `(<form method "post"; action fnurl*)
       (fnid-field (fnid (fn () (,f))))
       ,@body)))

;(mac aform (f . body)
;  (w/uniq ga
;    `(<form method "post"; action fnurl*)
;       (fnid-field (fnid (fn (,ga)
;                           (prn)
;                           (,f ,ga))))
;       ,@body)))

; ----------------------------------------------------------------------------

;(defp /fn
;  (let xxx "hoge"
;  (aform (fn () (prn xxx) (prn req!args))
;    xxx
;    "name:" (<input type "text" name "name" value "")
;    (<br)
;    (<input type "submit" value "test")
;  )))
