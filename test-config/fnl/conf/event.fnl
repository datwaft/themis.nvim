(import-macros {: autocmd!
                : augroup!
                : clear!} :themis.event)

(augroup! salute
  (clear!)
  (autocmd! VimEnter * '(print "Hello World")))
