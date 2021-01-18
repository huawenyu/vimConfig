if exists('g:loaded_vim_projectionist_vim') || !CheckPlug('vim-projectionist', 1)
    finish
endif
let g:loaded_vim_projectionist_vim = 1

let s:base_dir = resolve(expand("<sfile>:p:h"))
let s:proj_jsn = s:base_dir . "/../conf/vim.json"
if !filereadable(s:proj_jsn)
    finish
endif


function! s:setProjections()
    let l:json = filter(readfile(s:proj_jsn), 'match(v:val, "\s*//.*") < 0')
    let l:dict = projectionist#json_parse(l:json)
    call projectionist#append(getcwd(), l:dict)
endfunction

augroup ProjectionistHelper
    autocmd User ProjectionistDetect :call s:setProjections()
augroup end

