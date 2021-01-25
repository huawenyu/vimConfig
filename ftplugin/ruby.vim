if exists('g:loaded_vim_projectionist_ruby') || !CheckPlug('vim-projectionist', 1)
    finish
endif
let g:loaded_vim_projectionist_ruby = 1

if HasPlug('vim-projectionist') | " {{{1
    let s:base_dir = resolve(expand("<sfile>:p:h"))
    let s:proj_jsn = s:base_dir . "/../conf/ruby.json"
    if !filereadable(s:proj_jsn)
        finish
    endif

    augroup ProjectionistHelper
        autocmd User ProjectionistDetect :call VimConfigLoadProjectionistJson(s:proj_jsn)
    augroup end
endif

