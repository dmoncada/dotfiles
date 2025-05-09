# GNU make manual.
# https://www.gnu.org/software/make/manual/make.html

.PHONY: all macos install source

all: macos install source

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
	@source ~/.bashrc

