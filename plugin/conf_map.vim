if exists('g:vimConfig_map') || &compatible
  finish
endif
let g:vimConfig_map = 1

if g:vim_confi_option.upper_keyfixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif
    "cmap Tabe tabe
endif


if g:vim_confi_option.alt_shortcut
    nmap <a-e>    <leader>ve
    nmap <a-w>    <leader>vw
    nmap <a-t>    <leader>vt
    nmap <a-b>    <leader>vb
    nmap <a-g>    <leader>vg
    nmap <a-q>    <leader>vq
    nmap <a-f>    ;fs
    nmap <a-s>    <leader>g1

    nnoremap <a-/>    :AsyncTaskList<cr>
    nnoremap <a-;>    :AsyncTask build<cr>
    nnoremap <a-'>    :AsyncTask run<cr>

    " Write only changed all-buffer
    nnoremap ;w   :wall<cr>
    vnoremap ;w   :<c-U>wall<cr>


    if HasPlug('vim-motion')
        "let g:vim_motion_maps = 1
        nnoremap <a-,>     <Plug>_JumpPrevIndent
        nnoremap <a-.>     <Plug>_JumpNextIndent
        vnoremap <a-.>     <Plug>_JumpPrevIndent
        vnoremap <a-,>     <Plug>_JumpNextIndent
        onoremap <a-,>     <Plug>_JumpPrevIndent
        onoremap <a-.>     <Plug>_JumpNextIndent
    endif


    " Paste in insert mode: don't know who reset this, set again here
    inoremap <silent> <a-i> <c-r>"
endif


if g:vim_confi_option.enable_map_basic
    " https://vimways.org/2018/for-mappings-and-a-tutorial/
    "" Stop that stupid window from popping up
    "map q: :q

    " map <leader><Esc> :AnsiEsc<cr>
    nnoremap <C-c> <silent> <C-c>
    "nnoremap <buffer> <Enter> <C-W><Enter>     | " vimwiki use this to create a new link

    " Remap to fzf sink to quickfix
    " Ctrl-q: if-window exit all, if-terminal exit terminal
    "nnoremap <C-q>         :"Exit all            "<c-U>qa!<cr>
    nnoremap <leader>q      :"Exit all            "<c-U>qa<cr>
    vnoremap <leader>q                            :<c-U>qa<cr>

    "" Esc too far, use Ctrl+Enter as alternative
    "inoremap <a-CR> <Esc>
    "vnoremap <a-CR> <Esc>

    " Adjust viewports to the same size
    "map <leader>= <C-w>=

    inoremap <S-Tab> <C-V><Tab>

    noremap  <silent> j  gj
    vnoremap <silent> j  gj
    noremap  <silent> k  gk
    vnoremap <silent> k  gk
    vnoremap <silent> >  >gv
    vnoremap <silent> <  <gv

    " " H/L - jump to start/end of line (^/$)
    " " J/K - jump down/up half a screen (C-d/C-u)
    " nnoremap H ^
    " nnoremap L $
    " nnoremap gj <C-d>
    " nnoremap gk <C-u>

    " https://www.reddit.com/r/vim/comments/53bpb4/alternatives_to_esc/
    " https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping
    " @ver1: using jj, but how about the select-mode, the 'j' as move
    "noremap   jj <Esc>
    "noremap!  jj <Esc>
    " @ver2: want input ';' at the end of current line, then exit by hit two ';;', which will auto remove the first wanted ';'
    "nnoremap ;; <Esc>
    "inoremap ;; <Esc>
    "vnoremap ;; <Esc>
    " @ver3: confuse it's insert mode or normal mode, or if enter multiple i
    "noremap   ii <Esc>
    "noremap!  ii <Esc>
    " @ver4:
    "inoremap ,, <Esc>`^
    "onoremap ,, <Esc>`^
    "vnoremap ,, <Esc>`<
    "cnoremap ,, <c-u><Esc>
    " @ver5: save & exit insert-mode
    "inoremap jj <c-o>:w<cr><ESC>
    " @ver6: save & exit insert-mode

    "nnoremap <leader>w      :"Save/write file        "<c-U>w<cr><ESC>
    "nnoremap <leader>ww     :"Save/write file        "<c-U>w<cr><ESC>

    " Save in insert mode, comment out it for anoy when you input the letter 'k'.
    "inoremap kk <c-o>:w<cr>

    "nnoremap <silent> ;ww :w!<cr>
    " Temporarily turns off search highlighting
    nnoremap <silent> <Return> :nohls<Return><Return>
    " Count the number of occurrences of the last search pattern
    nnoremap  ;#   :"Count search-pattern           "<c-U><c-U>%s///gn<cr>
    nnoremap  ;^   :"(*)Popup search-pattern           "<c-U>g//p<cr>
    nnoremap  ;*   :"(*)Quickfix-sink search-pattern   "<c-U>cexpr []<cr> <bar>:<c-u>g//caddexpr expand("%") ..":" ..line(".") ..":0:" . getline(".")<cr> <bar>:copen<cr>

    "" Disable F1 built-in help key by: re-replace last search
    "map <F1> :<c-u>%s///gc<cr>
    nmap <F1>           :"(*)Continue replace all search-pattern    "<c-U>%s//<C-R>"/gc<cr>
    nmap ;.             :"(*)Continue replace all search-pattern    "<c-U>%s//<C-R>"/gc<cr>

    " Lazy macro repeat
    nmap <leader>.      @@
