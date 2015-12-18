set nocompatible

" Vundle magic.
filetype off  " It is set back to 'indent plugin on' at the end.
set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin()
Plugin 'Cpp11-Syntax-Support'
Plugin 'Tabular'
Plugin 'The-NERD-Commenter'
Plugin 'VundleVim/Vundle.vim'  " Required
Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlp.vim'
Plugin 'elzr/vim-json'
Plugin 'ervandew/supertab'
Plugin 'fugitive.vim'
Plugin 'mileszs/ack.vim'
Plugin 'mxw/vim-jsx'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'snipMate'
call vundle#end()

filetype indent plugin on
syntax on

set ttyfast

" Set persistent undo (v7.3 only)
if version >= 703
    set undodir=~/.vim/undodir
    set undofile
endif

" Code Folding, everything folded by default
set foldmethod=syntax
set foldlevel=99
set foldenable

set showcmd

let mapleader = ","

set wildmenu
set wildmode=longest,list,full
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.class,*.pyc

if version >= 700
   set spl=en spell
   set nospell
endif

set mouse=a

" Disable click (leaves only scrolling)
map <LeftMouse>  <Nop>
imap <LeftMouse> <Nop>

set backspace=indent,eol,start

set number

set ignorecase
set smartcase

set incsearch  " Jump to the first search match as you type.
set hlsearch   " Highlight the search results.
" set nowrapscan  " Do not jump to the beginning of the file when at the end.

set nohidden

set textwidth=80


" automatically open and close the popup menu / preview window
set completeopt=longest,menuone,menu,preview

" Remove trailing whitespace.
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

autocmd FileType python set foldmethod=indent
autocmd FileType conf set foldmethod=indent

"SuperTab Completion
" let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabDefaultCompletionType = "<c-x><c-u>"

set fo=croq

au BufRead,BufNewFile *.go set shiftwidth=2
au BufRead,BufNewFile *.go set softtabstop=0
au BufRead,BufNewFile *.go set tabstop=2
au BufRead,BufNewFile *.go set textwidth=100
au BufRead,BufNewFile *.hrf set ft=prolog
au BufRead,BufNewFile *.owl set ft=xml
au BufRead,BufNewFile *.plot set ft=gnuplot
au BufRead,BufNewFile *.plt set ft=gnuplot
au BufRead,BufNewFile *.proto set foldmethod=indent
au BufRead,BufNewFile *.rdf setfiletype xml
au BufRead,BufNewFile *.tex set fo=tcoq
au BufRead,BufNewFile *.tex set spell
au BufRead,BufNewFile *.txt set fo=tcoq
au BufRead,BufNewFile *.xul set ft=xml
au BufRead,BufNewFile *.md set ft=markdown

let g:ctrlp_map = '<leader>e' "Changes the mapping
" let g:ctrlp_working_path_mode = '2'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_dotfiles = 0
" let g:ctrlp_follow_symlinks = 1
" let g:ctrlp_use_caching = 1
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_custom_ignore = '\(venv\|node_modules\)/.*'

" Convince Vim it can use 256 colors inside Gnome Terminal.
set t_Co=256

set background=dark
if has("gui_running")
  colorscheme solarized
else
  colorscheme lucius256
  " hi Normal guifg=#d7d7d7 guibg=#212121 ctermfg=darkcyan ctermbg=black gui=none cterm=none
endif


" Display a dark grey line on the right margin
set colorcolumn=+1
hi ColorColumn ctermbg=238

" Functions to switch between header and implementation, across public /
" internal directories.
function! OtherExt(ext)
  if a:ext == 'h'
    return 'cc'
  elseif a:ext == 'cc'
    return 'h'
  endif
  return '-1'
endfunction

function! OtherDir(dir_name)
  if a:dir_name == 'public'
    return 'internal'
  elseif a:dir_name == 'internal'
    return 'public'
  endif
  return '-1'
endfunction

