(require-macros :deps.fennel-test)

(local {: nil?
        : str?
        : num?
        : fn?
        : tbl?
        : ->str} (require :fnl.themis.stdlib.types))

(deftest fn/nil?
  (testing "works properly with nil"
    (assert-eq (nil? nil) true))
  (testing "works properly with number"
    (assert-eq (nil? 1234) false))
  (testing "works properly with string"
    (assert-eq (nil? "Hello World") false))
  (testing "works properly with empty list"
    (assert-eq (nil? []) false))
  (testing "works properly with empty table"
    (assert-eq (nil? {}) false))
  (testing "works properly with function"
    (assert-eq (nil? (fn [x] x)) false))
  (testing "works properly with hash-function"
    (assert-eq (nil? #$) false)))

(deftest fn/str?
  (testing "works properly with nil"
    (assert-eq (str? nil) false))
  (testing "works properly with number"
    (assert-eq (str? 1234) false))
  (testing "works properly with string"
    (assert-eq (str? "Hello World") true))
  (testing "works properly with empty list"
    (assert-eq (str? []) false))
  (testing "works properly with empty table"
    (assert-eq (str? {}) false))
  (testing "works properly with function"
    (assert-eq (str? (fn [x] x)) false))
  (testing "works properly with hash-function"
    (assert-eq (str? #$) false)))

(deftest fn/num?
  (testing "works properly with nil"
    (assert-eq (num? nil) false))
  (testing "works properly with number"
    (assert-eq (num? 1234) true))
  (testing "works properly with string"
    (assert-eq (num? "Hello World") false))
  (testing "works properly with empty list"
    (assert-eq (num? []) false))
  (testing "works properly with empty table"
    (assert-eq (num? {}) false))
  (testing "works properly with function"
    (assert-eq (num? (fn [x] x)) false))
  (testing "works properly with hash-function"
    (assert-eq (num? #$) false)))

(deftest fn/fn?
  (testing "works properly with nil"
    (assert-eq (fn? nil) false))
  (testing "works properly with number"
    (assert-eq (fn? 1234) false))
  (testing "works properly with string"
    (assert-eq (fn? "Hello World") false))
  (testing "works properly with empty list"
    (assert-eq (fn? []) false))
  (testing "works properly with empty table"
    (assert-eq (fn? {}) false))
  (testing "works properly with function"
    (assert-eq (fn? (fn [x] x)) true))
  (testing "works properly with hash-function"
    (assert-eq (fn? #$) true)))

(deftest fn/tbl?
  (testing "works properly with nil"
    (assert-eq (tbl? nil) false))
  (testing "works properly with number"
    (assert-eq (tbl? 1234) false))
  (testing "works properly with string"
    (assert-eq (tbl? "Hello World") false))
  (testing "works properly with empty list"
    (assert-eq (tbl? []) true))
  (testing "works properly with empty table"
    (assert-eq (tbl? {}) true))
  (testing "works properly with function"
    (assert-eq (tbl? (fn [x] x)) false))
  (testing "works properly with hash-function"
    (assert-eq (tbl? #$) false)))

(deftest fn/->str
  (testing "works properly with nil"
    (assert-eq (->str nil) "nil"))
  (testing "works properly with number"
    (assert-eq (->str 1234) "1234"))
  (testing "works properly with string"
    (assert-eq (->str "Hello World") "Hello World")))
