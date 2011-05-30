# Ruby Refactoring Tool for Vim

I love vim! It's my editor of choice when I am developing software.

Currently (for the last 4 years at least) I have been working mainly
with the Ruby Programming Language.

I have been missing a refactoring tool for a while (like the ones you
can find in IDE's) while I am developing, but I never had the nerve
to dwell into vim script to actually code my own.

Recently (a couple of weeks ago) Gary Bernhardt presented his vim
configuration in the Software Craftsmanship User Group UK and he
showed us the two refactoring patterns he has written in vim script.

Initially I just thought "cool", but it didn't really sink in until
a couple of weeks later.

So now I have decided to code this in vim script, but I am not sure how far
I will go with it (clone at your own risk).

   N.B. 'Rename Local Variable', 'Rename Instance Variable' and 'ExtractMethod' require matchit.vim:

[http://www.vim.org/scripts/script.php?script_id=39](http://relishapp.com/despo/vim-ruby-refactoring)
   
## Implemented commands/patterns:
   
    :RAddParameter           - Add Parameter 
    :RInlineTemp             - Inline Temp
    :RConvertPostConditional - Convert Post Conditional
    :RExtractConstant        - Extract Constant          (visual selection)
    :RExtractLet             - Extract to Let (Rspec)
    :RExtractLocalVariable   - Extract Local Variable    (visual selection)
    :RRenameLocalVariable    - Rename Local Variable     (visual selection/variable under the cursor, *REQUIRES matchit.vim*)
    :RRenameInstanceVariable - Rename Instance Variable  (visual selection, *REQUIRES matchit.vim*)
    :RExtractMethod          - Extract Method            (visual selection, *REQUIRES matchit.vim*)

## Default bindings:

    :nnoremap <leader>rap  :RAddParameter<cr>
    :nnoremap <leader>rcpc :RConvertPostConditional<cr>
    :nnoremap <leader>rel  :RExtractLet<cr>
    :vnoremap <leader>rec  :RExtractConstant<cr>
    :vnoremap <leader>relv :RExtractLocalVariable<cr>
    :nnoremap <leader>rit  :RInlineTemp<cr>
    :vnoremap <leader>rrlv :RRenameLocalVariable<cr>
    :vnoremap <leader>rriv :RRenameInstanceVariable<cr>
    :vnoremap <leader>rem  :RExtractMethod<cr>

Additional usage examples (thanks Justin!):
[http://justinram.wordpress.com/2010/12/30/vim-ruby-refactoring-series/](http://justinram.wordpress.com/2010/12/30/vim-ruby-refactoring-series/)

## Documentation
[http://relishapp.com/despo/vim-ruby-refactoring](http://relishapp.com/despo/vim-ruby-refactoring)

Enrique Comba Riepenhausen & Paul King

