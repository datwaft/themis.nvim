SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .lua .fnl

# External dependencies
HEREROCKS := $(shell command -v hererocks)

# Where to find hererocks environment
DEPS := deps
ENV := $(DEPS)/env

# Where to find binaries
FENNEL := $(DEPS)/fennel-1.3.0
TEST_RUNNER := $(DEPS)/fennel-test/runner
LUA := $(ENV)/bin/lua
LUAROCKS := $(ENV)/bin/luarocks
READLINE := $(ENV)/share/lua/5.1/readline.lua

# Fennel flags
FFLAGS := --no-compiler-sandbox \
					--add-fennel-path 'fnl/?.fnl' \
					--add-macro-path 'fnl/?.fnl' \
					--add-fennel-path '$(DEPS)/?.fnl' \
					--add-macro-path '$(DEPS)/?/init-macros.fnl'

export LUA_PATH := $(ENV)/share/lua/5.1/?.lua;$(LUA_PATH)
export LUA_CPATH := $(ENV)/lib/lua/5.1/?.so;$(LUA_CPATH)

all: help

$(TEST_RUNNER):
	git submodule update --init

$(ENV): $(HEREROCKS)
ifndef HEREROCKS
	$(error "hererocks is not available.")
endif
	$(HEREROCKS) $@ -j2.1 -rlatest
$(LUAROCKS): $(ENV)
$(LUA): $(ENV)

$(READLINE): BREW_READLINE := $(shell brew --prefix readline 2> /dev/null)
$(READLINE): ARGUMENTS := HISTORY_DIR=$(BREW_READLINE) READLINE_DIR=$(BREW_READLINE)
$(READLINE): $(LUAROCKS)
	$(LUAROCKS) install readline $(ARGUMENTS)

%.lua: %.fnl $(LUA) $(FENNEL)
	$(LUA) $(FENNEL) $(FFLAGS) -c $< > $@

# =============
# PHONY TARGETS
# =============

.PHONY: test repl help

test: TEST_DIR := tests
test: TEST_FILES := $(wildcard $(TEST_DIR)/**/*.spec.fnl)
test: $(LUA) $(FENNEL) $(TEST_RUNNER)
	$(LUA) $(FENNEL) $(FFLAGS) $(TEST_RUNNER) $(TEST_FILES)

repl: $(LUA) $(FENNEL) $(READLINE)
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
