(local {: ->bool} (require :themis.lib.types))

(fn begins-with? [chars str]
  "Return whether str begins with chars."
  (->bool (str:match (.. "^" chars))))

{: begins-with?}
