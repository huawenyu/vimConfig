if exists("g:vimConfig_cmd") || &cp || v:version < 700
    finish
endif
let g:vimConfig_cmd = 1

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
if g:vim_confi_option.auto_restore_cursor
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
endif


" Autocmd {{{2
    augroup filetype_auto
        " Voom/VOom:
        " <Enter>             selects node the cursor is on and then cycles between Tree and Body.
        " <Tab>               cycles between Tree and Body windows without selecting node.
        " <C-Up>, <C-Down>    move node or a range of sibling nodes Up/Down.
        " <C-Left>, <C-Right> move nodes Left/Right (promote/demote).
        "
        autocmd!

        " This replaces [Process exited 0] with "Custom Message!".
        autocmd TermClose * echom "Normal:<C-\\n>; Insert: i"

        "autocmd VimLeavePre * cclose | lclose
        autocmd InsertEnter,InsertLeave * set cul!
        autocmd VimResized * wincmd =
        autocmd CmdlineLeave :set cmdheight=1 | silent! copen

        if g:vim_confi_option.auto_save
            " Automatically write changes when the file is writable
            "autocmd InsertLeave * write
            " Disabled: causes slow :qa - migrated to init.lua
            "autocmd BufLeave,FocusLost * if &modifiable | silent! update | endif
        endif

        " Sometime crack the tag file
        "autocmd BufWritePost,FileWritePost * call RetagFile()

        " current position in jumplist
        autocmd CursorHold * normal! m'
        "autocmd BufEnter term://* startinsert

        "if has('nvim')
        "    "autocmd BufNew,BufEnter term://* startinsert
        "    autocmd BufEnter,BufEnter * if &buftype == 'terminal' | :startinsert | endif
        "endif

        " Always show sign column
        autocmd BufEnter * sign define dummy
        autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

        "ShellCmd like: $ rusty-tags vi --output=".tags"
        "autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/

        " Set filetype base on extension
        autocmd BufNewFile,BufRead *.c.rej,*.c.orig,h.rej,*.h.orig,patch.*,*.diff,*.patch   set ft=diff | C4
        autocmd BufNewFile,BufRead *.c,*.c,*.h,*.cpp,*.C,*.CXX,*.CPP   set ft=c
        autocmd TermOpen * silent! ContextDisable

        "autocmd BufNewFile,BufRead *.md  setfiletype markdown
        "autocmd BufNewFile,BufRead,BufEnter *.wiki  set ft=markdown    | " Cause vimwiki file navigator keymap fail
        "autocmd FileType vimwiki set syntax=markdown                   | " Please config g:vimwiki_ext2syntax

        autocmd BufWritePre [\,:;'"\]\)\}]* throw 'Forbidden file name: ' . expand('<afile>')

        command! -nargs=* C0  setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
        command! -nargs=* C2  setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
        command! -nargs=* C02 setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
        command! -nargs=* C4  setlocal autoindent cindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
        command! -nargs=* C04 setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
        command! -nargs=* C8  setlocal autoindent cindent noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
        command! -nargs=* C08 setlocal autoindent cindent expandtab   tabstop=8 shiftwidth=8 softtabstop=8

        "autocmd filetype vim,tmux,txt    C0
        "autocmd filetype c,cpp,diff      C8
        "autocmd filetype zsh,bash        C2
        "autocmd filetype vim,markdown    C08

        "autocmd filetype log nnoremap <buffer> <leader>la :call log#filter(expand('%'), 'all')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>le :call log#filter(expand('%'), 'error')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>lf :call log#filter(expand('%'), 'flow')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>lt :call log#filter(expand('%'), 'tcp')<CR>

        " " Test
        " "nnoremap <silent> <leader>t :<c-u>R <C-R>=printf("python -m doctest -m trace --listfuncs --trackcalls %s \| tee log.test", expand('%:p'))<cr><cr>
        " autocmd FileType python nnoremap <buffer> <leader>tt :<c-u>R <C-R>=printf("python -m doctest %s \| tee log.test", expand('%:p'))<cr><cr>
        " autocmd FileType python nnoremap <buffer> <leader>tr :<c-u>R <C-R>=printf("python -m trace --trace %s \|  grep %s", expand('%:p'), expand('%'))<cr><cr>

        " :help K  (powerman/vim-plugin-viewdoc)
        if g:vim_confi_option.keywordprg_filetype
            autocmd FileType python setlocal keywordprg=pydoc
            " sudo apt-get install cppman   (https://github.com/aitjcize/cppman)
            autocmd FileType cpp setlocal keywordprg=:te\ cppman
        endif

    augroup END

"}}}


" Commands {{{2
    " Migrated to lazy.nvim init.lua
"}}}




" function! SaveJump(motion)
"   if exists('#SaveJump#CursorMoved')
"     autocmd! SaveJump
"   else
"     normal! m'
"   endif
"   let m = a:motion
"   if v:count
"     let m = v:count.m
"   endif
"   execute 'normal!' m
" endfunction
"
" function! SetJump()
"   augroup SaveJump
"     autocmd!
"     autocmd CursorMoved * autocmd! SaveJump
"   augroup END
" endfunction
"
" nnoremap <silent> <C-o> :<C-u>call SaveJump("\<lt>C-u>")<CR>:call SetJump()<CR>
" nnoremap <silent> <C-i> :<C-u>call SaveJump("\<lt>C-d>")<CR>:call SetJump()<CR>


" Section 'String'
    " Migrated to lazy.nvim init.lua

" Section 'Execute'
    " Migrated to lazy.nvim init.lua

function MyMenuExec(...)
    let strCmd = join(a:000, '')
    silent! call s:log.info('MyExecArgs: "', strCmd, '"')
    exec strCmd
endfunc

" https://github.com/szw/vim-smartclose
" SmartClose migrated to lazy.nvim init.lua

" vim:set ft=vim et sw=4:

