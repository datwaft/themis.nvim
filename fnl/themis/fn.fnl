(lambda extend-fn [fn-name args & body]
  (assert-compile (sym? fn-name) "expected symbol for fn-name" fn-name)
  (assert-compile (sequence? args) "expected list for args" args)
  (assert-compile (> (length body) 0) "expected at least one statement" body)
  (table.insert body '(values (unpack result#)))
  `(let [old# ,fn-name]
     (set ,fn-name
          (fn [...]
            (local result# [(old# ...)])
            (local [,(unpack args)] result#)
            ,(unpack body)))
     ,fn-name))

{: extend-fn}
