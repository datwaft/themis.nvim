(require-macros :fennel-test)
(import-macros {: expr->str} :themis.lib.compile-time)

(import-macros {: verify-dependencies!} :themis.module)

(deftest macro/verify-dependencies!
  (testing "works properly with the example"
    (local expected
      (expr->str (let [dependencies# [:fennel :hotpot]
                        info# (debug.getinfo 1 :S)
                        module-name# info#.source
                        module-name# (module-name#:match "@(.*)")
                        not-available# (icollect [_# dependency# (ipairs dependencies#)]
                                         (when (not (pcall require dependency#))
                                           dependency#))]
                    (when (> (length not-available#) 0)
                      (each [_# dependency# (ipairs not-available#)]
                        (vim.notify (string.format "Could not load '%s' as '%s' is not available." module-name# dependency#)
                                    vim.log.levels.WARN))
                      (lua "return nil")))))
    (local result
      (expr->str (verify-dependencies! [:fennel :hotpot])))
    (assert-eq result expected)))
