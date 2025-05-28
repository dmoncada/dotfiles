# GNU make manual.
# https://www.gnu.org/software/make/manual/make.html

.PHONY: all check macos install source

all: check macos install source

check:
	@shellcheck --color=always --shell=bash $(shell find . -name "*.sh")

macos:
	@bash brew.sh
	@bash macos.sh

install:
	@rsync \
	-avh \
	--exclude ".git" \
	--exclude ".gitignore" \
	--exclude "brew.sh" \
	--exclude "macos.sh" \
	--exclude "Makefile" \
	--exclude "README.md" \
	--exclude "*.DS_STORE" \
	--exclude "*.swp" \
	. ~/

source:
	@echo "Run: 'source ~/.bashrc' to reload environment."

