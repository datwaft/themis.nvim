(import-macros {: set!} :themis.opt)

(set! nospell)
(set! foldtext '(vim.fn.printf "   %-6d%s"
                               (- vim.v.foldend (+ vim.v.foldstart 1))
                               (vim.fn.getline vim.v.foldstart)))
