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
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdcommenter'
Plug 'rust-lang/rust.vim'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'

if ! filereadable(google_options_file)
  Plug 'mattn/vim-lsp-settings'
endif

call plug#end()

let mapleader = ","

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

" Use the gui colors, not the terminal colors. neovim 0.1.5+ / vim 7.4.1799+
" Enable ONLY if TERM is set valid and it is NOT under mosh.
" From
" https://github.com/wookayin/dotfiles/blob/0d44f9c24328ccba5e21cf776b33bdef912fbdc6/vim/vimrc#L579-L609.
function! IsMosh()
  let output = system('is_mosh -v')
  if v:shell_error
    return 0
  endif
  return !empty(l:output)
endfunction

function! s:auto_termguicolors(...)
  if !(has('termguicolors'))
    return
  endif

  if (&term == 'xterm-256color' || &term == 'tmux-256-color' || &term == 'nvim') && !IsMosh()
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  else
    set notermguicolors
  endif
endfunction
if has('termguicolors')
  " by default, enable 24-bit color, but lazily disable if under mosh
  set termguicolors

  if exists('*timer_start')
    call timer_start(0, function('s:auto_termguicolors'))
  else
    call s:auto_termguicolors()
  endif
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

" Load errors in a window that spans all vertical panes.
nnoremap <leader>ge :botright cwindow<cr>

" Aligns the next line so that the first non-space character is under the
" current cursor. And moves to the next line.
nnoremap <leader>j iù<esc>j^0d^kvtùyj^Pv0r kfùxj


nnoremap <leader>sh :VimuxPromptCommand<cr>
nnoremap <leader>sl :VimuxRunLastCommand<cr>
nnoremap <leader>sz :VimuxZoomRunner<cr>

nnoremap <leader>e :FZF<cr>
nnoremap <leader>,e :History<cr>

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

" Send async completion requests.
" WARNING: Might interfere with other completion plugins.
let g:lsp_async_completion = 1

" Enable UI for diagnostics
let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_document_highlight_enabled = 0 " Do not highlight variable under cursor

" Automatically show completion options
let g:asyncomplete_auto_popup = 1

" Enable preview window. First allow modifying the completeopt variable, or it
" will be overridden all the time
" let g:asyncomplete_auto_completeopt = 0
" set completeopt=menuone,noinsert,noselect,preview

" Use tab for completion.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
inoremap <c-space> <Plug>(asyncomplete_force_refresh)

nnoremap <leader>h :LspHover<cr>
nnoremap <leader>re :LspRename<cr>
nnoremap <leader>fi :LspCodeAction<cr>
vnoremap <leader>= :LspDocumentRangeFormat<cr>
nnoremap <leader>= :LspDocumentFormat<cr>
nnoremap gd :LspDefinition<CR>
nnoremap gr :LspReferences<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEEP THIS AT THE END.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(google_options_file)
  exec "source " . google_options_file
endif
