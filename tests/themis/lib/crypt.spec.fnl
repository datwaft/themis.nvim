(require-macros :fennel-test)

(local {: djb2} (require :themis.lib.crypt))

(deftest fn/djb2
  (testing "works properly with the string 'Hello!'"
    (assert-eq (djb2 "Hello!") 6952330670010))
  (testing "works properly with the string 'Hello'"
    (assert-eq (djb2 "Hello") 210676686969)))
