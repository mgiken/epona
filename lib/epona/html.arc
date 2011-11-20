(require "epona/tag.arc")

; HTML5 tags
; http://www.w3schools.com/html5/html5_reference.asp
(gentags nil
  a abbr address area article aside audio
  b base bdo blockquote body br button
  canvas caption cite code col colgroup command
  datalist dd del details dfn div dl dt
  em embed
  fieldset figcaption figure footer form
  h1 h2 h3 h4 h5 h6 head header hgroup hr html
  i iframe img input ins
  keygen kbd
  label legend li link
  map mark menu meta meter
  nav noscript
  object ol optgroup option output
  p param pre progress
  q
  rp rt ruby
  samp script section select small source span strong style sub summary sup
  table tbody td textarea tfoot th thead time title tr
  ul
  var video
  wbr)

(def doctype ()
  (pr "<!DOCTYPE html>"))
