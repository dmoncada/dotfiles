# Just Programmer's Manual:
# https://just.systems/man/en/

@default: check macos install source

check:
    @shellcheck --color=always --shell=bash `find . -name "*.sh"`

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
    --exclude "Justfile" \
    --exclude "README.md" \
    --exclude "*.DS_STORE" \
    --exclude "*.swp" \
    . ~/

source:
    @echo "Run: 'source ~/.bashrc' to reload environment."

