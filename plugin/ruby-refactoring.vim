"
" Author: Enrique Comba Riepenhausen (@ecomba) & Paul King (@nrocy)
" Email: enrique@edendevelopment.co.uk
" Email: somecrocodile@gmail.com
"
" Acknowledgements:
" Thanks to Gary Bernhardt for the inspiration for this tool and the original
" ExtractVariable() and InlineTemp() functions.
"
" Contributions from Stuart Gale (@bishboria)
"
" Some support functions borrowed from Luc Hermitte's lh-vim library
" Also borrowed snake case function from tim popes vim-abloish plugin

" Load all refactoring recipes
exec 'runtime ' . expand('<sfile>:p:h') . '/refactorings/general/*.vim'

" Commands:
"
" Using a simple 'R' prefix for now
" TODO: Do we even need this prefix? How likely is it that we'll conflict?

command! RAddParameter                  call AddParameter()
command! RAddParameterNB                call AddParameterNB()
command! RInlineTemp                    call InlineTemp()
command! RExtractLet                    call ExtractIntoRspecLet()
command! RConvertPostConditional        call ConvertPostConditional()
command! RIntroduceVariable             call IntroduceVariable()

command! -range RExtractConstant        call ExtractConstant()
command! -range RExtractLocalVariable   call ExtractLocalVariable()
command! -range RRenameLocalVariable    call RenameLocalVariable()
command! -range RRenameInstanceVariable call RenameInstanceVariable()
command! -range RExtractMethod          call ExtractMethod()

" Mappings:
"
" Default mappings are <leader>r followed by an acronym of the pattern's name
" E.g. Extract Method is mapped to <leader>rem

if !exists('g:ruby_refactoring_map_keys')
  let g:ruby_refactoring_map_keys = 1
endif

if g:ruby_refactoring_map_keys
  nnoremap <leader>rap  :RAddParameter<cr>
  nnoremap <leader>rapn :RAddParameterNB<cr>
  nnoremap <leader>rit  :RInlineTemp<cr>
  nnoremap <leader>rel  :RExtractLet<cr>
  nnoremap <leader>rcpc :RConvertPostConditional<cr>
  nnoremap <leader>riv  :RIntroduceVariable<cr>

  vnoremap <leader>rec  :RExtractConstant<cr>
  vnoremap <leader>relv :RExtractLocalVariable<cr>
  vnoremap <leader>rrlv :RRenameLocalVariable<cr>
  vnoremap <leader>rriv :RRenameInstanceVariable<cr>
  vnoremap <leader>rem  :RExtractMethod<cr>
endif
