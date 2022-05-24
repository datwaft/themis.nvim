(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: let!} :themis.var)

(deftest macro/let!
  (testing "works properly with no scope"
    (assert-eq (expr->str (let! hello :world))
               (expr->str (tset vim.g :hello :world))))
  (testing "works properly with buffer scope"
    (assert-eq (expr->str (let! [b] hello :world))
               (expr->str (tset vim.b :hello :world))))
  (testing "works properly with window scope"
    (assert-eq (expr->str (let! [w] hello :world))
               (expr->str (tset vim.w :hello :world))))
  (testing "works properly with tab scope"
    (assert-eq (expr->str (let! [t] hello :world))
               (expr->str (tset vim.t :hello :world))))
  (testing "works properly with global scope"
    (assert-eq (expr->str (let! [g] hello :world))
               (expr->str (tset vim.g :hello :world))))
  (testing "works properly with string as scope"
    (assert-eq (expr->str (let! [:g] hello :world))
               (expr->str (tset vim.g :hello :world))))
  (testing "works properly with string as name"
    (assert-eq (expr->str (let! [g] :hello :world))
               (expr->str (tset vim.g :hello :world)))))
