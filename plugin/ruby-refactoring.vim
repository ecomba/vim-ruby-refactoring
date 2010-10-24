" Ruby Refactoring in VIM
"
" Author: Enrique Comba Riepenhausen
" Email: enrique@edendevelopment.co.uk
" Email2: ecomba@gmail.com
"
" Acknowledgements:
" Thanks to Gary Bernhardt for the inspiration for this tool and the original
" ExtractVariable() and InlineTemp() functions.
"
" Some support functions borrowed from Luc Hermitte's lh-vim library
"
" Many, many thanks to Paul King for the great effort in writing a lot ot the
" patterns found in this library and the endless nights he stays awake to make
" this happen.

" Support functions
"
" Synopsis:
"   Returns the input given by the user
function! s:get_input(message, error_message)
  let name = input(a:message)
  if name == ''
    throw a:error_message
  endif
  return name
endfunction

" Synopsis:
"   Returns the text that was selected when the function was invoked
"   without clobbering any registers
function! s:get_visual_selection() 
  try
    let a_save = @a
    normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" Synopsis:
"   Loop over the line range given, global replace pattern with replace
function! s:gsub_all_in_range(start_line, end_line, pattern, replace)
  let lnum = a:start_line
  while lnum <= a:end_line
    let oldline = getline(lnum)
    let newline = substitute(oldline,a:pattern,a:replace,'g')
    call setline(lnum, newline)
    let lnum = lnum + 1
  endwhile
endfunction!

" Synopsis:
"   Find pattern to matching end, flags as per :h search()
function! s:get_range_for_block(pattern_start, flags)
  " matchit.vim required 
  if !exists("g:loaded_matchit") 
    throw("matchit.vim (http://www.vim.org/scripts/script.php?script_id=39) required for RenameLocalVariable()")
  endif

  let cursor_position = getpos(".")

  " TODO: Need alternative to remove matchit.vim dep - matchpair() ?
  let block_start = search(a:pattern_start, a:flags)
  normal %
  let block_end = line(".")

  " Restore the cursor
  call setpos(".",cursor_position) 

  return [block_start, block_end]
endfunction

" Patterns

" Synopsis:
"   Adds a parameter (or many separated with commas) to a method
function! AddParameter()
  try
    let name = s:get_input("Parameter name: ", "No parameter name given!")
  catch
    echo v:exception
    return
  endtry

  " Save current position
  let cursor_position = getpos(".")

  " Move backwards to the method definiton if you are not already on the
  " correct line
  if empty(matchstr(getline("."), '\<def\>'))
    exec "?\\<def\\>"
  endif

  let closing_bracket_index = stridx(getline("."), ")")

  if closing_bracket_index == -1
    execute "normal A(" . name . ")\<Esc>"
  else
    exec ':.s/)/, ' . name . ')/'
  endif

  " Restore caret position
  call setpos(".", cursor_position)
endfunction

" Synopsis:
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

" Synopsis:
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

" Synopsis:
"   Rename the selected instance variable
function! RenameInstanceVariable()
  try
    let selection = s:get_visual_selection()

    " If no @ at the start of selection, then abort
    if match( selection, "^@" ) == -1
      let left_of_selection = getline(".")[col(".")-2]
      if left_of_selection == "@"
        let selection = "@".selection
      else
        throw "Selection '" . selection . "' is not an instance variable"
      end
    endif

    let name = s:get_input("Rename to: @", "No variable name given!" )
  catch
    echo v:exception
    return
  endtry

  " Assume no prefix given
  let name_no_prefix = name

  " Add leading @ if none provided
  if( match( name, "^@" ) == -1 )
    let name = "@" . name
  else
    " Remove the @ from the no_prefix version
    let name_no_prefix = matchstr(name,'^@\zs.*')
  endif

  " Find the start and end of the current block
  " TODO: tidy up if no matching 'def' found (start would be 0 atm)
  let [block_start, block_end] = s:get_range_for_block('\<class\>','Wb')

  " Rename the variable within the range of the block
  call s:gsub_all_in_range(block_start, block_end, selection.'\>\ze\([^\(]\|$\)', name)

  " copy with no prefix for the attr_* match
  let selection_no_prefix = matchstr( selection, '^@\zs.*' )

  " Rename attr_* symbols
  call s:gsub_all_in_range(block_start, block_end, '^\s*attr_\(reader\|writer\|accessor\).*\:\zs'.selection_no_prefix, name_no_prefix)
endfunction

" Synopsis:
"   Intending to pass all rename variable methods through here, allowing
"   various conveniences. Allows normal mode rename of *local* variable under
"   the cursor only, for now. 
function! RenameVariableProxy() 
  let selection = s:get_visual_selection()
  
  let left_of_selection = getline(".")[col(".")-2]
  if left_of_selection == "@"
    throw "Use RenameInstanceVariable() to rename instance variables"
  endif

  call RenameLocalVariable()
endfunction

" Synopsis:
"   Rename the selected local variable 
function! RenameLocalVariable()
  try
    let selection = s:get_visual_selection()

    " If @ at the start of selection, then abort
    if match( selection, "@" ) != -1
      throw "Selection '" . selection . "' is not a local variable"
    endif

    let name = s:get_input("Rename to: ", "No variable name given!" )
  catch
    echo v:exception
    return
  endtry

  " Find the start and end of the current block
  " TODO: tidy up if no matching 'def' found (start would be 0 atm)
  let [block_start, block_end] = s:get_range_for_block('\<def\>','Wb')

  " Rename the variable within the range of the block
  call s:gsub_all_in_range(block_start, block_end, '[^@]\<\zs'.selection.'\>\ze\([^\(]\|$\)', name)
endfunction

" Synopsis:
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

  exec '?\<def\>'

  " Mark current position for reindenting the source
  exec "normal! O" . "def " . name . "\nend\n"

  " Paste yanked range, select entire method & reindent, and jump back to
  " starting position
  normal kPkV}k=`a
endfunction

" Synopsis:
"   Inlines a variable
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

" Commands:
"
" Using a simple 'R' prefix for now
" TODO: Do we even need this prefix? How likely is it that we'll conflict?

command! RAddParameter                  call AddParameter()
command! RInlineTemp                    call InlineTemp()

command! -range RExtractConstant        call ExtractConstant()
command! -range RExtractLocalVariable   call ExtractLocalVariable()
command! -range RRenameLocalVariable    call RenameLocalVariable()
command! -range RRenameInstanceVariable call RenameInstanceVariable()
command! -range RExtractMethod          call ExtractMethod()

" Mappings:
"
" Default mappings are <leader>r followed by an acronym of the pattern's name
" I.e. Extract Method is mapped to <leader>rem

nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rit  :RInlineTemp<cr>

vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>

" TODO: PPK - Revisit this, not convinced the proxy fn is such a good idea in retrospect 
nnoremap <leader>rrlv viw:call RenameVariableProxy()<cr>

