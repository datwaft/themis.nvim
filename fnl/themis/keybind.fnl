(local {: args->tbl} (require :themis.lib.helpers))
(local {: ->str : nil? : str?} (require :themis.lib.types))
(local {: fn? : quoted? : quoted->fn : quoted->str} (require :themis.lib.compile-time))

(lambda map! [[modes] lhs rhs ...]
  "Add a new mapping using the vim.keymap.set API.

  Accepts the following arguments:
  modes -> is a sequence containing a symbol, each character of the symbol is a mode.
  lhs -> must be an string.
  rhs -> can be an string, a symbol, a function or a quoted expression.
  ... -> a list of options. The valid boolean options are the following:
         - nowait
         - silent
         - script
         - expr
         - replace_keycodes
         - remap
         - unique
         These options can be prepended by 'no' to set them to false.
         The last option that doesn't have a pair and is not boolean will become the description.

  Example of use:
  ```fennel
  (map! [nv] \"<leader>lr\" vim.lsp.references
        :silent :buffer 0
        \"This is a description\")
  ```
  That compiles to:
  ```fennel
  (vim.keymap.set [:n :v] \"<leader>lr\" vim.lsp.references
                  {:silent true
                   :buffer 0
                   :desc \"This is a description\"})
  ```"
  (assert-compile (sym? modes) "expected symbol for modes" modes)
  (assert-compile (str? lhs) "expected string for lhs" lhs)
  (assert-compile (or (str? rhs) (sym? rhs) (fn? rhs) (quoted? rhs)) "expected string, symbol, function or quoted expression for rhs" rhs)
  (let [options (args->tbl [...] {:booleans [:nowait :silent :script :expr :replace_keycodes :remap :unique]
                                  :last :desc})
        modes (icollect [char (string.gmatch (->str modes) ".")] char)
        options (if (nil? options.desc)
                  (doto options (tset :desc (if (quoted? rhs) (quoted->str rhs)
                                              (str? rhs) rhs
                                              (view rhs))))
                  options)
        rhs (if (quoted? rhs) (quoted->fn rhs) rhs)]
    `(vim.keymap.set ,modes ,lhs ,rhs ,options)))

{: map!}
