" Ruby Refactoring in VIM
"
" Author: Enrique Comba Riepenhausen
" Email: enrique@edendevelopment.co.uk
" Email2: ecomba@gmail.com
"
" Acknowledgements:
" Thanks to Gary Bernhardt for the inspiration for this tool and the original
" ExtractVariable() and InlineTemp() functions.

function! AddParameter()
  let name = input("Parameter name: ")
  let closing_bracket_index = stridx(getline("."), ")")

  if name == ''
    return
  endif

  if closing_bracket_index == -1
    execute "normal A(" . name . ")\<Esc>"
  else
    exec ':.s/)/, ' . name . ')/'
  endif
endfunction

function! ExtractLocalVariable()
  let name = input("Variable name: ")
  if name == ''
    return
  endif
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

nnoremap <leader>ap :call AddParameter()<cr>
vnoremap <leader>elv :call ExtractLocalVariable()<cr>
nnoremap <leader>it :call InlineTemp()<cr>
