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
"   Param: Optional parameter of '1' dictates cut, rather than copy
"   Returns the text that was selected when the function was invoked
"   without clobbering any registers
function! s:get_visual_selection(...) 
  try
    let a_save = @a
    if a:0 >= 1 && a:1 == 1
      normal! gv"ad
    else
      normal! gv"ay
    endif
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" Synopsis:
"   Copies, removes, then returns the text that was selected when the function was invoked
"   without clobbering any registers
function! s:cut_visual_selection() 
  return s:get_visual_selection(1)
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
"   Find start of pattern only, flags as per :h search()
"   N.B. This only exists to allow ExtractMethod to work without matchit.vim
function! s:get_start_of_block(pattern_start, flags)
  let cursor_position = getpos(".")
  let result = search(a:pattern_start, a:flags)
  call setpos(".",cursor_position)

  return result
endfunction

" Synopsis:
"   Find pattern to matching end, flags as per :h search()
function! s:get_range_for_block(pattern_start, flags)
  " matchit.vim required 
  if !exists("g:loaded_matchit") 
    throw("matchit.vim (http://www.vim.org/scripts/script.php?script_id=39) required")
  endif

  let cursor_position = getpos(".")

  " TODO: Need alternative to remove matchit.vim dep - matchpair() ?
  " let block_start = s:get_start_of_block(a:pattern_start, a:flags)
  " TODO: PPK Remove this dep again
  let block_start = search(a:pattern_start, a:flags)
  normal %
  let block_end = line(".")

  " Restore the cursor
  call setpos(".",cursor_position) 

  return [block_start, block_end]
endfunction

function! s:dedupe_list(target)
  call filter(a:target, 'count(a:target,v:val) > 1 ? 0 : 1') 
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

function! s:find_variables( block )
  let lines = split( a:block, "\n" )
  let locals = {}

  for line in lines
    " This regexp can likely be improved to avoid the array deref split later
    " TODO: Filter out @instance_vars
    " TODO: This isn't matching variable assignment:  foo = bar 
    let tokens = matchlist( line, '\([_0-9a-zA-Z\[\]]\+\)\s*=\s*\(.*\)' )
    "echo tokens
    if len(tokens) > 0 && tokens[1] != ""
      if stridx(tokens[1], "[") != -1 
        let parts = split(tokens[1], "[")
        let var_name = parts[0]
      else
        let var_name = tokens[1]
      end
      let locals[var_name] = 1
    endif
  endfor

  return keys(locals)
endfunction

function! s:determine_variables( block )
  let statements = split(a:block,'\s\+' )
  echo statements
  "let tokens = split(a:block,'\s\+')
  "echo tokens
  " Logic:
  "   Split on ; in case of multiple lines
  "   Foreach line
  "     Determine line type
  "     if line has a single = then 
  "       grab words to the left as lvars
  "       grab words to the right as rvars
  "     if line has a double = then
  "       grab words to the left and right as rvars 
  "
  "   TODO: Handle x = y = z = 10 using a different method
  "   TODO: Handle sprawling multiline strings
  "   TODO: Handle comments
  "   TODO: Handle x == y ? a : b 
  "
  " synID() synIDattr()
endfunction

