"Les deux premières lignes activent la coloration syntaxique. La troisième
"active l'indentation et les plugins relatifs au language (par exemple la
"complétion des fonctions php quand vous éditez un fichier php).
syn on
set syntax =on
filetype indent plugin on

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set background=dark

" Necessary  for lots of cool vim things
set nocompatible

" Convince Vim it can use 256 colors inside Gnome Terminal.
" Needs CSApprox plugin
" set t_Co=256

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
set tabstop =4
set shiftwidth=4
set softtabstop=4

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

" Command-T remappings
noremap <leader>e <Esc>:CommandT<CR>
noremap <leader>E <Esc>:CommandTFlush<CR>
let g:CommandTMatchWindowReverse = 1

" EnhCommentify options
let g:EnhCommentifyRespectIndent = 'Yes'
let g:EnhCommentifyPretty = 'Yes'

function EnhCommentifyCallback(ft)
    if a:ft == 'asm' || a:ft == 'gas'
        let b:ECcommentOpen = '#'
        let b:ECcommentClose = ''
    endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

" Clang++ options
let g:clang_complete_auto = 0
"       if equal to 1, automatically complete after ->, ., ::
"       Default: 1

let g:clang_complete_copen = 1
"       if equal to 1, open quickfix window on error.
"       Default: 0

let g:clang_hl_errors = 1
"       if equal to 1, it will highlight the warnings and errors the
"       same way clang does it.
"       Default: 1

let g:clang_periodic_quickfix = 1
"       if equal to 1, it will periodically update the quickfix window
"       Note: You could use the g:ClangUpdateQuickFix() to do the same
"             with a mapping.
"       Default: 0
map <F9> :call g:ClangUpdateQuickFix() <CR>
map <S-F9> :let g:clang_periodic_quickfix = 1 - g:clang_periodic_quickfix <bar> echo "Periodic :" g:clang_periodic_quickfix <CR>

 " let g:clang_snippets = 0
"       if equal to 1, it will do some snippets magic after a ( or a ,
"       inside function call. Not currently fully working.
"       Default: 0

"   - g:clang_conceal_snippets:
"        if equal to 1, vim will use vim 7.3 conceal feature to hide <#
"        and #> which delimit a snippets.
"        Note: See concealcursor and conceallevel for conceal configuration.
"        Default: 1 (0 if conceal not available)

"   - g:clang_exec:
"        Name or path of clang executable.
"        Note: Use this if clang has a non-standard name, or isn't in the
"        path.
"        Default: 'clang'

"   - g:clang_user_options:
"        Option added at the end of clang command. Useful if you want to
"        filter the result, or if you want to ignore the error code
"        returned by clang: on error, the completion is not shown.
"        Default: ''
"        Example: '|| exit 0' (it will discard clang return value)

" let g:clang_use_library = 1
"    Instead of calling the clang/clang++ tool use libclang directly. This
"    gives access to many more clang features. Furthermore it automatically
"    caches all includes in memory. Updates after changes in the same file
"    will therefore be a lot faster.
"      Default : 0

"    - g:clang_library_path:
"    If libclang.[dll/so/dylib] is not in your library search path, set
"    this to the absolute path where libclang is available.
"    Default : ''

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"SuperTab Completion
let g:SuperTabDefaultCompletionType = "context"

au BufRead,BufNewFile *.txt		set fo=tcoq
au BufRead,BufNewFile *.tex		set fo=tcoq
au BufRead,BufNewFile *.tex		set spell
au BufRead,BufNewFile *.plt		set ft=gnuplot
au BufRead,BufNewFile *.owl		set ft=xml
au BufRead,BufNewFile *.xul		set ft=xml
au BufRead,BufNewFile *.hrf		set ft=prolog
au BufRead,BufNewFile *.flr		set ft=prolog " for flora2 (cs227)
au BufRead,BufNewFile *.rdf		setfiletype xml

let g:tagbar_usearrows = 1
let g:tagbar_left = 1
nnoremap <leader>l :TagbarToggle<CR>

" This will look in the current directory for "tags", and work up the tree towards root until one is found.
set tags=tags;/
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