endif

if g:vim_confi_option.enable_map_useful

    " https://stackoverflow.com/questions/18175647/jump-with-ctrl-i-doesnt-work-in-my-macvim-but-ctrl-o-works
    " Please don't map tab, since it's same as c-i, and will overwrite our c-i.
    ""Tab: Toggle folds
    "    "nnoremap <Tab> za
    "    nnoremap <Tab>   zR
    "    nnoremap <S-Tab> zM
    "? if c, map to file header/source
    "au FileType c,cpp nnoremap <silent> <Tab>  :call JumpToCorrespondingFile()<cr>
    au FileType c,cpp nnoremap <silent> <leader>fa  :"(*)Toggle source/header           "<c-U>call JumpToCorrespondingFile()<cr>

    " Jump to a file whose extension corresponds to the extension of the current
    " file. The `tags' file, created with:
    " $ ctags --extra=+f -R .
    " has to be present in the current directory.
    function! JumpToCorrespondingFile()
        let l:extensions = { 'c': 'h', 'h': 'c', 'cpp': 'hpp', 'hpp': 'cpp' }
        let l:fe = expand('%:e')
        if has_key(l:extensions, l:fe)
            execute ':tag ' . expand('%:t:r') . '.' . l:extensions[l:fe]
        endif
    endfunct


    " similar to gv, reselects the last changed block
    " highlight last inserted text
    nnoremap gV `[v`]

    " Anoy try to delete some character but format it not in insert mode
    " press <backspace> to switch to the "alternate file"
    "nnoremap <BS> <C-^>

    " Reformat whole file
    "nnoremap g= gg=G``

    " Move to beginning/end of line
    nnoremap B ^
    nnoremap E $

    augroup HwbasicFtMap
        autocmd!
        autocmd FileType help,man,floaterm     nnoremap <buffer> <C-[> :q<cr>
        autocmd FileType help,man,floaterm     nnoremap <buffer> q     :q<cr>
        autocmd FileType qf                    nnoremap <buffer> <c-o> :colder<cr>
        autocmd FileType qf                    nnoremap <buffer> <c-i> :cnewer<cr>
    augroup END


    " Finger candy: same-bind a-, c-, leader-
    " Alt+HJKL   move around tmux pane
    " Ctrl+HJKL  move around vim-window/tmux-pane
    "
    " nnoremap <silent> <a-o>   :colder<cr>
    " nnoremap <silent> <a-i>   :cnewer<cr>

    nnoremap <silent> <leader>o <C-o>
    nnoremap <silent> <leader>i <C-i>

    " lsp-goto declare
    "nnoremap <silent> <leader>; ;fd

    " https://stackoverflow.com/questions/34018825/jump-to-tag-ctrl-stopped-working
    "   Sometimes <C-]> goto not work, maybe iskeyword changed, check by:
    "     :verbose setlocal iskeyword?
    "   So here add substitute <leader>; to jump tag
    nnoremap <silent> <leader>;     :"(navigate)Jump Tag           "<c-U>call VimMotionTag()<cr>
    "inoremap <silent> <leader>[ <C-[>

    " Take as map hole
    "nnoremap <silent> <leader>,,,

    " Substitue for MaboXterm diable <c-h>
    nnoremap <leader>h      <c-w>h
    nnoremap <leader>j      <c-w>j
    nnoremap <leader>k      <c-w>k
    nnoremap <leader>l      <c-w>l

    " Replace by vim-tmux-navigator
    "nnoremap <c-h> <c-w>h
    "nnoremap <c-j> <c-w>j
    "nnoremap <c-k> <c-w>k
    "nnoremap <c-l> <c-w>l

    " Go to end of parenthesis/brackets/quotes
    " <C-o> is used to issue a normal mode command without leaving insert mode.
    inoremap <C-e>      <C-o>A

    " Navigate quickfix
    nnoremap <silent> <c-n> :"(navigate)Next quickfix            "<c-U>cn<cr>
    nnoremap <silent> <c-p> :"(navigate)Previous quickfix        "<c-U>cp<cr>
    nnoremap <silent> <a-n> :"(navigate)Next locallist           "<c-U>lne<cr>
    nnoremap <silent> <a-p> :"(navigate)Previous locallist       "<c-U>lp<cr>

    " Navigate locallist
    " nnoremap <silent> <leader>n     :"(navigate)Next locallist           "<c-U>lne<cr>
    " nnoremap <silent> <leader>p     :"(navigate)Previous locallist       "<c-U>lp<cr>


    " nvim.terminal map {{{2
    if has("nvim")
        let b:terminal_scrollback_buffer_size = 2000
        let g:terminal_scrollback_buffer_size = 2000

        " Terminal exit-to-text-mode, i: enter interact-mode
        " conflict with gdb mode
        "   tnoremap <Esc> <C-\><C-n>
        tnoremap <c-o>     <C-\><C-n>

        "tnoremap <leader>h <C-\><C-n><c-w>h
        "tnoremap <leader>j <C-\><C-n><c-w>j
        "tnoremap <leader>k <C-\><C-n><c-w>k
        "tnoremap <leader>l <C-\><C-n><c-w>l

        tnoremap <c-h> <C-\><C-n><C-w>h
        tnoremap <c-j> <C-\><C-n><C-w>j
        tnoremap <c-k> <C-\><C-n><C-w>k
        tnoremap <c-l> <C-\><C-n><C-w>l
    endif


    " Automatically jump to end of text you pasted
    "vnoremap <silent> y y`]
    "vnoremap <silent> p p`]
    "vnoremap <silent> p "_dP`]
    nnoremap <silent> p p`]

    " now it is possible to paste many times over selected text
    "xnoremap p "_dp
    xnoremap <expr> p 'pgv"'.v:register.'y'


    " remove space from emptyline
    "nnoremap <leader>v<space> :%s/^\s\s*$//<CR>
    "vnoremap <leader>v<space> :s/^\s\s*$//<cr>


    " For global replace
    nnoremap <leader>vR gD:"Replace all              "<c-U>%s/<C-R>///g<left><left>
    "vnoremap <leader>vr ""y:%s/<C-R>=escape(@", '/\')<CR>/<C-R>=escape(@", '/\')<CR>/g<Left><Left>
