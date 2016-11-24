"===============================================================================
"File: autoload/gotofile.vim
"Description: go to file from require/import line
"Last Change: 2016-11-24 night
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 0.0.1
"===============================================================================

function! s:get_path() abort
    " 获取 g:go_to_file_type 文件夹路径
    " 默认为 node_modules 文件夹
    let s:path = fnamemodify(finddir(g:go_to_file_type, fnameescape(expand('%:p:h')) . ';'), ':p')
    return s:path
endfunction

function! s:get_filename() abort
    " 获取 require({name}) 或 import xxx from {name} 中的 name
    let s:line = getline('.')
    let s:file_reg = ['\v^.*<require>\(\s*[''"]([^''"]+)[''"]\s*\).*$',
                    \'\v^.*<import>.*<from>\s+[''"]([^''"]+)[''"].*$'
                    \]
    for s:reg in s:file_reg
        if s:line =~ s:reg
            return substitute(s:line, s:reg, '\1', '')
        endif
    endfor
    return 0
endfunction

function! s:get_file_path() abort
    " 获取文件的绝对路径"
    let s:filename = s:get_filename()
    let s:pwd = fnameescape(expand('%:p:h'))
    let s:is_abs_path = '\v^/.*$|^[a-zA-Z]:\\.*$'
    let s:is_relative_path = '\v^\./.*$'

    if s:filename =~ '0'
        return 0
    endif

    if s:filename =~ s:is_abs_path
        if filereadable(s:filename)
            return s:filename
        elseif isdirectory(s:filename) && filereadable(s:filename . '/index.js')
            return s:filename . '/index.js'
        endif
    else
        if s:filename =~ s:is_relative_path
            let s:filename = s:filename[2:]
        endif
        let s:abs_file_path = s:pwd . '/' . s:filename
        if filereadable(s:abs_file_path)
            return s:abs_file_path
        elseif filereadable(s:abs_file_path . '.js')
            return s:abs_file_path . '.js'
        elseif isdirectory(s:abs_file_path) && filereadable(s:abs_file_path . '/index.js')
            return s:abs_file_path . '/index.js'
        else
            let s:module_path = s:get_path()
            if s:module_path =~ '\v^.*/node_modules/$'
                let s:module_path = s:module_path . s:filename
                if filereadable(s:module_path)
                    return s:module_path
                elseif isdirectory(s:module_path) && filereadable(s:module_path . '/package.json')
                    let s:package_info = json_decode(join(readfile(s:module_path . '/package.json', ''), ''))
                    if has_key(s:package_info, 'main')
                        let s:module_path = s:module_path . '/' . s:package_info['main']
                    endif
                    if filereadable(s:module_path)
                        return s:module_path
                    elseif filereadable(s:module_path . '.js')
                        return s:module_path . '.js'
                    elseif filereadable(s:module_path . '/index.js')
                        return s:module_path . '/index.js'
                    endif
                endif
            endif
        endif
    endif
    return 0
endfunction

function! gotofile#open_file() abort
    let s:path = s:get_file_path()
    if !(s:path =~ '0')
        exec 'edit ' . s:path
    endif
endfunction

