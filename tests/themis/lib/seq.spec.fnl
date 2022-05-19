(require-macros :fennel-test)

(local {: empty?
        : first
        : second
        : last
        : contains?} (require :themis.lib.seq))

(deftest fn/empty?
  (testing "works properly with empty list"
    (assert-not (empty? [])))
  (testing "works properly with non-empty list"
    (assert-not (empty? [1 2 3 4]))))

(deftest fn/first
  (testing "works properly with empty list"
    (assert-eq (first []) nil))
  (testing "works properly with non-empty list"
    (assert-eq (first [1 2 3 4]) 1))
  (testing "works properly with one element list"
    (assert-eq (first [1]) 1))
  (testing "works properly with two element list"
    (assert-eq (first [1 2]) 1)))

(deftest fn/second
  (testing "works properly with empty list"
    (assert-eq (second []) nil))
  (testing "works properly with non-empty list"
    (assert-eq (second [1 2 3 4]) 2))
  (testing "works properly with one element list"
    (assert-eq (second [1]) nil))
  (testing "works properly with two element list"
    (assert-eq (second [1 2]) 2)))

(deftest fn/last
  (testing "works properly with empty list"
    (assert-eq (last []) nil))
  (testing "works properly with non-empty list"
    (assert-eq (last [1 2 3 4]) 4))
  (testing "works properly with one element list"
    (assert-eq (last [1]) 1))
  (testing "works properly with two element list"
    (assert-eq (last [1 2]) 2)))

(deftest fn/last
  (testing "works properly with empty list"
    (assert-not (contains? [] 1))
    (assert-not (contains? [] "")))
  (testing "works properly with a list of one element"
    (assert-is (contains? [1] 1))
    (assert-not (contains? ["Hello"] "World")))
  (testing "works properly with a list of three elements"
    (assert-is (contains? [1 2 3] 2))
    (assert-not (contains? [1 2 3] 4))))