endif


if HasPlug('vim-table-mode')
    nnoremap  ;vt   :TableModeToggle<cr>
endif


if CheckPlug('vim-go', 1)
    au FileType go nmap <leader>gr <Plug>(go-run)
    au FileType go nmap <leader>gb <Plug>(go-build)
    au FileType go nmap <leader>gt <Plug>(go-test)
    au FileType go nmap <leader>gc <Plug>(go-coverage)
    au FileType go nmap <leader>gd <Plug>(go-doc)<Paste>
    au FileType go nmap <leader>gi <Plug>(go-info)
    au FileType go nmap <leader>ge <Plug>(go-rename)
    au FileType go nmap <leader>gg <Plug>(go-def-vertical)
endif


if CheckPlug('vim-yoink', 1)
    "nmap <c-n> <plug>(YoinkPostPasteSwapBack)
    "nmap <c-p> <plug>(YoinkPostPasteSwapForward)

    nmap qy :Yanks<cr>

    nmap p <plug>(YoinkPaste_p)
    nmap P <plug>(YoinkPaste_P)
    nmap [y <plug>(YoinkRotateBack)
    nmap ]y <plug>(YoinkRotateForward)

    nmap y <plug>(YoinkYankPreserveCursorPosition)
    vmap y <plug>(YoinkYankPreserveCursorPosition)
    xmap y <plug>(YoinkYankPreserveCursorPosition)
