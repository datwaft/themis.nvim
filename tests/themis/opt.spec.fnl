(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: set!
                : local-set!} :themis.opt)

(deftest macro/set!
  (testing "works properly with only a name"
    (assert-eq (expr->str (set! spell))
               (expr->str (tset vim.opt :spell true))))
  (testing "works properly with only a name that begins with no"
    (assert-eq (expr->str (set! nospell))
               (expr->str (tset vim.opt :spell false))))
  (testing "works properly with a truthy value"
    (assert-eq (expr->str (set! spell true))
               (expr->str (tset vim.opt :spell true))))
  (testing "works properly with a falsy value"
    (assert-eq (expr->str (set! spell false))
               (expr->str (tset vim.opt :spell false))))
  (testing "works properly with a truthy value and a name that begins with no"
    (assert-eq (expr->str (set! nospell true))
               (expr->str (tset vim.opt :nospell true))))
  (testing "works properly with a falsy value and a name that begins with no"
    (assert-eq (expr->str (set! nospell false))
               (expr->str (tset vim.opt :nospell false))))
  (testing "works properly with a string"
    (assert-eq (expr->str (set! spell "Hello World!"))
               (expr->str (tset vim.opt :spell "Hello World!"))))
  (testing "works properly with a symbol"
    (assert-eq (expr->str (set! spell symbol))
               (expr->str (tset vim.opt :spell symbol))))
  (testing "works properly with an expression"
    (assert-eq (expr->str (set! spell (.. "Hello" "!")))
               (expr->str (tset vim.opt :spell (.. "Hello" "!")))))
  (testing "works properly with a quoted expression"
    (assert-eq (expr->str (set! spell '(+ 1 2)))
               (expr->str (do
                            (tset _G "__b3e8c661" (fn {} (+ 1 2)))
                            (tset vim.opt :spell "v:lua.__b3e8c661()")))))
  (testing "works properly with a hash function"
    (assert-eq (expr->str (set! spell #(+ 1 2)))
               (expr->str (do
                            (tset _G "__8e8b61cd" #(+ 1 2))
                            (tset vim.opt :spell "v:lua.__8e8b61cd()")))))
  (testing "works properly with append"
    (assert-eq (expr->str (set! list+ "something"))
               (expr->str (: (. vim.opt "list") :append "something"))))
  (testing "works properly with remove"
    (assert-eq (expr->str (set! list- "something"))
               (expr->str (: (. vim.opt "list") :remove "something"))))
  (testing "works properly with prepend"
    (assert-eq (expr->str (set! list^ "something"))
               (expr->str (: (. vim.opt "list") :prepend "something"))))
  (testing "works properly with get"
    (assert-eq (expr->str (set! list?))
               (expr->str (: (. vim.opt "list") :get)))))

(deftest macro/local-set!
  (testing "works properly with only a name"
    (assert-eq (expr->str (local-set! spell))
               (expr->str (tset vim.opt_local :spell true))))
  (testing "works properly with only a name that begins with no"
    (assert-eq (expr->str (local-set! nospell))
               (expr->str (tset vim.opt_local :spell false))))
  (testing "works properly with a truthy value"
    (assert-eq (expr->str (local-set! spell true))
               (expr->str (tset vim.opt_local :spell true))))
  (testing "works properly with a falsy value"
    (assert-eq (expr->str (local-set! spell false))
               (expr->str (tset vim.opt_local :spell false))))
  (testing "works properly with a truthy value and a name that begins with no"
    (assert-eq (expr->str (local-set! nospell true))
               (expr->str (tset vim.opt_local :nospell true))))
  (testing "works properly with a falsy value and a name that begins with no"
    (assert-eq (expr->str (local-set! nospell false))
               (expr->str (tset vim.opt_local :nospell false))))
  (testing "works properly with a string"
    (assert-eq (expr->str (local-set! spell "Hello World!"))
               (expr->str (tset vim.opt_local :spell "Hello World!"))))
  (testing "works properly with a symbol"
    (assert-eq (expr->str (local-set! spell symbol))
               (expr->str (tset vim.opt_local :spell symbol))))
  (testing "works properly with an expression"
    (assert-eq (expr->str (local-set! spell (.. "Hello" "!")))
               (expr->str (tset vim.opt_local :spell (.. "Hello" "!")))))
  (testing "works properly with a quoted expression"
    (assert-eq (expr->str (local-set! spell '(+ 1 2)))
               (expr->str (do
                            (tset _G "__b3e8c661" (fn {} (+ 1 2)))
                            (tset vim.opt_local :spell "v:lua.__b3e8c661()")))))
  (testing "works properly with a hash function"
    (assert-eq (expr->str (local-set! spell #(+ 1 2)))
               (expr->str (do
                            (tset _G "__8e8b61cd" #(+ 1 2))
                            (tset vim.opt_local :spell "v:lua.__8e8b61cd()")))))
  (testing "works properly with append"
    (assert-eq (expr->str (local-set! list+ "something"))
               (expr->str (: (. vim.opt_local "list") :append "something"))))
  (testing "works properly with remove"
    (assert-eq (expr->str (local-set! list- "something"))
               (expr->str (: (. vim.opt_local "list") :remove "something"))))
  (testing "works properly with prepend"
    (assert-eq (expr->str (local-set! list^ "something"))
               (expr->str (: (. vim.opt_local "list") :prepend "something"))))
  (testing "works properly with get"
    (assert-eq (expr->str (local-set! list?))
               (expr->str (: (. vim.opt_local "list") :get)))))

