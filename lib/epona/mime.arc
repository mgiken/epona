; MIME Types.

(= mime-types* (obj
  txt  "text/plain"
  html "text/html"
  css  "text/css"
  js   "application/x-javascript"
  json "application/json"
  pdf  "application/pdf"
  atom "application/atom+xml"
  gif  "image/gif"
  jpg  "image/jpeg"
  png  "image/png"
  ico  "image/x-icon"
  svg  "image/svg+xml"
  ))

(defmemo mime-type (ext (o fallback "application/octet-stream"))
  (mime-types* (sym:downcase:last (tokens string.ext #\.)) fallback))
