(local {: nil? : tbl? : str?} (require :themis.lib.types))
(local {: contains?} (require :themis.lib.seq))

(fn get-key [name]
  (or (name:match "^no(.+)$") name))

(fn get-value [name]
  (not (name:match "^no(.+)$")))

(fn args->tbl [args options]
  "Converts a list of arguments to a table of key/value pairs.
  Example of use:
    (args->tbl [:once :group \"something\" :buffer 0 \"this is the description\"]
               {:booleans [:once]
                :last :desc})
  That returns:
    {:once true
     :group \"something\"
     :buffer 0
     :desc \"this is the description\"}"
  (assert (tbl? args) "expected table for args")
  (assert (tbl? options) "expected table for options")
  (assert (tbl? (?. options :booleans))) "expected options to have table for booleans"
  (var {: booleans
        : last} options)
  (var output {})
  (var to-process nil)
  (each [i v (ipairs args)]
    (if (nil? to-process)
      (if
        (and (str? v)
             (contains? booleans (get-key v))) (tset output (get-key v) (get-value v))
        (set to-process v))
      (do
        (tset output to-process v)
        (set to-process nil))))
  (when (and (not (nil? to-process))
             (not (nil? last)))
    (tset output last to-process))
  output)

{: get-key
 : get-value
 : args->tbl}
