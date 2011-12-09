"Synopsis:
"  Introduce variable from class or method name
function! IntroduceVariable()
  let original_a = @a

  normal ^

  call search('\.*(\|{\|\n', 'p')
  normal hh"ayiw

  let line = @a

  if line == "new"
    normal ^"ayiw
    let line = @a
  endif

  let @a = original_a
  let var = s:snakecase(line)
  exec "normal I" . var . " = "

endfunction

function! s:snakecase(word)
  let word = substitute(a:word,'::','/','g')
  let word = substitute(word,'\(\u\+\)\(\u\l\)','\1_\2','g')
  let word = substitute(word,'\(\l\|\d\)\(\u\)','\1_\2','g')
  let word = substitute(word,'-','_','g')
  let word = tolower(word)
  return word
endfunction
