(local {: args->tbl} (require :themis.lib.helpers))
(local {: all? : first} (require :themis.lib.seq))
(local {: ->str : nil? : tbl? : str?} (require :themis.lib.types))
(local {: quoted? : quoted->fn : quoted->str : expand-exprs} (require :themis.lib.compile-time))

(lambda autocmd! [event pattern command ...]
  "Create an autocommand using the nvim_create_autocmd API.

  Accepts the following arguments:
  event -> can be either a symbol or a list of symbols.
  pattern -> can be either a symbol or a list of symbols. If it's <buffer> the
             buffer option is set to 0. If the buffer option is set this value is ignored.
  command -> can be an string, a symbol, a function or a quoted expression.
  ... -> is a list of key/value pairs or only keys as strings.
         accepts 'once' and 'nested' as boolean keys (do not have values, can
         be prepended by 'no' to set them to false)
         Any other key requires a value (cannot be nil)
         If the last element is a lone string that is not a boolean key then it
         becomes the description

  Example of use:
  ```fennel
  (autocmd! VimEnter *.py '(print \"Hello World\")
            :once :group \"custom\"
            \"This is a description\")
  ```
  That compiles to:
  ```fennel
  (vim.api.nvim_create_autocmd :VimEnter
                               {:pattern \"*.py\"
                                :callback (fn [] (print \"Hello World\"))
                                :once true
                                :group \"custom\"
                                :desc \"This is a description\"})
  ```"
  (let [options (args->tbl [...] {:booleans [:once :nested]
                                  :last :desc})
        event (if (and (tbl? event) (not (sym? event)))
                (icollect [_ v (ipairs event)] (->str v))
                (->str event))
        pattern (if (and (tbl? pattern) (not (sym? pattern)))
                  (icollect [_ v (ipairs pattern)] (->str v))
                  (->str pattern))
        options (if (nil? options.buffer)
                  (if (= "<buffer>" pattern)
                    (doto options (tset :buffer 0))
                    (doto options (tset :pattern pattern)))
                  options)
        options (if (str? command)
                  (doto options (tset :command command))
                  (doto options (tset :callback (if (quoted? command)
                                                  (quoted->fn command)
                                                  command))))
        options (if (nil? options.desc)
                  (doto options (tset :desc (if (quoted? command) (quoted->str command)
                                              (str? command) command
                                              (view command))))
                  options)]
    `(vim.api.nvim_create_autocmd ,event ,options)))

(lambda augroup! [name ...]
  "Create an augroup using the nvim_create_augroup API.
  Accepts either a name or a name and a list of autocmd statements.

  Example of use:
  ```fennel
  (augroup! a-nice-group
    (autocmd! Filetype *.py '(print \"Hello World\"))
    (autocmd! Filetype *.sh '(print \"Hello World\")))
  ```
  That compiles to:
  ```fennel
  (do
    (vim.api.nvim_create_augroup \"a-nice-group\" {})
    (autocmd! Filetype *.py '(print \"Hello World\") :group \"a-nice-group\")
    (autocmd! Filetype *.sh '(print \"Hello World\") :group \"a-nice-group\"))
  ```"
  (assert-compile (or (str? name) (sym? name)) "expected string or symbol for name" name)
  (assert-compile (all? #(and (list? $) (or (= 'clear! (first $))
                                            (= 'autocmd! (first $)))) [...]) "expected autocmd exprs for body" ...)
  (expand-exprs
    (let [name (->str name)]
      (icollect [_ expr (ipairs [...])
                 :into [`(vim.api.nvim_create_augroup ,name {})]]
        (if (= 'autocmd! (first expr))
          (doto expr
            (table.insert :group)
            (table.insert name))
          (let [[_ & args] expr]
            `(clear! ,name ,(unpack args))))))))

(lambda clear! [name ...]
  "Clears an augroup using the nvim_clear_autocmds API.

  Example of use:
  ```fennel
  (clear! some-group)
  ```
  That compiles to:
  ```fennel
  (vim.api.nvim_clear_autocmds {:group \"some-group\"})
  ```"
  (assert-compile (or (str? name) (sym? name)) "expected string or symbol for name" name)
  (let [name (->str name)]
    `(vim.api.nvim_clear_autocmds ,(doto (args->tbl [...])
                                         (tset :group name)))))

{: autocmd!
 : augroup!
 : clear!}