function! ExtractMethod2() range
  " TODO: This doesn't work for partial selections again, not sure what the
  " use-case is for this
  let [block_start, block_end] = s:get_range_for_block('\<def\>','Wb')

  call s:determine_variables( join( getline(block_start+1,block_end-1), "\n" ) )
  return 

  let param_selection = getline(block_start)
  let param_variables = split(matchstr(param_selection,'(\(.*\))','\W\+'),'\W\+')

  let pre_selection = join( getline(block_start+1,a:firstline-1), "\n" )
  let pre_method_variables = s:find_variables( pre_selection )

  call extend(pre_method_variables, param_variables)
  call s:dedupe_list(pre_method_variables)

  let post_selection = join( getline(a:lastline+1,block_end), "\n" )
  let post_method_variables = s:find_variables( post_selection )

  let selection = s:cut_visual_selection()
  let method_variables = s:determine_variables( selection )
  
  " Logic:
  "   If a variable was assigned/defined before the selection and is used within the
  "   selection then it needs to be passed into the new method as a parameter
  "
  "   If a variable was defined/assigned within the selection it must be
  "   returned from the method and assigned to a return value IF it's
  "   referenced AFTER the select
  "
  "   If something is assigned to a variable (LHS of an = then we need to
  "   return it)
  "
  "   If something is made user of (RHS of an = then we need to parameterise
  "   it)
  "
  "   TODO: We don't handle x,y=x,y but this should be doable
  "   
  "   TODO: Attempt to determine if the RHS is a method
  "
  "   TODO: Handle @ivars properly
  "
  "   TODO: Handle blocks properly { |x| }
  "
  "   TODO: If we're extracting the last line in the method, need to look at what it does and ensure
  "   that we return something equivalent
  let parameters = [] 
  let retvals = []

  for var in method_variables
    if index(pre_method_variables, var) != -1
      call insert(parameters, var) 
    endif
    if index(post_method_variables, var) != -1
      call insert(retvals, var)
    endif
  endfor

  let name = "ref_method"
  
  " Remove last \n if it exists, as we're adding one on prior to the 'end'
  let has_trailing_newline = strridx(selection,"\n") == (strlen(selection) - 1) ? 1 : 0

  " Build new method text, split into a list for easy insertion
  let method_params = ""
  if len(parameters) > 0 
    let method_params = "(" . join(parameters, ",") . ")"
  endif

  let method_retvals = ""
  if len(retvals) > 0 
    let method_retvals = join(retvals,", ")
  endif

  let method_lines = split("def " . name . method_params . "\n" . selection . (has_trailing_newline ? "" : "\n") . (len(retvals) > 0 ? "return " . method_retvals . "\n" : "") . "end\n", "\n", 1)

  " Start a line above, as we're appending, not inserting
  let start_line_number = block_start - 1

  " Sanity check
  if start_line_number < 0 
    let start_line_number = 0
  endif

  " Insert new method
  call append(start_line_number, method_lines) 

  " Insert call to new method, and fix up the source so it makes sense
  if has_trailing_newline
    exec "normal i" . (len(retvals) > 0 ? method_retvals . " = " : "") . name . method_params . "\n"
    normal k
  else
    exec "normal i" . name 
  end

  " Reset cursor position
  let cursor_position = getpos(".")

  " Fix indent on call to method in case we corrupted it
  normal V=
  
  " Indent new codeblock
  exec "normal " . start_line_number . "GV" . len(method_lines) . "j="

  " Jump back again, 
  call setpos(".", cursor_position)

  " Visual mode normally moves the caret, go back
  if has_trailing_newline 
    normal $
  endif
endfunction

function! s:next_token( str )
endfunction

function! s:tokenize( block )
  " replace newline with newline marker
  " collapse all whitespace to single characters
  " join lines together for multiple line strings
  " strip abonormalities to get a chain of tokens

  " for easy tokenisation, turn newlines into expression separators
  let stripped_block = tr( a:block, "\n", ";" )

  " todo refactor this

  let tokens = []

  let ofs = match( stripped_block, '\W' )
  while ofs != -1
    if ofs == 0 
      let ofs = ofs + 1 
    endif

    let token = strpart( stripped_block, 0, ofs )
    call add( tokens, token )
    let stripped_block = strpart( stripped_block, ofs )
    let ofs = match( stripped_block, '\W' )
  endwhile

  let ofs = match( stripped_block, '$' )
  let token = strpart( stripped_block, 0, ofs )
  call add( tokens, token )

  return tokens
endfunction