endif


if CheckPlug('vim-gutentags', 1)
    if !CheckPlug('fzf-cscope.vim', 1)
        " gutentags_plus
        let g:fzf_cscope_map = 0
        let g:gutentags_plus_nomap = 1
        noremap <silent> <leader>fs     :GscopeFind s <C-R><C-W><cr>
        noremap <silent> <leader>fg     :GscopeFind g <C-R><C-W><cr>
        noremap <silent> <leader>fc     :GscopeFind c <C-R><C-W><cr>
        noremap <silent> <leader>ft     :GscopeFind t <C-R><C-W><cr>
        noremap <silent> <leader>fe     :GscopeFind e <C-R><C-W><cr>
        "noremap <silent> <leader>ff    :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fi     :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fd     :GscopeFind d <C-R><C-W><cr>
        noremap <silent> <leader>fa     :GscopeFind a <C-R><C-W><cr>

        "let g:gutentags_plus_nomap = 1
        "noremap <silent> <leader>fs    :cs find s <C-R><C-W><cr>
        "noremap <silent> <leader>fg    :cs find g <C-R><C-W><cr>
        "noremap <silent> <leader>fc    :cs find c <C-R><C-W><cr>
        "noremap <silent> <leader>ft    :cs find t <C-R><C-W><cr>
        "noremap <silent> <leader>fe    :cs find e <C-R><C-W><cr>
        ""noremap <silent> <leader>ff   :cs find f <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fi    :cs find i <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fd    :cs find d <C-R><C-W><cr>
        "noremap <silent> <leader>fa    :cs find a <C-R><C-W><cr>
    endif
endif


if CheckPlug('vim-emacscommandline', 1)
    "let g:EmacsCommandLine[Command]Disable = 1
    "let g:EmacsCommandLineBeginningOfLineMap = ['<C-B>', '<C-A>']

    "let g:EmacsCommandLineBeginningOfLineMap
    "let g:EmacsCommandLineEndOfLineMap
    let g:EmacsCommandLineBackwardCharDisable = 1
    let g:EmacsCommandLineForwardCharDisable = 1
    let g:EmacsCommandLineBackwardWordMap = ['<C-B>']
    let g:EmacsCommandLineForwardWordMap = ['<C-F>']
    let g:EmacsCommandLineDeleteCharDisable = 1
    let g:EmacsCommandLineBackwardDeleteCharDisable = 1
    "let g:EmacsCommandLineKillLineMap
    "let g:EmacsCommandLineBackwardKillLineMap
    let g:EmacsCommandLineKillWordMap = ['<C-D>']
    let g:EmacsCommandLineBackwardKillWordMap = '<C-W>'
    "let g:EmacsCommandLineDeleteBackwardsToWhiteSpaceMap
    "let g:EmacsCommandLineOlderMatchingCommandLineMap
    "let g:EmacsCommandLineNewerMatchingCommandLineMap
    "let g:EmacsCommandLineFirstLineInHistoryMap
    "let g:EmacsCommandLineLastLineInHistoryMap
    "let g:EmacsCommandLineSearchCommandLineMap
    "let g:EmacsCommandLineTransposeCharMap
    "let g:EmacsCommandLineYankMap
    "let g:EmacsCommandLineUndoMap
    "let g:EmacsCommandLineAbortCommandMap
    "let g:EmacsCommandLineToggleExternalCommandMap
endif


if HasPlug('coc.nvim')
    " using coc.vim/ale with ccls-cache which base on clang
    nnoremap  <silent>  ;fd <Plug>(coc-definition)
    nnoremap  <silent>  ;fs <Plug>(coc-references)
    "nnoremap <silent>  ;fD <Plug>(coc-type-definition)
    "nnoremap <silent>  ;fi <Plug>(coc-implementation)
    nnoremap <silent>   ;fH call CocAction('doHover')
    nnoremap <silent>   ;fr <Plug>(coc-rename)
    nnoremap <silent>   ;fp <Plug>(coc-diagnostic-next)
    nnoremap <silent>   ;fn <Plug>(coc-diagnostic-prev)

    "autocmd CursorHold * silent call CocActionAsync('highlight')
