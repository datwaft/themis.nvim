(do
  (macro any? [iter-tbl body]
    (let [accum-var (gensym)]
      `(do (var ,accum-var false)
           (each [,(unpack (doto iter-tbl
                                 (table.insert :until)
                                 (table.insert `(= ,accum-var true))))]
             (if ,body
               (set ,accum-var true)))
           ,accum-var)))
  (any? [_ v (ipairs [1 2 3 4])]
    (= v 5)))