" Returns the header file if the current file is the implementation, and
" vice-versa.
fu! HeaderCcOtherFile()
  " The extension, e.g. 'cc'.
  let ext = expand('%:e')
  " The filename, without extension, e.g. 'foo_test'
  let root = expand('%:t:r')
  " The path of the current file, e.g. '.'.
  let path = expand('%:h')
  " The directory name, e.g. 'public'.
  let dir_name = expand('%:p:h:t')

  let other_ext = OtherExt(ext)
  if other_ext == '-1'
    return '-1'
  endif

  let same_dir_file = simplify(path . '/' . root . '.' . other_ext)

  " If there exists a file in the same directory, then we use it.
  if filereadable(same_dir_file)
    return same_dir_file
  endif

  " If this is an internal header, the .cc file should be in the same directory.
  if ext == 'h' && dir_name == 'internal'
    return same_dir_file
  endif

  let other_dir = OtherDir(dir_name)
  if other_dir == '-1'
    return simplify(same_dir_file)
  endif

  let other_path = path . '/../' . other_dir
  let other_dir_file = other_path . '/' . root . '.' . other_ext
  if filereadable(other_dir_file)
    return simplify(other_dir_file)
  endif

  return simplify(other_dir_file)
endfunction

fu! ApplyCommandToHeaderCc(command)
  " Command is the command to apply to the file, e.g. ':e' or ':vs'.
  let other_file = HeaderCcOtherFile()
  if other_file == '-1'
    return ''
  endif

  return a:command . ' ' . other_file
endfunction

" Switch between header and source file.
nnoremap <F3> :execute ApplyCommandToHeaderCc(':e')<CR>
nnoremap <F4> :execute ApplyCommandToHeaderCc(':vs')<CR>

" Replace the Escape key with the combination 'jk'
inoremap jk <esc>
inoremap <esc> <nop>

nnoremap <leader>ve :split $MYVIMRC<cr>G
nnoremap <leader>vs :source $MYVIMRC<cr>
nnoremap H ^
nnoremap L $
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

vnoremap <leader>" <esc>a"<esc>`<i"<esc>lel
vnoremap <leader>' <esc>a'<esc>`<i'<esc>lel
inoremap :w<cr> <esc>:w<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <leader><space> :noh<cr>
nnoremap <space> :set<space>hls<cr>:let @/='\C\V\<'.escape(expand('<cword>'), '\').'\>'<cr>
vnoremap <space> "xy:set<space>hls<cr>:let<space>@/='\V<c-r>x'<cr>
vnoremap <leader>= :ClangFormat<cr>
nnoremap <leader>= Vi{:ClangFormat<cr>
nnoremap <leader>n I}  // <esc>f{xj
nnoremap <leader>! :redraw!<cr>
nnoremap <leader>) A<backspace>,<esc>jA<backspace>)<esc>
nnoremap <leader>sp vip!LC_ALL=C sort \| uniq<cr>
vnoremap <leader>sp !LC_ALL=C sort \| uniq<cr>
" Copies the #include line that includes the current file in the Yank buffer.
nnoremap <leader>i I<cr><esc>ki#include "<c-r>=substitute(substitute(expand("%:p"), ".*google3/", "", ""), "\.proto$", ".pb.h", "")<cr>"<esc>yyu
nnoremap <leader>w :s/"$//e<cr>j:s/^\s*"//e<cr>^v$hdk$p079li"<cr>"<esc>:noh<cr>
nnoremap <leader>o f,a<cr><esc>
nnoremap <leader>; ,
nnoremap <leader>up ebiunique_ptr<<esc>f*r>
nnoremap zC :set foldlevel=2<cr>
map <leader>c <plug>NERDCommenterTogglej
" nnoremap <leader>gd :YcmCompleter GoTo<CR>
nnoremap gd :YcmCompleter GoToImprecise<CR>
nnoremap <leader>ge :botright cwindow<cr>
nnoremap <leader>fd :BlazeDepsUpdate<cr>

let NERDCreateDefaultMappings=0
let NERDSpaceDelims=1
let NERDDefaultNesting=0

" Always keep 3 lines of context visible.
set scrolloff=3

set showmatch
" Disable matching parenthesis
let loaded_matchparen = 0

let google_options_file = expand("<sfile>:p:h") . "/.myConfig/vim_custom_google"
if filereadable(google_options_file)
  exec "source " . google_options_file
endif

" set listchars=tab:ll
set encoding=utf-8

augroup SetCMS
  autocmd FileType borg let &l:commentstring='//%s'
augroup END

" Jump to the last position when opening a file.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

command! -nargs=+ Vim execute 'silent vim <args>' | botright cwindow

nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

let @b='V$h%y$%pcwbrowsejk'

set guifont=Monospace\ 9
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" On Mac, alt-space inserts a weird space, disable this.
:map!  <Char-0xA0>  <Space>
