" set nocompatible

" ================
" Vim plug config.
" ================

if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl --fail --location --silent --output ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'altercation/vim-colors-solarized' " Enables the solarized color theme.
Plug 'raimondi/delimitmate'             " Closes quotes, parens, brackets, etc.
Plug 'tpope/vim-commentary'             " Comments lines out.
Plug 'tpope/vim-surround'               " Inserts/changes/removes surr. chars.
Plug 'yggdroot/indentline'              " Shows indentation.
Plug 'prettier/vim-prettier'
Plug 'psf/black'
call plug#end()

" ===============
" General config.
" ===============

syntax enable
filetype plugin indent on
" try | colorscheme solarized | catch /.*/ | endtry

set nowrap                              " Do not wrap lines.
set encoding=utf-8                      " Fallback encoding.
" set fileencoding=utf-8                  " Fallback encoding, the above is used if this is empty.
set textwidth=120                       " Break lines after 120 characters.
set number                              " Always show the numbers column.
set showtabline=1                       " Show the tabs line if there are multiple tabs.
set signcolumn=no                       " Always hide the signs columns.
set backspace=indent,eol,start          " Make the backspace key work as it normally would.
set clipboard=unnamed                   " Allow Vim to access the system's clipboard.
set list listchars=tab:→\ ,space:·      " Show invisible characters (tabs and spaces.)
set wildmenu                            " Show a status line with <Tab> when browsing the help.
set conceallevel=0
set timeoutlen=250
set belloff=all
set mouse=a

set incsearch                           " Show search matches while typing.
set hlsearch                            " Highlight search matches.
set ignorecase                          " Ignore case when searching...
set smartcase                           " ...unless pattern contains uppercase.

set tabstop=4                           " Num. of spaces that make up a tab.
set softtabstop=4                       " Num. of spaces that make up a tab with <Tab> or <BS>.
set shiftwidth=4                        " Num. of spaces to indent with << or >>.
set expandtab                           " Insert spaces instead of tabs.
set autoindent                          " Copy indentation from above.
set smartindent

set splitbelow                          " Put new splits below the current one.
set splitright                          " Put new splits next to the current one.

set cursorline                          " Highlight the current line.
" set cursorcolumn                        " Highlight the current column.

let g:netrw_altv=1                      " Right splitting.
let g:netrw_banner=0                    " Suppress the banner.
let g:netrw_liststyle=3                 " Tree style listing.

" let g:is_bash=1
" let g:sh_no_error=1

if has("gui_running")
    set guifont=Cascadia_Code:h12:cANSI:qDEFAULT
    set guioptions-=T " Remove the toolbar.
endif

" =========================
" Platform-specific config.
" =========================

function! GetPlatform()
    if has("win64") || has("win32") || has("win16")
        return "windows"
    else " macOS, Linux.
        return tolower(substitute(system("uname"), "\n", "", ""))
endfunction

function! IsPlatform(platform)
    return GetPlatform() == a:platform
endfunction

function! IsWindows()
    return IsPlatform("windows")
endfunction
function! IsMacos()
    return IsPlatform("darwin")
endfunction
function! IsLinux()
    return IsPlatform("linux")
endfunction

function! SetBackgroundWindows()
    silent let isLight = system("Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize | Select-Object -ExpandProperty AppsUseLightTheme")
    if l:isLight =~ "1"
        set background=light
    else
        set background=dark
    endif
endfunction

function! SetBackgroundMacos()
    silent let interfaceStyle = systemlist("defaults read -g AppleInterfaceStyle")
    if v:shell_error == 0 && l:interfaceStyle[0] ==? "dark"
        set background=dark
    else
        set background=light
    endif
endfunction

function! SetBackground()
    if IsWindows()
        call SetBackgroundWindows()
    elseif IsMacos()
        call SetBackgroundMacos()
    else " Linux.
        set background=dark
    endif

    highlight clear linenr
    highlight clear signcolumn
    highlight clear cursorlinenr
    highlight comment cterm=NONE gui=NONE
    highlight specialkey ctermbg=NONE guibg=NONE
    highlight extrawhitespace ctermbg=red guibg=red
endfunction

if IsWindows()
    set shell=\"C:\Program\ Files\PowerShell\7\pwsh.exe\" " PowerShell Core.
    set shellcmdflag=-NoLogo\ -NoProfile\ -Command
endif

" =====================
" File-specific config.
" =====================

augroup onstartup
    autocmd!
    autocmd vimenter * silent call SetBackground()
    autocmd vimenter * silent call MapCtrlForwardSlash()
    autocmd vimenter * match extrawhitespace /\s\+$/
    autocmd vimenter * if expand("%") == "" | e . | endif
augroup END