endif


if CheckPlug('ale.vim', 1)
    nnoremap  <silent>   ;fd :ALEGoToDefinition<cr>
    nnoremap  <silent>   ;fs :ALEFindReferences<cr>
    "nnoremap <silent>   ;fS :ALESymbolSearch<cr>
    nnoremap  <silent>   ;fh :ALEHover<cr>
    nnoremap  <silent>   ;fn <Plug>(ale_next_wrap)
    nnoremap  <silent>   ;fp <Plug>(ale_previous_wrap)
endif


if CheckPlug('vim-prettier', 1)
    nnoremap <leader>cf <Plug>(Prettier)
endif


if CheckPlug('nnn.vim', 1) | " {{{1
    " Disable default mappings
    let g:nnn#set_default_mappings = 0

    " Then set your own
    "nnoremap <silent> <leader>ve :NnnPicker<CR>

    " Or override
    " Start nnn in the current file's directory
    "nnoremap <leader>n :NnnPicker '%:p:h'<CR>
endif


if CheckPlug('vim-qf', 1)
    ""nnoremap <leader>mn :QFAddNote note:
    "nnoremap <leader>ms :SaveList
    "nnoremap <leader>mS :SaveListAdd
    "nnoremap <leader>ml :LoadList
    "nnoremap <leader>mL :LoadListAdd
    "nnoremap <leader>mo :copen<cr>
    "nnoremap <leader>mn :cnewer<cr>
    "nnoremap <leader>mp :colder<cr>

    "nnoremap <leader>md :Doline
    "nnoremap <leader>mx :RemoveList
    "nnoremap <leader>mh :ListLists<cr>
    ""nnoremap <leader>mk :Keep
    "nnoremap <leader>mF :Reject
endif


if CheckPlug('tabularize', 1)
    if exists(":Tabularize")
        "nnoremap <leader>t= :Tabularize /=<CR>
        "vnoremap <leader>t= :Tabularize /=<CR>
        "nnoremap <leader>t: :Tabularize /:\zs<CR>
        "vnoremap <leader>t: :Tabularize /:\zs<CR>
    endif
endif


if CheckPlug('vim-tmux-runner', 1)
    "nnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('n')"<CR>
    "vnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('v')"<CR>
    "nnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('n')"<CR>
    "vnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('v')"<CR>

    "nnoremap <silent> <leader>tf :exec "VtrLoad" \| exec "VtrSendFile"<CR>
    "nnoremap <silent> <leader>tl :exec "VtrLoad" \| exec "VtrSendLinesToRunner"<CR>
    "nnoremap <silent> <leader>tj :exec "VtrLoad" \| exec "VtrBufferPasteHere"<CR>
    "nnoremap <silent> <leader>tg :exec "VtrLoad" \| exec "VtrFlushCommand"<CR>
    "nnoremap <silent> <leader>tc :exec "VtrLoad" \| exec "VtrClearRunner"<CR>
endif


