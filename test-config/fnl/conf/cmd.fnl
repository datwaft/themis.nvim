(local {: command!} :themis.cmd)

(command! Scratch "new | setlocal bt=nofile bh=wipe nobl noswapfile")
(command! SetScratch "edit [Scratch] | setlocal bt=nofile bh=wipe nobl noswapfile")