augroup filespecific
    autocmd!
    autocmd filetype javascript,typescript,css,less,scss,json,graphql,markdown,vue,svelte,yaml,html,sh
        \ setlocal tabstop=2 |
        \ setlocal softtabstop=2 |
        \ setlocal shiftwidth=2
    autocmd filetype make
        \ setlocal tabstop=8 |
        \ setlocal softtabstop=8 |
        \ setlocal shiftwidth=8 |
        \ setlocal noexpandtab
    " autocmd filetype dockerfile ?
augroup END

augroup black_onsave
    autocmd!
    autocmd BufWritePre *.py Black
augroup END

" ===================
" Status line config.
" ===================

function! Wrap(text)
    return '[' . a:text . ']'
endfunction
function! GetModified()
    return &modified ? '*' : ''
endfunction
function! GetTabSize()
    return 'Spaces:' . &tabstop
endfunction
function! GetEncoding()
    return toupper(&fileencoding ? &fileencoding : &encoding)
endfunction
function! GetFormat()
    return get({ 'unix': 'LF', 'dos':  'CRLF', }, &fileformat, 'UNKNOWN')
endfunction
function! GetType()
    return toupper(&filetype)
endfunction

set laststatus=2                           " Always show the status line.
set statusline=
set statusline+=%<                         " Truncate long lines.
set statusline+=\ 
set statusline+=[%t]                       " File name (tail only).
set statusline+=%h                         " Help file flag.
set statusline+=%r                         " Readonly flag.
set statusline+=\ 
set statusline+=%{GetModified()}           " Modified flag (* if modified).
set statusline+=%=                         " Align right.
set statusline+=%l:%c                      " Line and column numbers.
set statusline+=\ \ 
set statusline+=%{Wrap(GetTabSize())}      " Tab size.
set statusline+=\ \ 
set statusline+=%{Wrap(GetEncoding())}     " File encoding (e.g. UTF-8).
set statusline+=\ \ 
set statusline+=%{Wrap(GetFormat())}       " Line ending (e.g. LF/CRLF).
" set statusline+=\ \ 
" set statusline+=%{Wrap(GetType())}         " Filetype (e.g. JavaScript).
set statusline+=\ 

" ============
" Key mappings
" ============

let mapleader=','

nnoremap q <nop>
nnoremap <space> <nop>
nnoremap <expr> gh ':help '.expand('<cword>').'<cr>'
nnoremap <silent> <leader>q :confirm quit<cr>
" nnoremap <silent> <leader>c :Commentary<cr>
" vnoremap <silent> <leader>c :Commentary<cr>
nnoremap <silent> <leader>; :edit.<cr>
" inoremap jk <esc>

" inoremap <nul> <nop>
" inoremap <c-@> <nop>
inoremap <nul> <c-n>
inoremap <c-@> <c-n>

nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : ""

nnoremap <silent> <c-h> <c-w><c-h>
nnoremap <silent> <c-j> <c-w><c-j>
nnoremap <silent> <c-k> <c-w><c-k>
nnoremap <silent> <c-l> <c-w><c-l>

tnoremap <silent> <c-j> <c-w><c-j>
tnoremap <silent> <c-k> <c-w><c-k>

function! MapCtrlForwardSlash()
    if exists(':Commentary') == 0
        return
    endif

    if IsWindows() && has('gui_running')
        call test_mswin_event('set_keycode_trans_strategy', {'strategy': 'experimental'})
    endif

    if IsWindows() || IsMacos()
        nnoremap <c-/> :Commentary<cr>
        vnoremap <c-/> :Commentary<cr>
    else " Linux.
        nnoremap <c-_> :Commentary<cr>
        vnoremap <c-_> :Commentary<cr>
    endif
endfunction

if IsWindows() && has('gui_running')
    " Re-map the ctrl + backspace combo directly.
    inoremap <c-backspace> <c-w>
elseif IsMacos()
    " Delete previous word with ctrl + backspace.
    " Needs: "Send Hex Codes: 0x17" mapped to ctrl + backspace in iTerm2.
    " See: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
    inoremap <c-w> <c-\><c-o>db
endif

" ===============
" Plugins config.
" ===============

" Set the default venv for black.
let g:black_use_virtualenv=1
let g:black_virtualenv='~/.black/bin'

" Do not conceal chars. in JSON files.
let g:indentLine_fileTypeExclude=['json']
let g:indentLine_bufNameExclude=['Dockerfile']

" Expand delimiters on space, newline.
let b:delimitMate_expand_space=1
let b:delimitMate_expand_cr=1

" Autoformat on save -only- if a config file is found.
let g:prettier#autoformat_config_present=1
let g:prettier#autoformat_config_files=[
    \ '.prettierrc',
    \ '.prettierrc.json',
    \ '.prettierrc.yml',
    \ '.prettierrc.yaml',
    \ '.prettierrc.json5',
    \ '.prettierrc.js',
    \ '.prettierrc.cjs',
    \ 'prettier.config.js',
    \ 'prettier.config.cjs',
    \ '.prettierrc.toml'
    \ ]

" Prefer config file settings.
let g:prettier#config#config_precedence='prefer-file'

