; Custom Tags.

(require "humble.arc")
(require "epona/asset.arc")

(extag link
  (awhen attrs!href (= attrs!href asset.it)))

(extag script
  (awhen attrs!src (= attrs!src asset.it)))

(extag img
  (awhen attrs!src (= attrs!src asset.it)))

(def html5shim ()
  (list (raw "<!--[if lt IE 9]>")
        (<script 'src "http://html5shim.googlecode.com/svn/trunk/html5.js" "")
        (raw "<![endif]-->")))

(def inc-css args
  (map [<link 'rel "stylesheet" 'type "text/css"
              'href (+ "/css/" _ ".css")] args))

(def inc-js args
  (map [<script 'src (+ "/js/" _ ".js") ""] args))

(def ga (id)
  (<script (raw:string
    "var _gaq=_gaq||[];"
    "_gaq.push(['_setAccount','" id "']);"
    "_gaq.push(['_trackPageview']);"
    "(function() {"
      "var ga=document.createElement('script');"
      "ga.async=true;"
      "ga.src='https://ssl.google-analytics.com/ga.js';"
      "var s=document.getElementsByTagName('script')[0];"
      "s.parentNode.insertBefore(ga,s);"
    "})();")))

(def page args
  (let (attrs nodes) parse-attrs-nodes.args
    (<html 'lang (attrs 'lang "jp")
      (<head
        (<meta 'charset "utf-8")
        (<title (attrs 'title "Untitled Page"))
        (apply inc-css "app" attrs!css)
        (map [apply <meta _] attrs!meta)
        (<link 'rel "shortcut icon" 'href (asset "/favicon.ico"))
        (map [apply <link _] attrs!link)
        (apply inc-js attrs!js)
        (html5shim)
        (awhen attrs!ga (ga it)))
      (<body 'id attrs!id nodes))))

(mac deflayout (name tit hd ft (o sep " | "))
  `(def ,name args
    (let (attrs nodes) parse-attrs-nodes.args
      (= attrs!title (aif attrs!title (+ it ,sep ,tit) ,tit))
      (page attrs
        (<header 'id "header"  ,@hd)
        (<div    'id "content" nodes)
        (<footer 'id "footer"  ,@ft)))))

(def sitename (name (o url "/"))
  (<h1 (<a 'href url 'title name name)))

(def copyright (owner)
  (<p 'class "copyright" (raw "&copy; ") (datestring (seconds) "~Y ") owner))

(def hidden-field (name (o value ""))
  (<input 'type "hidden" 'name name 'value value))

(def fnid-field (x)
  (hidden-field "fnid" x))

(def abtn (text (o id) (o class))
  (<a 'id id 'title text 'class (aif class (+ "button " it) "button") text))

(def sbtn (text (o id) (o class))
  (<input 'type "submit" 'id id 'name id 'title text 'value text
          'class (aif class (+ "button " it) "button")))

(def notify (msg (o type))
  (when msg
    (<div 'class (aif type (+ "notify " it) "notify")
      (<p msg))))
