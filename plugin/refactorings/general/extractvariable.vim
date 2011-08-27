" Synopsis:
"   Extracts the selected scope to a variable
function! ExtractLocalVariable()
  try
    let name = common#get_input("Variable name: ", "No variable name given!")
  catch
    echo v:exception
    return
  endtry
  
  call s:select_variable_contents()

  " Replace selected text with the variable name
  exec "normal c" . name

  " Define the variable on the line above
  exec "normal! O" . name . " = "

  " Paste the original selected text to be the variable value
  normal! $p
endfunction

function! s:select_variable_contents()
  " select current word or re-establish selection
  " (not sure why we need to re-select)
  if (visualmode() == "")
    normal! viw
  else
    normal! gv
  endif
endfunction

