SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

BUILD_DIR := build
SOURCE := src/code-platform-wrapper.sh
WRAPPERS := $(BUILD_DIR)/gh $(BUILD_DIR)/glab

.PHONY: all wrappers check-tools clean

all: wrappers

wrappers: check-tools $(WRAPPERS)

check-tools:
	command -v shc >/dev/null
	command -v "$(CC)" >/dev/null
	command -v strip >/dev/null

$(BUILD_DIR):
	mkdir -p "$@"

$(BUILD_DIR)/%: $(SOURCE) | $(BUILD_DIR)
	tmp="$(BUILD_DIR)/.$*.sh"; \
	trap 'rm -f "$$tmp" "$$tmp.x" "$$tmp.x.c"' EXIT; \
	cp "$<" "$$tmp"; \
	chmod 0700 "$$tmp"; \
	shc -f "$$tmp" -o "$@"; \
	strip --strip-all "$@"; \
	chmod 0755 "$@"

clean:
	rm -rf "$(BUILD_DIR)"
