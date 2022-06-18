(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: command! : local-command!} :themis.cmd)

(deftest macro/command!
  (testing "works properly with the example"
    (assert-eq (expr->str (command! Salute '(print "Hello World")
                                    {:bang true :desc "This is a description"}))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:bang true
                                                             :desc "This is a description"}))))
  (testing "works properly with command as string"
    (assert-eq (expr->str (command! Salute "echo \"Hello World\""))
               (expr->str (vim.api.nvim_create_user_command "Salute" "echo \"Hello World\""
                                                            {:desc "echo \"Hello World\""}))))
  (testing "works properly with command as symbol"
    (assert-eq (expr->str (command! Salute symbol))
               (expr->str (vim.api.nvim_create_user_command "Salute" symbol
                                                            {:desc "symbol"}))))
  (testing "works properly with command as function"
    (assert-eq (expr->str (command! Salute (fn [] (print "Hello World"))))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:desc "(fn {} (print \"Hello World\"))"}))))
  (testing "works properly with command as quoted expression"
    (assert-eq (expr->str (command! Salute '(print "Hello World")))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:desc "'(print \"Hello World\")"}))))
  (testing "works properly when desc is included"
    (assert-eq (expr->str (command! Salute '(print "Hello World")
                                    {:desc "prints Hello World"}))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:desc "prints Hello World"}))))
  (testing "works properly when some boolean option is truthy"
    (assert-eq (expr->str (command! Salute '(print "Hello World")
                                    {:bang true}))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:bang true
                                                             :desc "'(print \"Hello World\")"}))))
  (testing "works properly when some boolean option is falsy"
    (assert-eq (expr->str (command! Salute '(print "Hello World")
                                    {:bang false}))
               (expr->str (vim.api.nvim_create_user_command "Salute" (fn [] (print "Hello World"))
                                                            {:bang false
                                                             :desc "'(print \"Hello World\")"})))))

(deftest macro/local-command!
  (testing "works properly with the example"
    (assert-eq (expr->str (local-command! Salute '(print "Hello World")
                                          {:bang true :desc "This is a description"}))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:bang true
                                                                 :desc "This is a description"}))))
  (testing "works properly with command as string"
    (assert-eq (expr->str (local-command! Salute "echo \"Hello World\""))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" "echo \"Hello World\""
                                                                {:desc "echo \"Hello World\""}))))
  (testing "works properly with command as symbol"
    (assert-eq (expr->str (local-command! Salute symbol))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" symbol
                                                                {:desc "symbol"}))))
  (testing "works properly with command as function"
    (assert-eq (expr->str (local-command! Salute (fn [] (print "Hello World"))))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:desc "(fn {} (print \"Hello World\"))"}))))
  (testing "works properly with command as quoted expression"
    (assert-eq (expr->str (local-command! Salute '(print "Hello World")))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:desc "'(print \"Hello World\")"}))))
  (testing "works properly when desc is included"
    (assert-eq (expr->str (local-command! Salute '(print "Hello World")
                                    {:desc "prints Hello World"}))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:desc "prints Hello World"}))))
  (testing "works properly when some boolean option is truthy"
    (assert-eq (expr->str (local-command! Salute '(print "Hello World")
                                          {:bang true}))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:bang true
                                                                 :desc "'(print \"Hello World\")"}))))
  (testing "works properly when some boolean option is falsy"
    (assert-eq (expr->str (local-command! Salute '(print "Hello World")
                                          {:bang false}))
               (expr->str (vim.api.nvim_buf_create_user_command "Salute" (fn [] (print "Hello World"))
                                                                {:bang false
                                                                 :desc "'(print \"Hello World\")"})))))
