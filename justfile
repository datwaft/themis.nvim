# use with https://github.com/casey/just

deps-folder := 'deps'
fennel-binary := 'fennel'
lua-binary := 'lua'
fennel-options := trim(replace(replace("
  --no-compiler-sandbox
", "\n", ' '), '   ', ' '))
runner := join(deps-folder, 'fennel-test/runner')

# Display list of commands
@help:
  just --list

# Ensure fennel-test dependency is installed
@ensure-fennel-test:
  if [ ! -d '{{deps-folder}}/fennel-test' ]; then \
    git clone 'https://gitlab.com/andreyorst/fennel-test.git' \
      '{{deps-folder}}/fennel-test'; \
  fi

# Execute test suites
@test +files=`find tests/ -name '*.spec.fnl' | paste -sd ' '`: ensure-fennel-test
  {{fennel-binary}} --lua {{lua-binary}} {{fennel-options}} {{runner}} {{files}}

# Remove dependencies
@clean:
  rm -rf fennel-test
