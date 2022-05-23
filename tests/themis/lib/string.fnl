(require-macros :fennel-test)

(local {: begins-with?} (require :themis.lib.string))

(deftest fn/begins-with?
  (testing "works properly with truthy value"
    (assert-is (begins-with? :no "nowait")))
  (testing "works properly with falsy value"
    (assert-not (begins-with? :no "wait"))))
