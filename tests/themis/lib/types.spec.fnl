(require-macros :fennel-test)

(local {: nil?
        : str?
        : num?
        : fn?
        : tbl?
        : ->str} (require :themis.lib.types))

(deftest fn/nil?
  (testing "works properly with nil"
    (assert-is (nil? nil)))
  (testing "works properly with number"
    (assert-not (nil? 1234)))
  (testing "works properly with string"
    (assert-not (nil? "Hello World")))
  (testing "works properly with empty list"
    (assert-not (nil? [])))
  (testing "works properly with empty table"
    (assert-not (nil? {})))
  (testing "works properly with function"
    (assert-not (nil? (fn [x] x))))
  (testing "works properly with hash-function"
    (assert-not (nil? #$))))

(deftest fn/str?
  (testing "works properly with nil"
    (assert-not (str? nil)))
  (testing "works properly with number"
    (assert-not (str? 1234)))
  (testing "works properly with string"
    (assert-is (str? "Hello World")))
  (testing "works properly with empty list"
    (assert-not (str? [])))
  (testing "works properly with empty table"
    (assert-not (str? {})))
  (testing "works properly with function"
    (assert-not (str? (fn [x] x))))
  (testing "works properly with hash-function"
    (assert-not (str? #$))))

(deftest fn/num?
  (testing "works properly with nil"
    (assert-not (num? nil)))
  (testing "works properly with number"
    (assert-is (num? 1234)))
  (testing "works properly with string"
    (assert-not (num? "Hello World")))
  (testing "works properly with empty list"
    (assert-not (num? [])))
  (testing "works properly with empty table"
    (assert-not (num? {})))
  (testing "works properly with function"
    (assert-not (num? (fn [x] x))))
  (testing "works properly with hash-function"
    (assert-not (num? #$))))

(deftest fn/fn?
  (testing "works properly with nil"
    (assert-not (fn? nil)))
  (testing "works properly with number"
    (assert-not (fn? 1234)))
  (testing "works properly with string"
    (assert-not (fn? "Hello World")))
  (testing "works properly with empty list"
    (assert-not (fn? [])))
  (testing "works properly with empty table"
    (assert-not (fn? {})))
  (testing "works properly with function"
    (assert-is (fn? (fn [x] x))))
  (testing "works properly with hash-function"
    (assert-is (fn? #$))))

(deftest fn/tbl?
  (testing "works properly with nil"
    (assert-not (tbl? nil)))
  (testing "works properly with number"
    (assert-not (tbl? 1234)))
  (testing "works properly with string"
    (assert-not (tbl? "Hello World")))
  (testing "works properly with empty list"
    (assert-is (tbl? [])))
  (testing "works properly with empty table"
    (assert-is (tbl? {})))
  (testing "works properly with function"
    (assert-not (tbl? (fn [x] x))))
  (testing "works properly with hash-function"
    (assert-not (tbl? #$))))

(deftest fn/->str
  (testing "works properly with nil"
    (assert-eq (->str nil) "nil"))
  (testing "works properly with number"
    (assert-eq (->str 1234) "1234"))
  (testing "works properly with string"
    (assert-eq (->str "Hello World") "Hello World")))
