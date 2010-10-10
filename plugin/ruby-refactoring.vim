" Ruby Refactoring in VIM
"
" Author: Enrique Comba Riepenhausen
" Email: enrique@edendevelopment.co.uk
" Email2: ecomba@gmail.com
"
" Acknowledgements:
" Thanks to Gary Bernhardt for the inspiration for this tool and the original
" ExtractVariable() and InlineTemp() functions.

" Support functions
"
function! s:get_input(message, error_message)
  let name = input(a:message)
  if name == ''
    throw a:error_message
  endif
  return name
endfunction

" Patterns

" Synopsis
"   Adds a parameter (or many separated with commas) to a method
function! AddParameter()
  try
    let name = s:get_input("Parameter name: ", "No parameter name given!")
  catch
    echo v:exception
    return
  endtry

  let closing_bracket_index = stridx(getline("."), ")")

  if closing_bracket_index == -1
    execute "normal A(" . name . ")\<Esc>"
  else
    exec ':.s/)/, ' . name . ')/'
  endif
endfunction

" Synopsis
"   Extracts the selected scope into a constant at the top of the current
"   module or class
function! ExtractConstant()
  try
    let name = toupper(s:get_input("Constant name: ", "No constant name given!"))
  catch
    echo v:exception
    return
  endtry

  " Save the scope to register a and then reselect the scope in visual mode
  normal! gv
  " Replace selected text with the constant's name
  exec "normal c" . name
  " Find the enclosing class or module
  exec "?\\<class\\|module\\>"
  " Define the constant inside the class or module
  exec "normal! o" . name . " = " 
  normal! $p
endfunction

" Synopsis
"   Extracts the selected scope to a variable
function! ExtractLocalVariable()
  try
    let name = s:get_input("Variable name: ", "No variable name given!")
  catch
    echo v:exception
    return
  endtry
  " Enter visual mode (not sure why this is needed since we're already in
  " visual mode anyway)
  normal! gv

  " Replace selected text with the variable name
  exec "normal c" . name
  " Define the variable on the line above
  exec "normal! O" . name . " = "
  " Paste the original selected text to be the variable value
  normal! $p
endfunction

" Synopsis
"   Rename the selected local variable 
function! RenameLocalVariable()
  try
    let name = s:get_input("Rename to: ", "No variable name given!" )
  catch
    echo v:exception
    return
  endtry

  " Backup @a 
  let old_register_a = @a

  normal! gv

  " Yank the variable name into it
  normal "ay

  " Mark current caret position
  " FIXME: This doesn't capure column properly, because we're in visual mode
  let cursor_position = getpos(".")

  " Find the start ...
  exec '?\<def\>'
  let block_start = line(".")

  " ... and end of the current block
  normal %
  let block_end = line(".")

  " Rename the variable within the range of the block
  exec ':' . block_start . ',' . block_end . 's/\<\zs' . @a . '\>\ze[^\(]/' . name . '/'

  " Restore @a
  let @a = old_register_a

  " Restore caret position
  call setpos(".",cursor_position) 
endfunction

" Synopsis
"   Extracts the selected scope into a method above the scope of the
"   current method
function! ExtractMethod() range
  try
    let name = s:get_input("Method name: ", "No method name given!")
  catch
    echo v:exception
    return
  endtry

  normal! gv

  " Yank & Replace selected range with the method name
  exec "normal C" . name
  " Mark source position so we can jump back afterwards
  " XXX: ideally shouldn't clobber this
  normal ma

  exec "?\\<def\\>"

  " Mark current position for reindenting the source
  exec "normal! O" . "def " . name . "\nend\n"

  " Paste yanked range, select entire method & reindent, and jump back to
  " starting position
  normal kPkV}k=`a
endfunction

function! InlineTemp()
  " Copy the variable under the cursor into the 'a' register
  " XXX: How do I copy into a variable so I don't pollute the registers?
  normal "ayiw

  " It takes 4 diws to get the variable, equal sign, and surrounding
  " whitespace. I'm not sure why. diw is different from dw in this
  " respect.
  normal 4diw
  " Delete the expression into the 'b' register
  normal "bd$

  " Delete the remnants of the line
  normal dd
  " Go to the end of the previous line so we can start our search for the
  " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
  " work; I'm not sure why.
  normal k$
  " Find the next occurence of the variable
  exec '/\<' . @a . '\>'
  " Replace that occurence with the text we yanked
  exec ':.s/\<' . @a . '\>/' . @b
endfunction

" Mappings:
"
" I have tried to use the mappings in a way that they describe the refactoring
" pattern to be used.
" I.e. Extract Method would be mapped to <leader>em

nnoremap <leader>rap :call AddParameter()<cr>
vnoremap <leader>rec :call ExtractConstant()<cr>
vnoremap <leader>relv :call ExtractLocalVariable()<cr>
vnoremap <leader>rrlv :call RenameLocalVariable()<cr>
vnoremap <leader>rem :call ExtractMethod()<cr>
nnoremap <leader>rit :call InlineTemp()<cr>
