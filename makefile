SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .lua .fnl

# Where to find hererocks environment
ENV := ./deps/env

# Where to find binaries
FENNEL := ./deps/fennel-1.3.0
TEST_RUNNER := ./deps/fennel-test/runner
HEREROCKS := hererocks
LUA := $(ENV)/bin/lua
LUAROCKS := $(ENV)/bin/luarocks
READLINE := $(ENV)/share/lua/5.1/readline.lua

# Fennel flags
FFLAGS := --no-compiler-sandbox \
					--add-fennel-path 'fnl/?.fnl' \
					--add-macro-path 'fnl/?.fnl' \
					--add-fennel-path 'deps/?.fnl' \
					--add-macro-path 'deps/?/init-macros.fnl'

LUA_PATH := $(ENV)/share/lua/5.1/?.lua;$(LUA_PATH)
LUA_CPATH := $(ENV)/lib/lua/5.1/?.so;$(LUA_CPATH)

BREW_READLINE := $(shell brew --prefix readline 2> /dev/null)

READLINE_FLAGS := HISTORY_DIR=$(BREW_READLINE) \
									READLINE_DIR=$(BREW_READLINE)

all: help

$(TEST_RUNNER):
	git submodule update --init

$(ENV):
	$(HEREROCKS) $@ -j2.1 -rlatest
$(LUAROCKS): $(ENV)
$(LUA): $(ENV)

$(READLINE): $(LUAROCKS)
	$(LUAROCKS) install readline $(READLINE_FLAGS)

%.lua: %.fnl $(FENNEL) $(LUA)
	$(LUA) $(FENNEL) $(FFLAGS) -c $< > $@

# =============
# PHONY TARGETS
# =============

.PHONY: test repl help

TEST_DIR := ./tests
TEST_FILES := $(wildcard $(TEST_DIR)/**/*.spec.fnl)
test: $(FENNEL) $(LUA) $(TEST_RUNNER)
	$(LUA) $(FENNEL) $(FFLAGS) $(TEST_RUNNER) $(TEST_FILES)

repl: $(FENNEL) $(LUA) $(READLINE)
	$(LUA) $(FENNEL) $(FFLAGS)

## ===========
## HELP TARGET
## ===========

ESC := \x1b
RESET := $(ESC)[0m
ITALIC := $(ESC)[3m
BLUE := $(ESC)[34m
help:
	@echo 'Available targets:'
	@printf "	test $(BLUE)# Uses $(ITALIC)$(TEST_RUNNER)$(RESET)$(BLUE) to execute tests.$(RESET)\n"
	@printf "	repl $(BLUE)# Opens fennel REPL.$(RESET)\n"