if HasPlug('vimConfig')
    nnoremap <silent> ;1     1gt
    nnoremap <silent> ;2     2gt
    nnoremap <silent> ;3     3gt
    nnoremap <silent> ;4     4gt
    nnoremap <silent> ;5     5gt
    nnoremap <silent> ;6     6gt
    nnoremap <silent> ;7     7gt
    nnoremap <silent> ;8     8gt
    nnoremap <silent> ;9     9gt
    nnoremap <silent> ;0     10gt

    "nnoremap <silent> ;tt     :$tab tag <c-r>=utils#GetSelected('n')<cr><cr>
    nnoremap <silent> ;tt      :"(*)Tag word into new tab          theCommand"<c-U>$tab split<cr>:exec("silent! tag "..utils#GetSelected('n'))<cr>
    vnoremap <silent> ;tt      :"(*)Tag word into new tab          theCommand"<c-U>$tab split<cr>:exec("silent! tag "..utils#GetSelected('v'))<cr>
endif

if CheckPlug('taboo.vim', 1)
    "nnoremap <silent> ;tt   :TabooOpen new-tab<CR>
    nnoremap <silent> ;tc   :tabclose<CR>
    nnoremap          ;tr   :TabooRename <C-R>=expand('%:t:r')<CR>
elseif CheckPlug('vim-tabber', 1)
    "set tabline=%!tabber#TabLine()
    "
    "let g:tabber_wrap_when_shifting = 1
    "let g:tabber_predefined_labels = { 1: 'code', 2: 'config', 3: 'patch' }
    let g:tabber_filename_style = 'filename'    " README.md

    "let g:tabber_divider_style = 'compatible'
    let g:tabber_divider_style = 'unicode'
    "let g:tabber_divider_style = 'fancy'

    "nnoremap <silent> ;tt   :TabberNew<CR>
    "nnoremap          ;tc   :tabclose<CR>
    "nnoremap          ;tr   :TabberLabel <C-R>=expand('%:t:r')<CR>
    "nnoremap          ;tm   :TabberMove<CR>
    "nnoremap          ;th   :TabberShiftLeft<CR>
    "nnoremap          ;tl   :TabberShiftRight<CR>
    "nnoremap          ;ts   :TabberSwap<CR>
    "nnoremap <silent> ;aa   :TabberSelectLastActive<CR>
endif


if CheckPlug('vim-youdao-translater', 1)
    vnoremap <silent> ;ww :<C-u>Ydv<CR>
    nnoremap <silent> ;ww :<C-u>Ydc<CR>
    "noremap <leader>yd :<C-u>Yde<CR>
elseif executable('~/tools/dict')
    nmap ;ww :R! ~/tools/dict <C-R>=expand('<cword>') <cr>
endif


if CheckPlug('vim-lookup', 1)
    autocmd FileType vim nnoremap <buffer><silent> <c-]>  :call lookup#lookup()<cr>
endif


if CheckPlug('w3m.vim', 1)
    if WINDOWS()
        let $PATH = $PATH . ';c:\Programs\FireFox1.5'
    endif

    " Evoke a web browser
    function! W3mBrowser()
        let line0 = getline(".")
        let aUrl = matchstr(line0, 'http[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')

        if empty(aUrl)
            let aUrl = matchstr(line0, 'ftp[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')
        endif

        if empty(aUrl)
            let aUrl = matchstr(line0, 'file[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')
        endif

        let aUrl = escape(aUrl, "#?&;|%")
        "return printf("W3mSplit %s", aUrl)
        exec "W3mSplit ". aUrl
    endfunction
endif


if CheckPlug('vim-which-key', 1) | " {{{1
    "noremap <silent> ;?            :<c-u>WhichKey ';'<cr>
    "noremap <silent> <leader>?     :<c-u>WhichKey '<leader>'<cr>
endif


if CheckPlug('vim-argwrap', 1) | " {{{1
    nnoremap <silent> <leader>fa :"(*)Toggle source/header         theCommand"<c-U>ArgWrap<CR>
endif

" Help {{{1
"=========================================================
" <Ctl-*>       Jump vim-windows/tmux-panes [hjkl]
" <Alt-*>       Jump tmux-panes [hjkl], View toggle
" <leader>*     View open
" z*            Show info
" q*            List
" ;*            View open 2
"
" Donnot map:
" <space>*      Cause the input <space> not work
" ;*            Cause 'f*' repeat mode fail, maybe plugin 'clever-f.vim' can release the key ';'
"=========================================================

" Key unmap plugin {{{1
    if HasPlug('DrawIt')
        " release map <leader>w, <leader>r
        unmap <leader>swp
        unmap <leader>rwp
    endif

    if HasPlug('DrawIt')
        unmap <leader>g
    endif


" Key maps {{{1
    " view {{{2
        if HasPlug('vim-maximizer')
            nnoremap <silent> <leader>vw     :"(view)maximize Windows      theCommand"<c-U>MaximizerToggle<cr>
        elseif HasPlug('maximize')
            nnoremap <silent> <leader>vw     :"(view)maximize Windows      theCommand"<c-U>MaximizeWindow<cr>
        else
            nnoremap <silent> <leader>vw     :"(view)maximize Windows      theCommand"<c-U>ZoomToggle<cr>

            " Zoom / Restore window.
            function! s:ZoomToggle() abort
                if exists('t:zoomed') && t:zoomed
                    execute t:zoom_winrestcmd
                    let t:zoomed = 0
                else
                    let t:zoom_winrestcmd = winrestcmd()
                    resize
                    vertical resize
                    let t:zoomed = 1
                endif
            endfunction

            command! ZoomToggle call s:ZoomToggle()
        endif

    " Sugar {{{2
        " bookmark/color
        if HasPlug('vim-mark')
            nnoremap <silent> <leader>mm  :"(color)Toggle Colorize word        theCommand"<c-U>silent! call mark#MarkCurrentWord(expand('<cword>'))<cr>
            "vnoremap <silent> <leader>mm  :<c-u>silent! call mark#GetVisualSelection()<cr>
            nnoremap <silent> <leader>mx  :"(color)Clear all colorize word   theCommand"<c-U>silent! call mark#ClearAll()<cr>
        endif


        " Suppose record macro in register `q`:
        "vnoremap <leader>mm  :normal @q
        if HasPlug('vim-macroscope')
            "nnoremap <leader>mr     :<c-U>Macroscope
            "nnoremap <leader>mp     :<c-U>Macroplay<cr>
        endif


        if HasPlug('rainbow_parentheses.vim')
            nnoremap <silent> <leader>m[   :"Colorize brace     theCommand"<c-U>RainbowParentheses!!<cr>
        endif


    " File helper {{{2
        nnoremap <silent> <leader>sa     :"Save file as          theCommand"<c-U>FileSaveAs<cr>

        "[Cause command mode pause when press 'w', note:map](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
        "For when you forget to sudo.. Really Write the file.
        cmap <C-w> w !sudo tee % >/dev/null

        " Toggle source/header
        "nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>
        nnoremap <silent>  ;aa  :"(info)Toggle source/header   theCommand"<c-U>call CurtineIncSw()<cr>

        if HasPlug('vim-sleuth')
            nnoremap <leader>fd :"Auto detect indent   theCommand"<c-U>Sleuth<cr>
        elseif HasPlug('detectindent')
            nnoremap <leader>fd :"Auto detect indent   theCommand"<c-U>DetectIndent<cr>
        endif

        " Set log
        "nnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
        "vnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
        " Lint: -i ignore-error and continue, -s --silent --quiet

    " Format {{{2
        " Reserve to cscope/ctags
        " vnoremap <Leader>ff =<cr>
        " nnoremap <Leader>ff =<cr>

        "     Most UNIX-like programming environments offer generic tools for formatting text. These include fmt, fold, sed, perl, and par. 
        "     vnoremap qq c<C-R>=system('wc -c | perl -pe chomp', @")<CR><ESC>
        "autocmd FileType vimwiki vnoremap <leader>ff :!fmt -c -w 100 -u -s <cr>
        nnoremap <leader>cw     vip:"(*)Auto wrapline paragraph   theCommand"<c-U>'<,'>!fmt -c -w 100 -u -s <cr>
        vnoremap <leader>cw     :!fmt -c -w 100 -u -s <cr>

    " repl/execute {{{2
        "if mapcheck('<leader>ee', 'n') == ""
        "    "" execute file that I'm editing in Vi(m) and get output in split window
        "    "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
        "    "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
        "    "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

        "    silent! Shortcut! <space>ee    Tool compile & run
        "    nnoremap <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
        "    silent! Shortcut! <leader>eo    Tool View Result
        "    nnoremap <leader>eo :SCViewResult<CR>
        "endif

        "nnoremap <leader>el :VlogDisplay \| Messages \| VlogClear<CR><CR>


    " Copy/paste {{{2
        " " vp doesn't replace paste buffer
        " function! RestoreRegister()
        "     let @" = s:restore_reg
        "     let @+ = s:restore_reg | " sometime other plug use this register as paste-buffer
        "     return ''
        " endfunction
        " function! s:Repl()
        "     let s:restore_reg = @"
        "     return "p@=RestoreRegister()\<cr>"
        " endfunction
        " vnoremap <silent> <expr> p <sid>Repl()

        "" FIXME: Revert this f70be548
        "" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
        "map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

        " Yank from the cursor to the end of the line, to be consistent with C and D.
        nnoremap Y y$
        if HasPlug('vim-oscyank')
            let g:oscyank_max_length = 1000000
            "let g:oscyank_term = 'tmux'  " or 'screen', 'kitty', 'default'
            let g:oscyank_term = 'tmux'
            vnoremap Y :OSCYank<CR>
            "vnoremap Y :call YankOSC52(getreg('+'))<CR>
        endif


        vnoremap <silent> <leader>yy    :"Copy text to tmpfile       theCommand"<c-U>call utils#GetSelected('v', "/tmp/vim.yank")<CR>
        nnoremap <silent> <leader>yy    :"Copy text to tmpfile       theCommand"<c-U>call vimuxscript#Copy() <CR>
        nnoremap <silent> <leader>yp    :"Paste text from tmpfile    theCommand"<c-U>r! cat /tmp/vim.yank<CR>

        " Map `*`, `&` same to avoid ft=git conflict:
        xnoremap *      :<c-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
        xnoremap &      :<c-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
        xnoremap #      :<c-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
        vnoremap // y   :vim /\<<C-R>"\C/gj %


    " Text/Motion {{{2
        nnoremap <leader>ci :"(txt)Capitalize word          theCommand"<c-U>CapitalizeWord<CR>
        nnoremap <leader>cu :"(txt)UPPERCASE word           theCommand"<c-U>UppercaseWord<CR>
        nnoremap <leader>cl :"(txt)lowercase word           theCommand"<c-U>LowercaseWord<CR>
        nnoremap <leader>c<space> :"(txt)Just one space     theCommand"<c-U>JustOneInnerSpace<CR>
        nnoremap <leader>ct :"(txt)Trim tail space          theCommand"<c-U>RemoveTrailingSpaces<CR>
        nnoremap <leader>cd :"(txt)Delete search-pattern    theCommand"<c-U>g/<c-r><C-w>/ norm dd
        vnoremap <leader>cd                                          y:<c-U>g/<c-r>"/ norm dd

    " Info {{{2
        " Show current color's name: iS show syntax[vim-scriptease]
        nnoremap <leader>aS  :"(info)Show syntax             theCommand"<c-U>echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")<cr>
        nnoremap <leader>as  :"(info)Show syntax(scriptease) theCommand"<c-U>echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")<cr>
        nnoremap <leader>af  :"(info)File                    theCommand"<c-U>echo expand('%:p')<cr> \| call setreg('+', expand('%:p'))<cr>

    " Git/grep {{{2
        " Search {{{3
            " Search-mode: hit cs, replace first match, and hit <Esc>
            "   then hit n to review and replace
            vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
                  \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
            onoremap s :normal vs<CR>


" Helper fucntion {{{1
" Commands {{{2
    " remove trailing spaces
    " make a separate plugin for the commands
    command! RemoveTrailingSpaces :silent! %s/\v(\s+$)|(\r+$)//g<bar>
                \:exe 'normal ``'<bar>
                \:echo 'Remove trailing spaces and ^Ms.'

    command! JustOneInnerSpace :let pos=getpos('.')<bar>
                \:silent! s/\S\+\zs\s\+/ /g<bar>
                \:silent! s/\s$//<bar>
                \:call setpos('.', pos)<bar>
                \:nohl<bar>
                \:echo 'Just one space'

    command! CapitalizeWord :let pos=getpos('.')<bar>
                \:exe 'normal guiw~'<bar>
                \:call setpos('.', pos)

    command! UppercaseWord :let pos=getpos('.')<bar>
                \:exe 'normal gUiw'<bar>
                \:call setpos('.', pos)

    command! LowercaseWord :let pos=getpos('.')<bar>
                \:exe 'normal guiw'<bar>
                \:call setpos('.', pos)

" Functions {{{2
    function! FileOpenDoc()
        let tmuxWname = trim(system("tmux display-message -p '#W'"))
        exec 'FilePre ~/work/'. tmuxWname. "/doc/"
    endfunction

    function! s:FileSaveAs(fname)
        let cfname = expand('%:t')
        if (cfname == 'tmux.log' && !empty(a:fname))
            let tmuxWname = trim(system("tmux display-message -p '#W'"))
            let cmdstr = "w! ~/work/". tmuxWname. "/doc/". a:fname
            "echomsg cmdstr
            exec cmdstr
        else
            " write only when the file changed
            update
        endif
    endfunction
    command! -nargs=? FileSaveAs call <SID>FileSaveAs( '<args>' )


