(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: map!
                : buf-map!} :themis.keybind)

(deftest macro/map!
  (testing "works properly with the example"
    (assert-eq (expr->str (map! [nv] "<leader>lr" vim.lsp.references
                                :silent :buffer 0
                                "This is a description"))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" vim.lsp.references
                                          {:silent true
                                           :buffer 0
                                           :desc "This is a description"}))))
  (testing "works properly only one mode"
    (assert-eq (expr->str (map! [n] "<leader>lr" vim.lsp.references))
               (expr->str (vim.keymap.set [:n] "<leader>lr" vim.lsp.references
                                          {:desc "vim.lsp.references"}))))
  (testing "works properly with multiple modes"
    (assert-eq (expr->str (map! [nv] "<leader>lr" vim.lsp.references))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" vim.lsp.references
                                          {:desc "vim.lsp.references"}))))
  (testing "works properly with rhs as string"
    (assert-eq (expr->str (map! [nv] "<leader>lr" "echo \"Hello World\""))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" "echo \"Hello World\""
                                          {:desc "echo \"Hello World\""}))))
  (testing "works properly with rhs as symbol"
    (assert-eq (expr->str (map! [nv] "<leader>lr" symbol))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" symbol
                                          {:desc "symbol"}))))
  (testing "works properly with rhs as function"
    (assert-eq (expr->str (map! [nv] "<leader>lr" (fn [] (print "Hello World"))))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:desc "(fn {} (print \"Hello World\"))"}))))
  (testing "works properly with rhs as quoted expression"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:desc "'(print \"Hello World\")"}))))
  (testing "works properly when desc is included"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")
                                :desc "prints Hello World"))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:desc "prints Hello World"}))))
  (testing "works properly when some boolean option is truthy"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")
                                :silent))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:silent true
                                           :desc "'(print \"Hello World\")"}))))
  (testing "works properly when some boolean option is falsy"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")
                                :nosilent))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:silent false
                                           :desc "'(print \"Hello World\")"}))))
  (testing "works properly when nowait boolean option is truthy"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")
                                :nowait))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:nowait true
                                           :desc "'(print \"Hello World\")"}))))
  (testing "works properly when nowait boolean option is falsy"
    (assert-eq (expr->str (map! [nv] "<leader>lr" '(print "Hello World")
                                :wait))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" (fn [] (print "Hello World"))
                                          {:nowait false
                                           :desc "'(print \"Hello World\")"})))))

(deftest macro/buf-map!
  (testing "works properly with the example"
    (assert-eq (expr->str (buf-map! [nv] "<leader>lr" vim.lsp.references
                                :silent
                                "This is a description"))
               (expr->str (vim.keymap.set [:n :v] "<leader>lr" vim.lsp.references
                                          {:silent true
                                           :buffer 0
                                           :desc "This is a description"})))))
