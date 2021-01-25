if exists('g:loaded_vim_projectionist_global') || !CheckPlug('vim-projectionist', 1)
    finish
endif
let g:loaded_vim_projectionist_global = 1


if HasPlug('vim-projectionist') | " {{{1
    " https://github.com/andyl/vim-projectionist-elixir
    let s:base_dir = resolve(expand("<sfile>:p:h"))
    let s:proj_jsn = $HOME . "/.projections.json"
    if !filereadable(s:proj_jsn)
        finish
    endif

    " https://blog.afoolishmanifesto.com/posts/advanced-projectionist-templates/
    function! ExpandTemplate()
       %s/\~\~CURDATE\~\~/\=systemlist("date +%FT%T")[0]/ge
       %s/\~\~GUID\~\~/\=systemlist("uuidgen")[0]/ge
    endfunction

    augroup ProjectionistHelper
        autocmd!
        autocmd User ProjectionistDetect :call VimConfigLoadProjectionistJson(s:proj_jsn)
        autocmd User ProjectionistApplyTemplate call ExpandTemplate()
    augroup end
endif
