# GNU Make Manual, Tutorial:
# https://www.gnu.org/software/make/manual/make.html
# https://makefiletutorial.com

.PHONY: all check macos install source

all: check macos install source

check:
	@shellcheck $${FLAGS} --color=always --shell=bash $$(find . -name "*.sh")

macos:
	@bash brew.sh
	@bash macos.sh

install:
	@stow \
		--restow . \
		--target=$$HOME \
		--ignore='.*\.sh' \
		--ignore='.*\.swp' \
		--ignore='.*\.DS_STORE' \
		--ignore=Makefile \
		--verbose=2

source:
	@echo "Run: 'source ~/.bashrc' to reload environment."

