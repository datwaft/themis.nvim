# use with https://github.com/casey/just

# Path to hererocks binary
hererocks-bin := 'hererocks'

# Where to save hererocks environment
env-path := 'deps/env'

# Path to fennel binary (by default uses dependency)
fennel-bin := 'deps/fennel-1.3.0'

# Path to lua binary (by default uses hererocks environment)
lua-bin := env-path / 'bin/lua'

# Path to hererocks binary (used to install dependencies for the hererocks environment)
luarocks-bin := env-path / 'bin/luarocks'

# Options to pass to the fennel binary
fennel-opts := replace("""
  --no-compiler-sandbox
  --add-fennel-path 'fnl/?.fnl'
  --add-macro-path 'fnl/?.fnl'
  --add-fennel-path 'deps/?.fnl'
  --add-macro-path 'deps/?/init-macros.fnl'
""", "\n", " ")

# Options to pass when installing readline
readline-opts := if `command -v brew > /dev/null && brew list readline 2> /dev/null || echo ''` != '' {
  replace("""
    HISTORY_DIR=$(brew --prefix readline)
    READLINE_DIR=$(brew --prefix readline)
  """, "\n", " ")
} else {
  ""
}

# Path to the fennel-test runner (by default uses dependency)
runner-bin := 'deps/fennel-test/runner'

# Add hererocks environment to $LUA_PATH and $LUA_CPATH
export LUA_PATH := absolute_path(env-path / "share/lua/5.1/?.lua") + ";" + env_var_or_default('LUA_PATH', '')
export LUA_CPATH := absolute_path(env-path / "lib/lua/5.1/?.so") + ";" + env_var_or_default('LUA_CPATH', '')

# Display list of commands
@help:
  just --list

# Ensure dependencies are installed
@ensure-deps:
  git submodule update --init

# Install hererocks environment
@install-env:
  [ -x "$(command -v {{hererocks-bin}})" ] || (echo "hererocks-bin ('{{hererocks-bin}}') doesn't exist" && false)
  [ ! -d "{{env-path}}" ] || (echo "env-path ('{{env-path}}') already exists" && false)
  {{hererocks-bin}} {{env-path}} -j2.1 -rlatest
  {{luarocks-bin}} install readline {{readline-opts}}

# Verify that the binaries exist
@verify-bins:
  [ -x "$(command -v {{fennel-bin}})" ] || (echo "fennel-bin ('{{fennel-bin}}') doesn't exist" && false)
  [ -x "$(command -v {{lua-bin}})" ] || (echo "lua-bin ('{{lua-bin}}') doesn't exist" && false)
  [ -x "$(command -v {{runner-bin}})" ] || (echo "runner-bin ('{{runner-bin}}') doesn't exist" && false)

# Upgrade dependencies
@upgrade:
  git submodule update --remote

# Execute test suites
@test +files=`find tests/ -name '*.spec.fnl' | paste -sd ' ' -`: verify-bins ensure-deps
  {{fennel-bin}} --lua {{lua-bin}} {{fennel-opts}} {{runner-bin}} {{files}}

# Compile file
@compile file: verify-bins ensure-deps
  {{fennel-bin}} --lua {{lua-bin}} {{fennel-opts}} -c {{file}}

# Execute file
@run file: verify-bins ensure-deps
  {{fennel-bin}} --lua {{lua-bin}} {{fennel-opts}} {{file}}

# Open REPL
@repl: verify-bins ensure-deps
  {{fennel-bin}} --lua {{lua-bin}} {{fennel-opts}}
alias shell := repl
