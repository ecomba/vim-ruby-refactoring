" Synopsis:
"   Inlines a variable
function! InlineTemp()
  " Copy the variable under the cursor into the 'a' register
  " XXX: How do I copy into a variable so I don't pollute the registers?
  let original_a = @a
  normal "ayiw

  " It takes 4 diws to get the variable, equal sign, and surrounding
  " whitespace. I'm not sure why. diw is different from dw in this
  " respect.
  normal 4diw
  " Delete the expression into the 'b' register
  let original_b = @b
  normal "bd$

  " Delete the remnants of the line
  normal dd

  " Store current line, that's where we will start searching from
  let current_line = line(".")

  " Find the start and end of the current block
  " TODO: tidy up if no matching 'def' found (start would be 0 atm)
  let [block_start, block_end] = common#get_range_for_block('\<def\|it\>','Wb')

  " Rename the variable within the range of the block
  call common#gsub_all_in_range(current_line, block_end, '\<' . @a . '\>', @b)

  " Put back original register contents
  let @a = original_a
  let @b = original_b
endfunction
