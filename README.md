# Ruby Refactoring Tool for Vim

Currently in 100% VimL, but might move toward a Ruby implementation sometime.

N.B. 'Rename Local Variable', 'Rename Instance Variable' and 'ExtractMethod'
require matchit.vim, so it is loaded by default. This should not cause any
problems, but if it does, let us know.

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

## Documentation

[Relish Feature Docs](http://relishapp.com/despo/vim-ruby-refactoring)

[Usage Examples (thanks Justin!)](http://justinram.wordpress.com/2010/12/30/vim-ruby-refactoring-series/)


## Credits

Original authors: Enrique Comba Riepenhausen & Paul King

Original idea came from Gary Bernhardt, who presented his vim configuration in
the Software Craftsmanship User Group UK and showed two refactoring patterns he
has written in vim script.

