(require-macros :fennel-test)

(local {: djb2} (require :themis.lib.crypt))

(deftest fn/djb2
  (testing "works properly with the string 'Hello!'"
    (assert-eq (djb2 "Hello!") "b7332fba"))
  (testing "works properly with the string 'Hello'"
    (assert-eq (djb2 "Hello") "0d4f2079"))
  (testing "works properly with the string '(quote (+ 1 2))'"
    (assert-eq (djb2 "(quote (+ 1 2))") "7fd7c3e3")))