function! s:tokenize2( block )
  let stripped_block = tr( a:block, "\n", ";" )

  let tokens = []

  let ofs = 0
  while 1
    let a = matchstr( stripped_block, '\v^(;|,|\(|\)|\d+\.\d+|\:?\w+|\s+|\''|\"|\=|\S+)', ofs )
    if a == ""
      break
    endif
    let ofs = ofs + len(a)
    call add(tokens,a)
  endwhile

  return tokens
endfunction

function! s:identify_tokens( tokenlist )
  let symbols = []
  for token in a:tokenlist 
    if match( token,'^\s\+$' ) != -1
      let sym = "WS"
    elseif token == "="
      let sym = "ASSIGN"
    elseif token == '"'
      let sym = "DQS"
    else
      let sym = token
    end
    call add(symbols,sym)
  endfor

  return symbols
endfunction

function! s:identify_tokens2( tokenlist )
  let symbols = []
  let tokens = []
  let tokenstack = []
  let symbolstack = []
  let lastsym = "WS"

  let i = 0
  while 1
    let token = get(a:tokenlist,i,"")

    if match( token,'^\s\+$' ) != -1
      let sym = "WS"
    elseif token == ':'
      let sym = "COLON"
    elseif match( token,'\v^:\w+$' ) != -1
      let sym = "SYMBOL"
    elseif match( token,'\v^\w+$' ) != -1
      let sym = "VARFUN"
    elseif match( token,'\v^\W+$' ) != -1
      let sym = "OPER"
    elseif token == '"'
      let sym = "DQS"
    elseif token == "'"
      let sym = "SQS"
    else
      let sym = "OTHER"
    end

    " combine and push to proper stacks
    if lastsym != sym 
      if !empty(symbolstack)
        call add(tokens,join(tokenstack,'')) 
        call add(symbols,symbolstack[0]) 
        let tokenstack = []
        let symbolstack = []
      endif
    endif
      
    " push to the stacks
    call add(tokenstack, token)
    call add(symbolstack, sym)

    let lastsym = sym

    if (token == "")
      break
    endif

    let i = i + 1
  endwhile

  echo tokens
  echo symbols
endfunction

function! s:identify_tokens3( tokenlist )
  let symbols = []
  let statements = []
  let reserved = [ "alias", "and", "BEGIN", "begin", "break", "case", "class", "def", "defined?", "do", "else", "elsif", "END", "end", "ensure", "false", "for", "if", "in", "module", "next", "nil", "not", "or", "redo", "rescue", "retry", "return", "self", "super", "then", "true", "undef", "unless", "until", "when", "while", "yield" ]

  for token in a:tokenlist
    if index(reserved,token) != -1
      let sym = "KEYWORD"
    elseif match(token, '\v^\s+$') != -1
      let sym = "WS"
    elseif match(token, '\v^\:\w+$') != -1
      let sym = "SYMBOL"
    elseif match(token, '\v^\I\i*$') != -1
      let sym = "VAR"
    elseif match(token, '\v^\d+(\.\d+)?$') != -1
      let sym = "CONST"
    elseif token == '=' 
      let sym = 'ASSIGN'
    elseif token == ',' 
      let sym = 'COMMA'
    elseif token == '"' 
      let sym = 'DQUOTE'
    elseif token == "'" 
      let sym = 'SQUOTE'
    elseif token == '(' 
      let sym = 'LPAREN'
    elseif token == ')' 
      let sym = 'RPAREN'
    elseif token == ';' 
      if len(symbols) > 0 
        call add(statements, symbols)
        let symbols = []
        continue
      endif
    else
      let sym = "OPER"
    endif

    call add(symbols,[token,sym])
  endfor

  return statements
endfunction

function! ExtractMethod3() 
  let testcase = "def mymethod( param1, param2 )\nputs 'hello, world'\nend\n" 
  echo testcase

  let tokens = s:tokenize2(testcase)
  let statements = s:identify_tokens3( tokens )

  for statement in statements 
    echo statement
  endfor
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
  
  let selection = s:cut_visual_selection()

  " Remove last \n if it exists, as we're adding one on prior to the 'end'
  let has_trailing_newline = strridx(selection,"\n") == (strlen(selection) - 1) ? 1 : 0

  " Get the block for the current method
  let method_start = s:get_start_of_block('\<def\>','Wb')

  " Build new method text, split into a list for easy insertion
  let method_lines = split("def " . name . "\n" . selection . (has_trailing_newline ? "" : "\n") . "end\n", "\n", 1)

  " Start a line above, as we're appending, not inserting
  let start_line_number = method_start - 1

  " Sanity check
  if start_line_number < 0 
    let start_line_number = 0
  endif

  " Insert new method
  call append(start_line_number, method_lines) 

  " Insert call to new method, and fix up the source so it makes sense
  if has_trailing_newline
    exec "normal i" . name . "\n"
    normal k
  else
    exec "normal i" . name 
  end

  " Reset cursor position
  let cursor_position = getpos(".")

  " Fix indent on call to method in case we corrupted it
  normal V=
  
  " Indent new codeblock
  exec "normal " . start_line_number . "GV" . len(method_lines) . "j="

  " Jump back again, 
  call setpos(".", cursor_position)

  " Visual mode normally moves the caret, go back
  if has_trailing_newline 
    normal $
  endif
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
command! -range RExtractMethod          call ExtractMethod2()

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

" TODO: For some reason, the command method doesn't set the range properly :(
vnoremap <leader>fufu :call ExtractMethod2()<cr>

" TODO: PPK - Revisit this, not convinced the proxy fn is such a good idea in retrospect 
nnoremap <leader>rrlv viw:call RenameVariableProxy()<cr>

