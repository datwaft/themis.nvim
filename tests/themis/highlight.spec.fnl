(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: highlight!} :themis.highlight)

(deftest macro/highlight!
  (testing "works properly with the example"
    (assert-eq (expr->str (highlight! Error [:bold] {:fg "#ff0000"}))
               (expr->str (vim.api.nvim_set_hl 0 "Error" {:fg "#ff0000"
                                                          :bold true}))))
  (testing "works properly with a link"
    (assert-eq (expr->str (highlight! Error [] {:link "Warn"}))
               (expr->str (vim.api.nvim_set_hl 0 "Error" {:link "Warn"})))))
