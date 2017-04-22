set nocompatible

" Vundle magic.
filetype off  " It is set back to 'indent plugin on' at the end.
set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'  " Required

Plugin 'Cpp11-Syntax-Support'
Plugin 'Tabular'
Plugin 'The-NERD-Commenter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlp.vim'
Plugin 'elzr/vim-json'
Plugin 'fugitive.vim'
Plugin 'mileszs/ack.vim'
Plugin 'mxw/vim-jsx'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'snipMate'
Plugin 'valloric/YouCompleteMe'

call vundle#end()

filetype indent plugin on
syntax on

let g:ycm_rust_src_path = '/home/pierre/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:ycm_path_to_python_interpreter = '/usr/bin/python'

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

set mouse=n  " Only in normal mode.

if has("gui_running")
  set mouse=a  " Normal, visual, insert, and command-line mode.
  set lines=70 columns=100
endif

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
" let g:SuperTabDefaultCompletionType = "<c-x><c-u>"

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
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ --ignore .git5_specs
      \ --ignore review
      \ -g ""'

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

" Access and sourcing .vimrc.
nnoremap <leader>ve :split $MYVIMRC<cr>G
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

" The Mighty Space Macro.
nnoremap <space> :set<space>hls<cr>:let @/='\C\V\<'.escape(expand('<cword>'), '\').'\>'<cr>
vnoremap <space> "xy:set<space>hls<cr>:let<space>@/='\V<c-r>x'<cr>
nnoremap <leader><space> :noh<cr>

" Code formating.
vnoremap <leader>= :ClanggFormat<cr>
nnoremap <leader>= Vi{:ClangFormat<cr>

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

" Extracts an expression, and make it a named variable, in C++.
vnoremap <leader>xe cRENAME_ME<esc>Oauto RENAME_ME = <esc>pa;<esc>j^

nnoremap <leader>sh :VimuxPromptCommand<cr>
nnoremap <leader>sl :VimuxRunLastCommand<cr>
nnoremap <leader>sz :VimuxZoomRunner<cr>

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
 autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

" Populates the args list with all the files listed in the quickfix list.
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction

set modeline

let g:VimuxOrientation = "h"
