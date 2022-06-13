(require-macros :fennel-test)

(local {: empty?
        : first
        : second
        : last
        : any?
        : all?
        : contains?
        : flatten} (require :themis.lib.seq))

(deftest fn/empty?
  (testing "works properly with empty list"
    (assert-is (empty? [])))
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

(deftest fn/any?
  (testing "works properly with empty list"
    (assert-not (any? #(= 1 $) [])))
  (testing "works properly with a list that doesn't satify the predicate"
    (assert-not (any? #(= 9999 $) [0 1 2 3 4 5 6 7 9])))
  (testing "works properly with a list that satisfies the predicate"
    (assert-is (any? #(= 0 $) [0 1 2 3 4 5 6 7 9]))))

(deftest fn/all?
  (testing "works properly with empty list"
    (assert-is (all? #(= 1 $) [])))
  (testing "works properly with a list that doesn't satify the predicate"
    (assert-not (all? #(= 1 $) [1 1 1 1 1 9 1 1])))
  (testing "works properly with a list that satisfies the predicate"
    (assert-is (all? #(= 1 $) [1 1 1 1 1 1 1 1]))))

(deftest fn/contains?
  (testing "works properly with empty list"
    (assert-not (contains? [] 1))
    (assert-not (contains? [] "")))
  (testing "works properly with a list of one element"
    (assert-is (contains? [1] 1))
    (assert-not (contains? ["Hello"] "World")))
  (testing "works properly with a list of three elements"
    (assert-is (contains? [1 2 3] 2))
    (assert-not (contains? [1 2 3] 4))))

(deftest fn/flatten
  (testing "works properly with empty list"
    (assert-eq (flatten []) []))
  (testing "works properly with one element list"
    (assert-eq (flatten [:a]) [:a]))
  (testing "works properly with a list of a list of one element"
    (assert-eq (flatten [[:a]]) [:a]))
  (testing "works properly with a mixed list"
    (assert-eq (flatten [:a :b [:c :d] :e]) [:a :b :c :d :e]))
  (testing "works properly with a nested list"
    (assert-eq (flatten [:a [:b [:c [:d [:e]]]]]) [:a :b :c :d :e]))
  (testing "works properly with a nested list and with 0 levels (explicitly)"
    (assert-eq (flatten [:a [:b [:c [:d [:e]]]]] 0) [:a [:b [:c [:d [:e]]]]]))
  (testing "works properly with a nested list and with 1 level"
    (assert-eq (flatten [:a [:b [:c [:d [:e]]]]] 1) [:a :b [:c [:d [:e]]]]))
  (testing "works properly with a nested list and with 2 levels"
    (assert-eq (flatten [:a [:b [:c [:d [:e]]]]] 2) [:a :b :c [:d [:e]]])))
