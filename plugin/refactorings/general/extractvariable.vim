" Synopsis:
"   Extracts the selected scope to a variable
function! ExtractLocalVariable()
  let selection = common#get_visual_selection()

  try
    let name = common#get_input("Variable name: ", "No variable name given!")
  catch
    echo v:exception
    return
  endtry

  " Find the start and end of the current block
  let [block_start, block_end] = common#get_range_for_block('\<def\>','Wb')

  " Use the variable in all occurences within the block
  call common#gsub_all_in_range(block_start, block_end, '[^@]\zs'.selection.'\ze\([^\(]\|$\)', name)

  " Define the variable on the line above
  exec "normal! O" . name . " = " . selection
endfunction


