" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" カラースキーマ設定
colorscheme iceberg

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
" set mouse=a		" Enable mouse usage (all modes)
set mouse=			" Disable mouse usage
set wildmenu
set autoindent
set smartindent
set cursorline
set number
set backspace=start,eol,indent
set iminsert=0		" 挿入モードのデフォルト値 0:IME=OFF
set imsearch=-1		" 検索時のデフォルト値 -1:equal to iminsert
set formatoptions+=r	" 挿入モード時，Enter押下でコメントを自動挿入する
set formatoptions-=o	" 'o','O'でのコメントを自動挿入しない
set formatoptions-=t	" 自動折り返しをしないようにする
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,mac,dos " enable automatically detection for existing file
set fileformat=unix	" set default fileformat to unix line endings
set noundofile		" undoファイルを作成しない
set guioptions-=T	" ツールバーを削除
set nonumber
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b
set hlsearch
" tab sizes
set tabstop=4
set shiftwidth=4
set expandtab
" let locate backup files ("*.~) to TEMP directory
if has('unix') || has('mac')
	set backupdir=/tmp
else
	set shellpipe=2>\&1\|nkf\ -uw\|wtee	" wteeを利用してリダイレクトと標準出力を同時に行う
	set backupdir=$TEMP
endif

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup end

" Plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
let g:lightline = {
    \ 'active': {
        \ 'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ],
        \ }
    \ }
Plug 'sudar/vim-arduino-syntax'
Plug 'tokorom/vim-review'
Plug 'scrooloose/nerdtree'
let g:NERDTreeWinSize=26
let g:NERDTreeShowHidden=1
Plug 'cespare/vim-toml'
Plug 'itchyny/vim-haskell-indent'
Plug 'neovimhaskell/haskell-vim'
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

call plug#end()

" Settings for plugins

" Required for operations modifying multiple buffers like rename.
set hidden

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <F2> for rename current word
nmap <silent> <F2> <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Required:
filetype plugin indent on
