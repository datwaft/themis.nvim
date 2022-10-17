(local {: ->str} (require :themis.lib.types))

(lambda highlight! [name attributes colors]
  "Sets a highlight group globally using the vim.api.nvim_set_hl API.
  Accepts the following arguments:
  name -> a symbol.
  attributes -> a list of boolean attributes:
    - bold
    - italic
    - reverse
    - inverse
    - standout
    - underline
    - underlineline
    - undercurl
    - underdot
    - underdash
    - strikethrough
    - default
  colors -> a table of colors:
    - fg
    - bg
    - ctermfg
    - ctermbg

  Example of use:
  ```fennel
  (highlight! Error [:bold] {:fg \"#ff0000\"})
  ```
  That compiles to:
  ```fennel
  (vim.api.nvim_set_hl 0 \"Error\" {:fg \"#ff0000\"
                                    :bold true})
  ```"
  (assert-compile (sym? name) "expected symbol for name" name)
  (assert-compile (table? attributes) "expected table for attributes" attributes)
  (assert-compile (table? colors) "expected colors for colors" colors)
  (let [name (->str name)
        definition (collect [_ attr (ipairs attributes)
                             :into colors]
                     (->str attr) true)]
    `(vim.api.nvim_set_hl 0 ,name ,definition)))

{: highlight!}
