(require-macros :fennel-test)

(local {: get-key
        : get-value
        : args->tbl} (require :themis.lib.helpers))

(deftest fn/get-key
  (testing "works properly with truthy value"
    (assert-eq (get-key "value")
               "value"))
  (testing "works properly with falsy value"
    (assert-eq (get-key "novalue")
               "value")))

(deftest fn/get-value
  (testing "works properly with truthy value"
    (assert-eq (get-value "value")
               true))
  (testing "works properly with falsy value"
    (assert-eq (get-value "novalue")
               false)))

(deftest fn/args->tbl
  (testing "works properly with example"
    (assert-eq (args->tbl [:once :group "something" :buffer 0 "this is the description"]
                          {:booleans [:once]
                           :last :desc})
               {:once true
                :group "something"
                :buffer 0
                :desc "this is the description"}))
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
               {:once true})))
