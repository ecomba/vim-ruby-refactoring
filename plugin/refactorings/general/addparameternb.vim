
" Synopsis:
"   Adds a parameter (or many separated with commas) to a method with no
"   brackets
function! AddParameterNB()
  try
    let name = common#get_input("Parameter name: ", "No parameter name given!")
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

  execute "normal A " . name . "\<Esc>"

  " Restore caret position
  call setpos(".", cursor_position)
endfunction

