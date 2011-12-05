" Synopsis: 
"   converts a post-conditional expression to a conditional expression
"   note: will convert both types of conditional expression
function! ConvertPostConditional()
  " pattern to match
  let conditional_operators = '\<if\|unless\|while\|until\>'
  " save the current line
  let current_line = line('.')
  " go to end of current line
  normal $
  " find the first match for a conditional operator
  let first_match = search(conditional_operators, 'bnW')

  " if the first match isn't on the current line, exit.
  if current_line != first_match
    "echo "no match"
    return
  endif

  " move the cursor *backward* to the first found conditional operator
  call search(conditional_operators, 'bW')
  let conditional_pos = col(".")

  " move the cursor to the first word char on the line
  normal ^
  let line_start_pos = col(".")

  " move the cursor *forward* to the first found conditional operator
  call search(conditional_operators, 'cW')

  " if conditional starts line (pre-conditional), convert *to* post-conditional
  let is_pre_conditional = line_start_pos == conditional_pos
  if is_pre_conditional
    " convert to post-conditional (e.g. do_stuff() if condition)

    " assert conditional statement takes exactly three lines
    let first_line = line('.')
    let last_line = search('^\s*end\s*$', 'nW')
    let is_three_lines = (last_line - first_line) == 2
    if is_three_lines
      " delete third line, cut first, paste after second, join, indent properly
      normal jjddkkddpkJ==
    else
      "echo "multi-line conditional contains 2+ statements, aborting"
    endif
  else
    " convert to pre-conditional (e.g. if condition \n do_stuff() \n end)

    " save original value of buffer a into temp variable
    let original_value = @a
    " delete to the end of the line into buffer a
    normal "ad$
    " insert new line above
    normal O
    " and paste buffer a
    normal "ap
    " indent conditional properly
    normal ==
    " restore original value back to register a
    let @a = original_value
    " move one line down and add 'end'
    exec "normal jo" . "end"
    " move back to the line that you started at
    normal k
    " indent the conditional body
    normal >>
    " remove trailing whitespace from paste operation
	  s/\s*$//g
  endif
endfunction
