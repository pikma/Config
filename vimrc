set nocompatible

filetype plugin indent on
syntax on

let current_dir = expand("<sfile>:p")
let config_dir = strpart(current_dir, 0, strridx(current_dir, "/.myConfig/")) . "/.myConfig"
let google_options_file = expand("~/.myConfig/vim_custom_google.vim")

" Automatic installation of vim-plug.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'mileszs/ack.vim'
Plug 'mxw/vim-jsx'
Plug 'nsf/gocode', {'rtp': 'vim/'}
Plug 'pangloss/vim-javascript'
Plug 'pikma/space-macro'
Plug 'rust-lang/rust.vim'
Plug 'preservim/nerdcommenter'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'

if filereadable(google_options_file)
  " For language server support.
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  " For blame.
  " Plug 'vim-scripts/vcscommand.vim'
else
  if has("python3")
    Plug 'valloric/YouCompleteMe'
  else
    autocmd VimEnter *  echo 'Vim compiled without python3, disabling YouCompleteMe.'
  endif
  Plug 'rhysd/vim-clang-format'
endif

call plug#end()


let g:ale_python_auto_pipenv = 1
let g:ale_fixers = {'python': ['yapf']}
let g:ale_linters = {'python': ['flake8', 'mypy']}
nmap <F7> <Plug>(ale_fix)

" Point YCM to the Pipenv created virtualenv, if possible
" At first, get the output of 'pipenv --venv' command.
let pipenv_venv_path = system('pipenv --venv')
" The above system() call produces a non zero exit code whenever
" a proper virtual environment has not been found.
" So, second, we only point YCM to the virtual environment when
" the call to 'pipenv --venv' was successful.
" Remember, that 'pipenv --venv' only points to the root directory
" of the virtual environment, so we have to append a full path to
" the python executable.
if v:shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let g:ycm_python_binary_path = venv_path . '/bin/python'
  let g:ale_python_yapf_executable = venv_path . '/bin/yapf'
else
  let g:ycm_python_binary_path = 'python'
endif

let g:ycm_rust_src_path = '/home/pierre/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
" let g:ycm_path_to_python_interpreter = '/usr/bin/python'  " TODO: remove
let g:ycm_min_num_of_chars_for_completion = 4

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

" Command line completion.
set wildmenu
set wildmode=longest,list,full
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.class,*.pyc

if version >= 700
   set spl=en spell
   set nospell
endif

set mouse=n  " Only in normal mode.

if has("gui_running")
  set mouse=a  " Normal, visual, insert, and command-line mode.
  set lines=70 columns=100
endif
set guifont=Monospace\ 9
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Disable click (leaves only scrolling)
map <LeftMouse>  <Nop>
imap <LeftMouse> <Nop>

set backspace=indent,eol,start

set number  " Show line numbers

set ignorecase
set smartcase
set incsearch  " Jump to the first search match as you type.
set hlsearch   " Highlight the search results.

set nohidden

" automatically open and close the popup menu / preview window
set completeopt=longest,menuone,menu,preview

" Remove trailing whitespace.
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

autocmd FileType python set foldmethod=indent
autocmd FileType conf set foldmethod=indent

set fo=croq

set textwidth=80

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

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=80
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set fileformat=unix


" Convince Vim it can use 256 colors inside Gnome Terminal.
set t_Co=256
set background=light

