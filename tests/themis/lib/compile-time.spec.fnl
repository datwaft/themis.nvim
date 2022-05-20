(require-macros :fennel-test)

(import-macros {: fn?} :themis.lib.compile-time)

(deftest fn/fn?
  (testing "works properly with a anonymous function"
    (assert-is (fn? (fn [x] x))))
  (testing "works properly with a non-anonymous function"
    (assert-is (fn? (fn non-anonymous [x] x))))
  (testing "works properly with a hash function"
    (assert-is (fn? (hashfn 1))))
  (testing "works properly with a hash function shorthand"
    (assert-is (fn? #1)))
  (testing "works properly with a lambda function"
    (assert-is (fn? (lambda [x] x))))
  (testing "works properly with a partial application"
    (assert-is (fn? (partial (fn [x y] (+ x y)) 1))))
  (testing "works properly with nil"
    (assert-not (fn? nil)))
  (testing "works properly with (+ 1 1)"
    (assert-not (fn? (+ 1 1)))))
