"Les deux premières lignes activent la coloration syntaxique. La troisième
"active l'indentation et les plugins relatifs au language (par exemple la
"complétion des fonctions php quand vous éditez un fichier php).
syn on
set syntax =on
filetype indent plugin on

if !exists("s:pathogen_loaded")
  let s:pathogen_loaded = 1
  call pathogen#runtime_append_all_bundles()
  call pathogen#helptags()
endi

set background=dark

" Necessary  for lots of cool vim things
set nocompatible

" Convince Vim it can use 256 colors inside Gnome Terminal.
" Needs CSApprox plugin
set t_Co=256

set ttyfast

" Set persistent undo (v7.3 only)
if version >= 703
    set undodir=~/.vim/undodir
    set undofile
endif

"La première ligne réduit automatiquement les fonction et blocs.
"On utilise notre fonction (optionnel).
function! MyFoldFunction()
    let line =getline(v:foldstart)
    let sub =substitute(line,'/\*\|\*/\|^\s+', '', 'g')
    let lines =v:foldend - v:foldstart + 1
    return v:folddashes.sub.'...'.lines.' Lines...'.getline(v:foldend)
endfunction
set foldmethod =syntax
set foldtext =MyFoldFunction()

" Code Folding, everything folded by default
" set foldmethod=indent
set foldlevel=99
set foldenable

" This shows what you are typing as a command.  I love this!
set showcmd

"Remplace la touche Leader par la touche virgule ','
let mapleader = ","

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set tabstop =2
set shiftwidth=2
set softtabstop=2

" Cool tab completion stuff
set wildmenu
set wildmode=longest,list,full
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.class

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en spell
   set nospell
endif

" Enable mouse support in console
set mouse=a

" Disable click (leaves only scrolling)
map <LeftMouse>  <Nop>
imap <LeftMouse> <Nop>

set backspace=indent,eol,start

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" This is totally awesome - remap fj to escape in insert mode.  You'll never type fj anyway, so it's great!
inoremap fj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" When I close a tab, remove the buffer
set nohidden

"Met la largeur du texte à 80
set textwidth=80

" pour C : set fo=croq
" pour le texte : set fo=crtq
set fo=croq

" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=longest,menuone,menu,preview

" Automatically cd into the directory that the file is in
" autocmd VimEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

" EnhCommentify options
let g:EnhCommentifyRespectIndent = 'Yes'
let g:EnhCommentifyPretty = 'Yes'

function! EnhCommentifyCallback(ft)
    if a:ft == 'asm' || a:ft == 'gas'
        let b:ECcommentOpen = '#'
        let b:ECcommentClose = ''
    endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

" map <F9> :call g:ClangUpdateQuickFix() <CR>
" map <S-F9> :let g:clang_periodic_quickfix = 1 - g:clang_periodic_quickfix <bar> echo "Periodic :" g:clang_periodic_quickfix <CR>

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"SuperTab Completion
let g:SuperTabDefaultCompletionType = "context"

au BufRead,BufNewFile *.txt set fo=tcoq
au BufRead,BufNewFile *.tex set fo=tcoq
au BufRead,BufNewFile *.tex set spell
au BufRead,BufNewFile *.plt set ft=gnuplot
au BufRead,BufNewFile *.owl set ft=xml
au BufRead,BufNewFile *.xul set ft=xml
au BufRead,BufNewFile *.hrf set ft=prolog
au BufRead,BufNewFile *.flr set ft=prolog " for flora2 (cs227)
au BufRead,BufNewFile *.rdf setfiletype xml

let g:tagbar_usearrows = 1
let g:tagbar_left = 1
nnoremap <leader>l :TagbarToggle<CR>

" This will look in the current directory for "tags", and work up the tree towards root until one is found.
set tags=tags;/
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"makes Vim insert these preprocessor gates automatically, when a new header file is created:
" function! s:insert_gates()
  " let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  " execute "normal! i#ifndef " . gatename
  " execute "normal! o#define " . gatename . " "
  " execute "normal! Go#endif /* " . gatename . " */"
  " normal! kk
" endfunction
" autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" au BufRead,BufNewFile *.cpp set formatprg=uncrustify\ --frag\ -l\ CPP\ -q
" map <F7> myggVG!uncrustify -l cpp<CR>dd'y

" Ctrl P settings:
let g:ctrlp_map = '<leader>e' "Changes the mapping
let g:ctrlp_working_path_mode = 2
" 0 - don’t manage working directory.
" 1 - the parent directory of the current file.
" 2 - the nearest ancestor that contains one of these directories or files:
"     .git/ .hg/ .svn/ .bzr/ _darcs/

" Colors
colorscheme lucius256
" colorscheme desert256
" set background=dark
" let g:lucius_style = "dark"

" Display a dark grey line on the right margin
set colorcolumn=+1
hi ColorColumn ctermbg=238

" Switch between header and source file.
map <M-F4> :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>
map <F4> :vs %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

set hlsearch

" Replace the Escape key with the combination 'jk'
inoremap jk <esc>
inoremap <esc> <nop>

nnoremap <leader>ev :split $MYVIMRC<cr>G
nnoremap <leader>sv :source $MYVIMRC<cr>
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
nnoremap <leader>w <c-w>v<c-w>l

set relativenumber
" Always keep 3 lines of context visible.
set scrolloff=3
" Substitutions are line-global by default. Use :s/foo/bar/g to substitute the
" first occurrence only.
set gdefault
set showmatch
" Disable matching parenthesis
" let loaded_matchparen = 1

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

if filereadable("/home/kreitmann/.myConfig/vim_custom_google")
    source /home/kreitmann/.myConfig/vim_custom_google
endif


