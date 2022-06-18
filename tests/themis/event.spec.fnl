(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: autocmd!
                : augroup!
                : clear!} :themis.event)

(deftest macro/autocmd!
  (testing "works properly with the example"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")
                                    {:once true :group "custom" :desc "This is a description"}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :once true
                                                        :group "custom"
                                                        :desc "This is a description"}))))
  (testing "works properly when event is a single symbol"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when pattern is a single symbol"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when event is a list of symbols"
    (assert-eq (expr->str (autocmd! [VimEnter VimExit] *.py '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd [:VimEnter :VimExit]
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when pattern is a list of symbols"
    (assert-eq (expr->str (autocmd! VimEnter [*.py *.fnl] '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern ["*.py" "*.fnl"]
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when pattern is <buffer>"
    (assert-eq (expr->str (autocmd! VimEnter <buffer> '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:buffer 0
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when the command is a string and desc is not included"
    (assert-eq (expr->str (autocmd! VimEnter *.py "echo \"Hello World\""))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :command "echo \"Hello World\""
                                                        :desc "echo \"Hello World\""}))))
  (testing "works properly when the command is a symbol and desc is not included"
    (assert-eq (expr->str (autocmd! VimEnter *.py symbol))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback symbol
                                                        :desc "symbol"}))))
  (testing "works properly when the command is a function and desc is not included"
    (assert-eq (expr->str (autocmd! VimEnter *.py (fn [] (print "Hello World"))))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "(fn {} (print \"Hello World\"))"}))))
  (testing "works properly when the command is a quoted expression and desc is not included"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"}))))
  (testing "works properly when desc is included"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")
                                    {:desc "This is the description"}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "This is the description"}))))
  (testing "works properly when boolean options are included"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")
                                    {:once true :nested true}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"
                                                        :once true
                                                        :nested true}))))
  (testing "works properly when a boolean option is falsy"
    (assert-eq (expr->str (autocmd! VimEnter *.py '(print "Hello World")
                                    {:once false}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:pattern "*.py"
                                                        :callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"
                                                        :once false}))))
  (testing "works properly when buffer is set"
    (assert-eq (expr->str (autocmd! VimEnter <buffer> '(print "Hello World")
                                    {:buffer 42}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"
                                                        :buffer 42}))))
  (testing "works properly when buffer is set using a symbol"
    (assert-eq (expr->str (autocmd! VimEnter <buffer> '(print "Hello World")
                                    {:buffer bufnr}))
               (expr->str (vim.api.nvim_create_autocmd :VimEnter
                                                       {:callback (fn [] (print "Hello World"))
                                                        :desc "'(print \"Hello World\")"
                                                        :buffer bufnr})))))

(deftest macro/augroup!
  (testing "works properly with the example"
    (assert-eq (expr->str (augroup! a-nice-group
                            (autocmd! Filetype *.py '(print "Hello World"))
                            (autocmd! Filetype *.sh '(print "Hello World"))))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-group" {:clear false})
                            (autocmd! Filetype *.py '(print "Hello World") {:group "a-nice-group"})
                            (autocmd! Filetype *.sh '(print "Hello World") {:group "a-nice-group"})))))
  (testing "works properly with an empty body"
    (assert-eq (expr->str (augroup! a-nice-group))
               (expr->str (vim.api.nvim_create_augroup "a-nice-group" {:clear false}))))
  (testing "works properly one statement in the body"
    (assert-eq (expr->str (augroup! a-nice-group
                            (autocmd! Filetype *.py '(print "Hello World"))))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-group" {:clear false})
                            (autocmd! Filetype *.py '(print "Hello World") {:group "a-nice-group"})))))
  (testing "works properly with a clear! statement"
    (assert-eq (expr->str (augroup! a-nice-group
                            (clear!)
                            (autocmd! Filetype *.py '(print "Hello World"))))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-group" {:clear false})
                            (clear! "a-nice-group")
                            (autocmd! Filetype *.py '(print "Hello World") {:group "a-nice-group"})))))
  (testing "works properly as a buffer only augroup"
    (assert-eq (expr->str (augroup! a-nice-buffer-only-group
                            (clear! {:buffer 0})
                            (autocmd! VimEnter <buffer> '(print "Hello World"))))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-buffer-only-group" {:clear false})
                            (clear! "a-nice-buffer-only-group" {:buffer 0})
                            (autocmd! VimEnter <buffer> '(print "Hello World") {:group "a-nice-buffer-only-group"})))))
  (testing "works properly with autocmds with description"
    (assert-eq (expr->str (augroup! a-nice-group
                            (autocmd! Filetype *.py '(print "Hello World") {:desc "This is a description"})
                            (autocmd! Filetype *.sh '(print "Hello World") {:desc "This is a description"})))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-group" {:clear false})
                            (autocmd! Filetype *.py '(print "Hello World") {:group "a-nice-group" :desc "This is a description"})
                            (autocmd! Filetype *.sh '(print "Hello World") {:group "a-nice-group" :desc "This is a description"})))))
  (testing "works properly as a buffer only augroup with symbol as buffer"
    (assert-eq (expr->str (augroup! a-nice-buffer-only-group
                            (clear! {:buffer bufnr})
                            (autocmd! VimEnter <buffer> '(print "Hello World")
                                      {:buffer bufnr})))
               (expr->str (do
                            (vim.api.nvim_create_augroup "a-nice-buffer-only-group" {:clear false})
                            (clear! "a-nice-buffer-only-group" {:buffer bufnr})
                            (autocmd! VimEnter <buffer> '(print "Hello World") {:group "a-nice-buffer-only-group" :buffer bufnr}))))))

(deftest macro/clear!
  (testing "works properly with example"
    (assert-eq (expr->str (clear! some-group))
               (expr->str (vim.api.nvim_clear_autocmds {:group "some-group"}))))
  (testing "works properly with options"
    (assert-eq (expr->str (clear! some-group {:buffer bufnr}))
               (expr->str (vim.api.nvim_clear_autocmds {:group "some-group" :buffer bufnr}))))
  (testing "works properly for the current buffer"
    (assert-eq (expr->str (clear! some-group {:buffer 0}))
               (expr->str (vim.api.nvim_clear_autocmds {:group "some-group" :buffer 0})))))
