(lambda verify-dependencies! [dependencies]
  "Uses the vim.notify API to print a warning for every dependecy that is no
  available and then executes an early return from the module."
  `(let [dependencies# ,dependencies
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
       (lua "return nil"))))

{: verify-dependencies!}
