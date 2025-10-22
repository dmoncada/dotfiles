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
	@bash stow.sh

source:
	@echo "Run: 'source ~/.bashrc' to reload environment."

