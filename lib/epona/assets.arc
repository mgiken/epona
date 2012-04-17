; Assets File Util.

(require "files.arc")
(require "re.arc")

(unless (bound 'appdir*)
  (= appdir* "."))

(def file-exists-in-pubdir (file)
  (aand (re-replace "\\.v\\d*\\." string.file ".")
        (file-exists:+ appdir* "/pub/" it)))

(def assets (file)
  (aif (file-exists-in-pubdir file)
       (re-replace "\\.([^.]*)$" file (+ ".v" mtime.it ".\\1"))
       file))
