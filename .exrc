augroup local_readonly_options
  autocmd BufRead .fennel-test set filetype=fennel
augroup END
lua vim.diagnostic.disable()
