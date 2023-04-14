(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: extend-fn} :themis.fn)

(deftest macro/extend-fn
  (testing "works properly with the example"
    (assert-eq (expr->str (extend-fn greet [message]
                            (print message)))
               (expr->str (let [old# greet]
                            (set greet (fn [...]
                                         (local result# [(old# ...)])
                                         (local [message] result#)
                                         (print message)
                                         (values (unpack result#))))
                            greet)))))
