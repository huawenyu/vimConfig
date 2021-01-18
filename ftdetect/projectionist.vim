if exists('g:loaded_vim_projectionist_global') || !CheckPlug('vim-projectionist', 1)
    finish
endif
let g:loaded_vim_projectionist_global = 1

let s:base_dir = resolve(expand("<sfile>:p:h"))
let s:proj_jsn = $HOME . "/.projections.json"
if !filereadable(s:proj_jsn)
    finish
endif

" https://github.com/andyl/vim-projectionist-elixir
function! s:setProjections()
    " filterout the comment line which begin with `//`
    "let l:json = readfile(s:proj_jsn)
    let l:json = filter(readfile(s:proj_jsn), 'match(v:val, "\s*//.*") < 0')
    let l:dict = projectionist#json_parse(l:json)
    call projectionist#append(getcwd(), l:dict)
endfunction

" https://blog.afoolishmanifesto.com/posts/advanced-projectionist-templates/
function! ExpandTemplate()
   %s/\~\~CURDATE\~\~/\=systemlist("date +%FT%T")[0]/ge
   %s/\~\~GUID\~\~/\=systemlist("uuidgen")[0]/ge
endfunction


augroup ProjectionistHelper
    autocmd!
    autocmd User ProjectionistDetect :call s:setProjections()
    autocmd User ProjectionistApplyTemplate call ExpandTemplate()
augroup end

