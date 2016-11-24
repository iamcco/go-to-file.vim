"===============================================================================
"File: plugin/gotofile.vim
"Description: go to the file from require/import line
"Last Change: 2016-11-24 night
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 0.0.1
"===============================================================================

if exists('g:loaded_go_to_file')
    finish
endif
let g:loaded_go_to_file = 1

let s:save_cpo = &cpo
set cpo&vim
"-------------------------------------------------------------------------------

if !exists('g:go_to_file_type')
    let g:go_to_file_type = 'node_modules'
endif

nmap <silent> <Plug>gotofile :call gotofile#open_file()<CR>
if !hasmapto('<Plug>gotofile')
    nmap <silent> <Leader>gf <Plug>gotofile
endif

"-------------------------------------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo

