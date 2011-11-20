; http://www.iana.org/assignments/media-types/

(= default_type* "application/octet-stream")

(= mimetype* (obj
  html "text/html; charset=utf-8"
  htm  "text/html; charset=utf-8"
  css  "text/css; charset=utf-8"
  txt  "text/plain; charset=utf-8"

  xml  "application/xml; charset=utf-8"
  atom "application/atom+xml; charset=utf-8"
  rss  "application/rss+xml; charset=utf-8"

  js   "application/x-javascript; charset=utf-8"
  swf  "application/x-shockwave-flash"
  pdf  "application/pdf"

  gif  "image/gif"
  jpeg "image/jpeg"
  jpg  "image/jpeg"
  png  "image/png"
  tif  "image/tiff"
  tiff "image/tiff"
  ico  "image/x-icon"
  svg  "image/svg+xml"
  ))

(def mimetype (file)
  (or (mimetype* (sym:downcase:last (check (tokens string.file #\.) ~single)))
      default_type*))
