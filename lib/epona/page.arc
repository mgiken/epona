(require "date.arc")
(require "epona/assets.arc")
(require "epona/html.arc")
(require "epona/req.arc")

(deftag html5shim
  `(do (pr "<!--[if lt IE 9]>")
       (<script src "http://html5shim.googlecode.com/svn/trunk/html5.js" nil)
       (pr "<![endif]-->")))

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
       (<html
         (<head
           (<meta charset "utf-8")
           (<title ,(attr 'title "Untitled Page"))
           (<inc-css ,@attr!css)
           ,@(map (fn (x) `(<meta ,@x)) attr!meta)
           (<link rel "shortcut icon" href ,(assets "/favicon.ico")) ; TODO
           ,@(map (fn (x) `(<link ,@x)) attr!link)
           (<inc-js ,@attr!js)
           (<html5shim))
         (<body ,@children nil))))

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

(deftag sitename
  `(<h1
     (<a href ,(attr 'url "/")
       (<span ,(attr 'name "Untitled Site")))))

(deftag copyright
  (if (and attr!url attr!owner)
      `(<div id "copyright"
         (raw "&copy; ")
         (datestring (seconds) "~Y ")
         (<a href ,attr!url ,attr!owner))
      `(<div id "copyright"
         (raw "&copy; ")
         (datestring (seconds) "~Y ")
         ,attr!owner)))

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

