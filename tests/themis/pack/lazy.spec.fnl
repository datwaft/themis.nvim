(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: pack} :themis.pack.lazy)

(deftest macro/pack
  (testing "works properly with only the identifier"
    (assert-eq (pack :plugin1)
               [:plugin1]))
  (testing "works properly with identifier and options"
    (assert-eq (pack :plugin1 {:option :value})
               {1 :plugin1
                :option :value}))
  (testing "works properly with the special key 'require*'"
    (assert-eq (expr->str (pack :plugin1 {:option :value
                                          :require* :conf.submodule.module}))
               (expr->str {1 :plugin1
                           :option :value
                           :config #(require "conf.submodule.module")}))))