" Use the gui colors, not the terminal colors.
set termguicolors
if !has('nvim') && ($TERM ==# 'screen-256color' || $TERM ==# 'tmux-256color')
  " See :h xterm-true-color.
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

colorscheme tango-morning

set colorcolumn=+1  " Display a dark grey line on the right margin

" Replace the Escape key with the combination 'jk'
inoremap jk <esc>

inoremap \302\240 <space>
" Access and sourcing .vimrc.
nnoremap <leader>ve :e $MYVIMRC<cr>G
nnoremap <leader>vs :source $MYVIMRC<cr>
nnoremap H ^
nnoremap L $

" Wrap in quotes.
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>a"<esc>`<i"<esc>lel
vnoremap <leader>' <esc>a'<esc>`<i'<esc>lel

" Save file in insert mode.
inoremap :w<cr> <esc>:w<cr>

" Code formating.
if !filereadable(google_options_file)
  vnoremap <leader>fo :ClangFormat<cr>
  nnoremap <leader>fo Vip:ClangFormat<cr>
endif

" Misc code formatting.
nnoremap <leader>n I}  // <esc>f{xj
nnoremap <leader>) A<backspace>,<esc>jA<backspace>)<esc>

" Utils
nnoremap <leader>! :redraw!<cr>

" Sorting.
nnoremap <leader>sp vip!LC_ALL=C sort -u<cr>
vnoremap <leader>sp !LC_ALL=C sort -u<cr>

" Copies the #include line that includes the current file in the Yank buffer.
nnoremap <leader>i I<cr><esc>ki#include "<c-r>=substitute(substitute(expand("%:p"), ".*google3/", "", ""), "\.proto$", ".proto.h", "")<cr>"<esc>yyu

nnoremap <leader>; ,

nnoremap zC :set foldlevel=2<cr>
map <leader>c <plug>NERDCommenterTogglej

" nnoremap <leader>gd :YcmCompleter GoTo<CR>
nnoremap gd :YcmCompleter GoToImprecise<CR>

" Load errors in a window that spans all vertical panes.
nnoremap <leader>ge :botright cwindow<cr>

" Aligns the next line so that the first non-space character is under the
" current cursor. And moves to the next line.
nnoremap <leader>j iù<esc>j^0d^kvtùyj^Pv0r kfùxj


nnoremap <leader>sh :VimuxPromptCommand<cr>
nnoremap <leader>sl :VimuxRunLastCommand<cr>
nnoremap <leader>sz :VimuxZoomRunner<cr>

nnoremap <leader>e :FZF<cr>
nnoremap <leader>,h :History<cr>

let g:NERDCreateDefaultMappings=0
let g:NERDSpaceDelims=1
let g:NERDDefaultNesting=0
let g:NERDCustomDelimiters = {'textpb': {'left': '#'}, 'gcl': {'left': '//'}}
let g:NERDDefaultAlign='left'

" Always keep 3 lines of context visible.
set scrolloff=3

set showmatch

" set listchars=tab:ll
set encoding=utf-8

" Jump to the last position when opening a file.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" On Mac, alt-space inserts a weird space, disable this.
noremap  <Char-0xA0>  <Space>

" file is large from 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
 autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function! LargeFile()
 " no syntax highlighting etc
 set eventignore+=FileType
 " save memory when other file is viewed
 setlocal bufhidden=unload
 " is read-only (write with :w new_filename)
 setlocal buftype=nowrite
 " no undo possible
 setlocal undolevels=-1
 " display message
 autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details, search for 'LargeFile()')."
endfunction

let g:VimuxOrientation = "h"

if exists(':tnoremap')
  tnoremap JK <C-\><C-n>
endif

" Use ag instead of ack.
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Disables highlighting the matching parenthesis.
let g:loaded_matchparen=1

let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]
" Do not consider .md files outside of vimwiki_list to be vimwikis.
let g:vimwiki_global_ext = 0

nnoremap <leader>we :Files ~/vimwiki<cr>

" Disable capitalization checking in vimwiki.
autocmd FileType vimwiki set spellcapcheck=''

" To remember more than 100 (the default) files in v:oldfiles.
set viminfo='500,<50,s10,h

" Uses FZF to select a file in the same directory as the currently opened file.
function FzfSameDirectory()
  let dir_path = expand('%:p:h')
  let header = 'Directory: ' . expand('%:p:h:t')
        " \   'source': 'find ' . dir_path ,
  call fzf#run({
        \   'sink': 'e',
        \   'dir': dir_path,
        \   'options': '--header="'.header.'"'
        \ })
endfunction
nnoremap <leader>,d :call FzfSameDirectory()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEEP THIS AT THE END.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(google_options_file)
  exec "source " . google_options_file
endif
