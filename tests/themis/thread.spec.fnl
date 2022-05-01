(require-macros :deps.fennel-test)
(local expr->str #(macrodebug $1 nil))

(import-macros {: as->} :fnl.themis.thread)

(deftest macro/as->
  (testing "able to work properly"
    (assert-eq (expr->str (as-> [$ 1]
                            (+ $ 1)
                            (+ $ 1)))
               (expr->str (let [$ 1
                                $ (+ $ 1)
                                $ (+ $ 1)] $)))))
