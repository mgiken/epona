; Custom Tags.

(require "epona/route.arc")

(deftag html5shim (a c)
  (list (raw "<!--[if lt IE 9]>")
        (<script 'src "http://html5shim.googlecode.com/svn/trunk/html5.js" nil)
        (raw "<![endif]-->")))

(deftag inc-css (a c)
  (map [<link 'rel "stylesheet" 'type "text/css"
              'href (assets:+ "/css/" _ ".css")] car.c))

(deftag page (a c)
  (<html 'lang (a 'lang "jp")
    (<head
      (<meta 'charset "utf-8")
      (<title (a 'title "Untitled Page"))
      (<inc-css a!css)
;          ,@(map (fn (x) `(<meta ,@x)) attr!meta)
      (<link 'rel "shortcut icon" 'href (assets "/favicon.ico"))
;      ,@(map (fn (x) `(<link ,@x)) attr!link)
;           (<inc-js ,@attr!js)
      (<html5shim)
      )
;           (<ga ,@attr!ga))
    (aif a!id
      (<body 'id it c)
      (<body c))))

(mac deflayout (name title hd ft (o sep " | "))
  `(deftag ,name (a c)
     (= a!title (if a!title
                    (+ a!title ,sep ,title)
                    title))
     (pushnew "app" a!css)
     (<page a
       (<header 'id "header" ,@hd)
       (<div 'id "content" c)
       (<footer 'id "footer" ,@ft))))

(deftag sitename (a c)
  (<h1
    (<a 'href (a 'url "/")
      (<span c.0))))

(deftag copyright (a c)
  (<span 'class "copyright"
    (raw "&copy; ")
    (datestring (seconds) "~Y ")
    (<a 'href c.0 c.1)))

(deftag input-hdn (a c)
  (<input 'type "hidden" 'name c.0 'value c.1))

; TODO
(mac <aform args
  `(<form 'method "post" 'action ctx!path
     (<input-hdn "fnid" (fnid (route-fn nil html (list ,car.args))))
     ,@cdr.args))
#|
(deftag inc-css
  ; TODO: assets
  (map (fn (x)
         `(<link rel "stylesheet" type "text/css" href ,x))
       children))

(deftag inc-js
  ; TODO: assets
  (map (fn (x)
         `(<script src ,x nil))
       children))

(deftag page
  `(do (doctype)
       (<html lang ,(attr 'lang "jp")
         (<head
           (<meta charset "utf-8")
           (<title ,(attr 'title "Untitled Page"))
           (<inc-css ,@attr!css)
           ,@(map (fn (x) `(<meta ,@x)) attr!meta)
           (<link rel "shortcut icon" href ,(assets "/favicon.ico")) ; TODO
           ,@(map (fn (x) `(<link ,@x)) attr!link)
           (<inc-js ,@attr!js)
           (<html5shim))
         (<body ,@(awhen attr!id (list 'id it)) ,@children nil))))

; ----------------------------------------------------------------------------

; (mac deflayout (name basetitle header footer (o titlesep " | "))
;   `(deftag ,name
;      (= attr!title (if attr!title
;                        (string attr!title ,titlesep ,basetitle)
;                        ,basetitle))
;      `(<page css ("/css/app.css") ,@(getattrs) ; TODO
;         (<header id "header" ,@,header)
;         (<div id "content" ,@children nil)
;         (<footer id "footer" ,@,footer))))
; TODO: test
(mac deflayout (name basetitle header footer (o titlesep " | "))
  `(deftag ,name
    (= attr!title (if attr!title
                       `(string ,attr!title ,,titlesep ,,basetitle)
                       ,basetitle))
    `(<page css ("/css/app.css") ,@(getattrs); TODO
        (<header id "header" ,@,header)
        (<div id "content" ,@children nil)
        (<footer id "footer" ,@,footer))))

; TODO: test
(deftag globalnav
  `(<nav id "globalnav"
     (<ul ,@(map (fn ((url label))
                   `(<li id ,url
                      (<a href ,url
                        (<span ,label))))
                 children))))

; TODO: test
(deftag message
  `(awhen request!msg
    (<p it)))


|#
