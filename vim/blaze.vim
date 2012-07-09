" Copyright 2011 Google Inc.
" Author: Scott Williams <williasr@google.com>
" Blaze bindings for VIM.
" See http://wiki/Main/BlazeVim
"
" Suggested usage: Add the following to your .vimrc:
" source /home/williasr/.vim.d/blaze.vim
" nmap ,m LoadBlazeErrors()  " Load errors from blaze
" nmap ,b BlazeDwim()  " Run blaze on the current file
" nmap ,d UpdateDepsDwim()  " Run update deps on the current file
"
" Known issues:
" - Assumes you don't :chdir from inside VIM.

" Read blaze errors into vim. You can run blaze from the command line or from
" inside vim, and this function will still work. Type :help :cn for instructions
" on using quickfix mode. This function is probably useful in its own right.
function! LoadBlazeErrors()
  silent cex system('sed -n "s/[^[:print:]][[0-9;]*m//g;/^[[:graph:]]\+:[[:digit:]]/{s@^\./@@;s@.*@$(up goog)/&@;p}" $(readlink $(up goog)/blaze-google3)/../action_outs/*')
endf

" Utility function to be used from the Blaze commands below. Only loads blaze
" errors if the last shell command failed. Probably not useful except to
" functions defined here already.
function! MaybeLoadBlazeErrors()
  if v:shell_error
    call LoadBlazeErrors()
  endif
endf

" Blaze query takes a long time, so once we have found a blaze rule for the
" current file, we stash it in the "blaze_rule" buffer variable. This variable
" is scoped to the current file.
" KNOWN ISSUES: Blaze query can't usually figure out which rule a header file
" belongs to. If you like running the blaze commands from header files, you can
" set this variable yourself like this:
"    :let b:blaze_rule="//some/blaze:path"
if exists("b:blaze_rule")
  unlet b:blaze_rule
endif

" Guess the package for a file based on the filename.
" KNOWN ISSUES: LazyGetCurrentRule() isn't smart enough to look for the closest
" BUILD file to determine the actual package. That means if you attempt to get
" the blaze rule for a file that is in a subdirectory of the directory with the
" BUILD file, it will fail.
function! BlazeGuessPackage()
  let package=expand("%:.:h")
  if package == "."
    return ""
  endif
  return package
endf

" Run from the blaze commands to set the b:blaze_rule buffer variable.
function! LazyGetCurrentRule()
  if !exists("b:blaze_rule")
    let package=BlazeGuessPackage()
    let target=package . ":*"
    let file=package . ":" . expand("%:t")
    let query="\"attr('srcs', " . file . ", " . target . ")\""
    echo "Querying blaze for " . query
    let output=system("blaze query " . query . " 2> /dev/null")
    if v:shell_error
      echo "SHELL ERROR"
    else
      let b:blaze_rule=output
    endif
  endif
  return b:blaze_rule
endf

" Run blaze build on the current file.
function! BlazeBuildCurrentFile()
  call LazyGetCurrentRule()
  exe "!blaze build " . b:blaze_rule
  call LoadBlazeErrors()
endf

" Run blaze test on the current file.
function! BlazeTestCurrentFile()
  call LazyGetCurrentRule()
  exe "!blaze test " . b:blaze_rule
  call LoadBlazeErrors()
endf

" In a BUILD file, run blaze build on the target under the cursor.
function! BlazeBuildFileUnderCursor()
  let package=BlazeGuessPackage()
  exe "!blaze build " . package . ":" . expand("<cword>")
endf

" The main entrypoint into the blaze commands: a context-aware command that just
" does what you want it to do.
" - In a BUILD file, build the target under the cursor.
" - In any other file, look up the build target and then:
"   - if the target ends in _test, run blaze test on the target
"   - otherwise run blaze build on the target.
" - If there were errors, load the errors into VIM's quickfix mode.
"
" Examples:
" - Visit gws/output/pages/search_form.cc.
" - Press ,b
" Blaze builds gws/output/pages:search_form. If there are errors, it loads the
" errors and takes you to the line number of the first one.
function! BlazeDwim()
  if @% =~ "BUILD$"
    call BlazeBuildFileUnderCursor()
  elseif expand("%:t:r") =~ "[tT]est$"
    exe "!blaze test " . LazyGetCurrentRule()
  else
    exe "!blaze build " . LazyGetCurrentRule()
  endif
  call MaybeLoadBlazeErrors()
endf

" In a build file, update the deps for this rule (put your cursor on the name)
let g:update_deps = "gws/tools/update_deps"
function! UpdateDepsUnderCursor()
  let package=BlazeGuessPackage()
  exe "!" . g:update_deps . " -w " . package . ":" . expand("<cword>")
endf

" Main entry point for UpdateDeps integration. Context-aware, usually does the
" intelligent thing:
" - in a BUILD file, runs update_deps on the target under your cursor. (put your
"   cursor over the name of the rule).
" - In any other file, look up the build rule containing the source file and run
"   update_deps on that.
"
" Example:
" - Visit gws/output/pages/search_form.cc
" - Press ,d
" UpdateDepsDwim runs update_deps -w gws/output/pages:search_form
"
" Known Issues:
" - You have to edit the BUILD file first.
function! UpdateDepsDwim()
  if @% =~ "BUILD$"
    call UpdateDepsUnderCursor()
  else
    exe "!" . g:update_deps . " -w " . LazyGetCurrentRule()
  endif
endf
