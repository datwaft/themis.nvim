# use with https://github.com/casey/just

fennel-binary := './fennel'
lua-binary := 'lua'
fennel-options := trim(replace(replace("
  --no-compiler-sandbox
  --add-fennel-path 'fnl/?.fnl'
  --add-fennel-path 'deps/?.fnl'
  --add-macro-path 'deps/?/init-macros.fnl'
", "\n", ' '), '   ', ' '))
runner := 'deps/fennel-test/runner'

# Display list of commands
@help:
  just --list

# Ensure dependencies are installed
@ensure:
  git submodule update --init

# Upgrade dependencies
@upgrade:
  git submodule update --remote

# Execute test suites
@test +files=`find tests/ -name '*.spec.fnl' | paste -sd ' '`: ensure
  {{fennel-binary}} --lua {{lua-binary}} {{fennel-options}} {{runner}} {{files}}
