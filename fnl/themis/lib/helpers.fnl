(local {: nil? : tbl? : str?} (require :themis.lib.types))
(local {: begins-with?} (require :themis.lib.string))
(local {: contains?} (require :themis.lib.seq))

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
  (let [options (or options {})
        booleans (or options.booleans [])
        last options.last]
    (var output {})
    (var to-process nil)
    (each [i v (ipairs args)]
      (if (nil? to-process)
        (if (str? v)
          (let [begins-with-no? (begins-with? :no v)
                v-with-no (if begins-with-no? v (.. :no v))
                v-without-no (if begins-with-no? (v:match "^no(.+)$") v)]
            (if begins-with-no?
              (if (contains? booleans v-without-no) (doto output (tset v-without-no false))
                (contains? booleans v-with-no) (doto output (tset v-with-no true))
                (set to-process v))
              (if (contains? booleans v-without-no) (doto output (tset v-without-no true))
                (contains? booleans v-with-no) (doto output (tset v-with-no false))
                (set to-process v))))
          (set to-process v))
        (do
          (tset output to-process v)
          (set to-process nil))))
    (when (and (not (nil? to-process))
               (not (nil? last)))
      (tset output last to-process))
    output))

{: args->tbl}
