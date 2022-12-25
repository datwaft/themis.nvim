(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: pack
                : pack!
                : rock!
                : unpack!} :themis.pack.packer)

(deftest macro/pack
  (testing "works properly with only the identifier"
    (assert-eq (pack :plugin1)
               [:plugin1]))
  (testing "works properly with identifier and options"
    (assert-eq (pack :plugin1 {:option :value})
               {1 :plugin1
                :option :value}))
  (testing "works properly with the special key 'require*'"
    (assert-eq (pack :plugin1 {:option :value
                               :require* :conf.submodule.module})
               {1 :plugin1
                :option :value
                :config "require(\"conf.submodule.module\")"}))
  (testing "works properly with the special key 'setup*'"
    (assert-eq (pack :plugin1 {:option :value
                               :setup* :plugin})
               {1 :plugin1
                :option :value
                :config "require(\"plugin\").setup()"})))

(deftest macro/unpack!
  (testing "works properly after not declaring any plugins"
    (assert-eq (expr->str (unpack!))
               (expr->str ((. (require :packer) :startup) (fn [use])))))
  (testing "works properly after declaring some plugins"
    (pack! :plugin1)
    (pack! :plugin2 {:option :value})
    (assert-eq (expr->str (unpack!))
               (expr->str ((. (require :packer) :startup)
                           (fn [use]
                             (use [:plugin1])
                             (use {1 :plugin2 :option :value}))))))
  (testing "works properly after declaring some plugins and rocks"
    (pack! :plugin1)
    (rock! :some_rock)
    (pack! :plugin2 {:option :value})
    (assert-eq (expr->str (unpack!))
               (expr->str ((. (require :packer) :startup)
                           (fn [use]
                             (use_rocks :some_rock)
                             (use [:plugin1])
                             (use {1 :plugin2 :option :value})))))))

