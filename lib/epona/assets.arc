(require "files.arc")
(require "re.arc")

(require "epona/conf.arc")

(def file-exists-in-pubdir (file)
  (awhen (re-replace "\\.v\\d*\\." string.file ".")
    (or (file-exists (qualified-path:string appdir* "/pub/" it))
        (file-exists (qualified-path:string sysdir* "/pub/" it)))))

(def assets (file)
  (aif (file-exists-in-pubdir file)
       (re-replace "\\.([^.]*)$" file (+ ".v" mtime.it ".\\1"))
       file))
