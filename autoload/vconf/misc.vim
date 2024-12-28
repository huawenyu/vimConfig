if exists("g:vimConfig_auto_vconf") || &cp || v:version < 700
    finish
endif
let g:vimConfig_auto_vconf = 1

function! vconf#misc#markExist(mark)
    " Get the position of the mark
    let pos = getpos("'" . a:mark)

    " Check if the mark is valid
    if pos[1] > 0
        return 1
    else
        return 0
    endif
endfunction


