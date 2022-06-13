(require-macros :fennel-test)

(local {: args->tbl
        : tbl->args} (require :themis.lib.helpers))

(deftest fn/args->tbl
  (testing "works properly with example"
    (assert-eq (args->tbl [:once :group "something" :buffer 0 "this is the description"]
                          {:booleans [:once]
                           :last :desc})
               {:once true
                :group "something"
                :buffer 0
                :desc "this is the description"}))
  (testing "works properly with no options"
    (assert-eq (args->tbl [:buffer 1 "desc"])
               {:buffer 1}))
  (testing "works properly with only last option specified"
    (assert-eq (args->tbl [:buffer 1 "desc"] {:last :desc})
               {:buffer 1 :desc "desc"}))
  (testing "works properly with single boolean option"
    (assert-eq (args->tbl [:once]
                          {:booleans [:once]})
               {:once true}))
  (testing "works properly with falsy boolean option"
    (assert-eq (args->tbl [:noonce]
                          {:booleans [:once]})
               {:once false}))
  (testing "works properly with single boolean option and description"
    (assert-eq (args->tbl [:once "this is the description"]
                          {:booleans [:once]
                           :last :desc})
               {:once true
                :desc "this is the description"}))
  (testing "ignores last option if not specified"
    (assert-eq (args->tbl [:once "this is the description"]
                          {:booleans [:once]})
               {:once true}))
  (testing "works properly with truthy inverted boolean option"
    (assert-eq (args->tbl [:nowait]
                          {:booleans [:nowait]})
               {:nowait true}))
  (testing "works properly with falsy inverted boolean option"
    (assert-eq (args->tbl [:wait]
                          {:booleans [:nowait]})
               {:nowait false})))

(deftest fn/tbl->args
  (testing "works properly with example"
    (let [tbl {:once true
               :group "something"
               :buffer 0
               :desc "this is the description"}]
      (assert-eq (args->tbl (tbl->args tbl {:last :desc})
                            {:booleans [:once]
                             :last :desc})
                 tbl)))
  (testing "works properly without booleans"
    (let [tbl {:group "something"
               :buffer 0
               :desc "this is the description"}]
      (assert-eq (args->tbl (tbl->args tbl {:last :desc})
                            {:last :desc})
                 tbl)))
  (testing "works properly with booleans"
    (let [tbl {:once true
               :group "something"
               :buffer 0
               :desc "this is the description"}]
      (assert-eq (args->tbl (tbl->args tbl {:last :desc})
                            {:booleans [:once]
                             :last :desc})
                 tbl)))
  (testing "works properly with options"
    (let [tbl {:once true
               :group "something"
               :buffer 0
               :desc "this is the description"}]
      (assert-eq (args->tbl (tbl->args tbl {:last :desc})
                            {:booleans [:once]
                             :last :desc})
                 tbl)))
  (testing "works properly without options"
    (let [tbl {:group "something"
               :buffer 0
               :desc "this is the description"}]
      (assert-eq (args->tbl (tbl->args tbl))
                 tbl)))
  (testing "works properly with a nested list for some value"
    (let [tbl {:some [1 [2 [3]]]}]
      (assert-eq (tbl->args tbl)
                 [:some [1 [2 [3]]]]))))
