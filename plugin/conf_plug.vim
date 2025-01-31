if exists('g:loaded_conf_plug') || &compatible
    finish
endif
let g:loaded_conf_plug = 1
let s:base_dir = resolve(expand("<sfile>:p:h"))
silent! let s:log = logger#getLogger(expand('<sfile>:t'))

lua require('vimConfig').setup()


if HasPlug('syntastic') | " {{{1
    let g:syntastic_vim_checkers = ['vint']
    let g:syntastic_vim_vint_exe = 'LC_CTYPE=UTF-8 vint'

    "let g:syntastic_always_populate_loc_list = 1
    "let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0
endif


if HasPlug('vim-unimpaired') | " {{{1
    let g:unimpaired_listchar = 0
    noremap <F12> <Plug>(SwitchListchars)
endif


if HasPlug('ctrlp.vim') | " {{{1
    if exists("g:ctrl_user_command") | unlet g:ctrlp_user_command | endif
endif


if HasPlug('vimfiler.vim') | " {{{1
    let g:vimfiler_as_default_explorer = 1
endif


if HasPlug('vcscommand.vim') | " {{{1
    "let g:signify_vcs_list = [ 'git', 'svn' ]
endif

if HasPlug('vim-oscyank') | " {{{1
    "let g:oscyank_term = 'default'
endif


if HasPlug('vim-template') | " {{{1
    let tDir = fnamemodify(expand('<sfile>:p'), ':h') .. '/../templates'
    let g:templates_directory = tDir
    let g:username = "Wilson"
    let g:email = "wilson.yuu@gmail.com"
    let g:templates_user_variables = [
                \   ['FULLPATH', 'GetFullPath'],
                \ ]

    function! GetFullPath()
        return expand('%:p')
    endfunction

    nnoremap <leader>et      :"(Snippet)Template        theCommand"<c-U>TemplateHere .
endif


if HasPlug('goyo.vim') | " {{{1
    let g:goyo_width = 120
    let g:goyo_height = 20

    nnoremap <silent>   ;vc         :"(mode)Goyo reader/present         "<c-U>Goyo<CR>

    " Markdown configuration
    augroup MarkdownConfiguration
        autocmd BufNewFile,BufRead *.markdown Goyo 80
        autocmd BufNewFile,BufRead *.markdown set wrap
        autocmd BufNewFile,BufRead *.markdown set linebreak breakindent
        autocmd BufNewFile,BufRead *.markdown nnoremap j gj
        autocmd BufNewFile,BufRead *.markdown nnoremap k gk
    augroup END
endif


if HasPlug('presenting.vim') | " {{{1
    let g:presenting_figlets = 0
    let g:presenting_font_large = 'doh'
    let g:presenting_font_small = 'univers'
    nnoremap <silent>   ;vP     :"(mode)Presenting PPT      "<c-U>PresentingStart<cr>

    "au FileType markdown let b:presenting_slide_separator = '\v(^|\n)\~{4,}'
endif


if HasPlug('vim-floaterm-repl') | " {{{1
    autocmd FileType markdown    nnoremap <buffer>  ;ee :"(repl)Run me        "<c-U>FloatermRepl<cr>
endif


if HasPlug('vim-evalvim') | " {{{1
    autocmd FileType vim    nmap <buffer> <leader>ee <Plug>(EvalVimLine)
    autocmd FileType vim    vmap <buffer> <leader>ee <Plug>(EvalVim)
elseif HasPlug('vim-eval') | " {{{1
    autocmd FileType vim    nmap <buffer> <leader>ee <Plug>eval_viml
    autocmd FileType vim    vmap <buffer> <leader>ee <Plug>eval_viml_region
elseif HasPlug('vim-basic') | " {{{1
    let g:vim_basic_map = get(g:, 'vim_basic_map', 1)

    " Don't why the this map cause VimL execute '10new' error, and VimL get Select not correct
    "autocmd FileType vim    vmap <buffer> <leader>ee <Plug>(EvalVim)
    "
    autocmd FileType vim    nnoremap <buffer> <leader>ee :"(repl)Run me        "<c-U>call hw#eval#repl('n')<cr>
    autocmd FileType vim    vnoremap <buffer> <leader>ee :"(repl)Run me        "<c-U>call hw#eval#repl('v')<cr>
    autocmd FileType log    nnoremap <buffer> <leader>ee :"(repl)Run me        "<c-U>call vimuxscript#CallRegion(1)<cr>

    "nnoremap <silent> ;ee     :"(repl)Run me        "<c-U>call vimuxscript#CallRegion(1)<cr>
    "nnoremap <silent> ;ss     :"(repl)Run me        "<c-U>call vimuxscript#Stop()<cr>
endif


if HasPlug('vim-floaterm') | " {{{1
    let g:floaterm_autoinsert = 1
    let g:floaterm_shell = '/bin/bash'

    let s:compile_run_swap = ''
    fun! s:compile_run(mode)
        let l:command=':FloatermNew --name=repl --wintype=split --position=bottom --autoclose=0 --height=0.4 --width=0.6 --title=Repl-'..&filetype

        " if s:compile_run_swap == 1
        "     let s:compile_run_swap = 0
        " else
        "     let s:compile_run_swap = 1
        " endif

        " Script like code, don't need compile, then we can run it directly
        let l:fname_org = expand('%')
        if a:mode == 'v'
            let l:fname = expand('%')
            let l:fname_bin = expand('%:r')
            let l:fpath_bin = "./" .. expand('%:r')
        else
            let l:fname = "/tmp/vim.out".. s:compile_run_swap
            let l:fname_bin = "/tmp/vim.out".. s:compile_run_swap
            let l:fpath_bin = "/tmp/vim.out".. s:compile_run_swap
        endif

        if &ft=='c'
            " If from outside of dir, should use absolute path, otherwise use relative path
            "   so here if bin-path fail, then try absolute path
            let l:command = l:command. printf("  gcc -pthread -lrt -g -O0 -finstrument-functions -fms-extensions -o %s %s && %s", l:fname_bin, l:fname_org, l:fpath_bin )
        elseif &ft=='cpp'
            " If from outside of dir, should use absolute path, otherwise use relative path
            "   so here if bin-path fail, then try absolute path
            let l:command = l:command. printf("  g++ -pthread -lrt -g -O0 -finstrument-functions -fms-extensions -o %s %s && %s", l:fname_bin, l:fname_org, l:fpath_bin )
        elseif &ft=='rust'
            if a:mode == 'v'
                " cargo test --test test_filename_without_extension
                let l:fname_bin = fnamemodify(l:fname_bin, ':t')
                let l:command = l:command. printf("  cargo test '%s::test::' -- --nocapture", l:fname_bin)
            else
                let l:command = l:command. printf("  rust-script %s", l:fname_org)
            endif
        elseif &ft=='java'
            let l:command = l:command. printf("  java %s", l:fname_org)
        elseif &ft=='javascript'
            let l:command = l:command. printf("  node %s", l:fname_org)
        elseif &ft=='python'
            let l:command = l:command. printf("  python %s", l:fname_org)
        elseif &ft=='tcl'
            let l:command = l:command. printf("  expect %s", l:fname_org)
        elseif &ft=='awk'
            let l:command = l:command. printf("  LC_ALL=C awk -f %s", l:fname_org)
        elseif &ft=='sh'
            let l:command = l:command. printf("  LC_ALL=C bash %s", l:fname_org)
        elseif &ft=='markdown'
            silent! execute "!rm rm -fr ".. l:fname_bin
            silent! execute "AsyncStop!"
            let l:command = printf("!pandoc -f markdown --standalone --to man %s -o %s", l:fname_org, l:fname_bin)
            silent! execute l:command

            let l:command = printf("  Snman %s", l:fname_bin)
        elseif &ft=='nroff'
            let l:command = printf("  Snman %s", l:fname_org)
        else
            echomsg "Not support filetype, but can reference 'vimConfig::compile_run()' to append it."
            return
        endif

        echomsg "Debug: ". l:command
        silent execute l:command
    endfun

    " Function to check if the current word under the cursor is a word
    fun! s:isCurrentWordAWord(word)
        let word_pattern = '^\w\+$'
        if match(a:word, word_pattern) != -1
            return 1
        endif
        return 0
    endfun

    fun! s:isGitRepo() abort
        let l:output = system('git rev-parse --is-inside-work-tree 2>/dev/null')
        return v:shell_error == 0 && trim(l:output) == 'true'
    endfun

    fun! s:isGitSHA(word) abort
        return a:word =~# '\v^[0-9a-f]{40}$'
    endfun

    " Check if the cursor is on a word character
    fun! s:getManWord()
        " try a loose mode: a word include alphanumeric or underscore or . or -
        if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\v\w|[.-]'
            let saved_iskeyword = &iskeyword
            for key in [2, 1, 0]
                let &iskeyword = saved_iskeyword
                if key == 2
                    set iskeyword+=.,-
                elseif key == 1
                    set iskeyword+=-
                endif
                let theWord = expand('<cword>')

                " Check is git-SHA
                if theWord =~# '\v^[0-9a-f]{7,40}$'
                    return ['Git', theWord]
                endif

                " Check man
                let checkExist = "man -w ".. theWord
                call system(checkExist)
                if v:shell_error == 0
                    return ['Man', theWord]
                endif

                " Check tldr
                let checkExist = "tldr --list | grep -e '^".. theWord .. "$'"
                call system(checkExist)
                if v:shell_error == 0
                    return ['Tldr', theWord]
                endif


                " Found fail
                let theWord = ''
            endfor
            let &iskeyword = saved_iskeyword
        endif

        " Back to strict word mode: only include alphanumeric or underscore
        if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\w'
            let theWord = expand('<cword>')
        else
            " If it is not, return an empty string
            let theWord = ''
        endif
        return ['none', theWord]
    endfun


    fun! s:man_show(mode)
        let l:cmd = ""
        let l:subcmd = ""
        let l:word = ""
        if a:mode == 'k'
            " [cmd, word]
            let words = s:getManWord()
            if empty(words[1])
                execute "Tldr"
                return
            else
                let l:word = words[1]
                if words[0] == "Man"
                    execute join(words, ' ')
                    return
                elseif words[0] == "Git"
                    call system(printf("git show --stat -p %s > /tmp/vim_a.diff", words[1]))
                    if v:shell_error == 0
                        let l:cmd = "PreviewFile /tmp/vim_a.diff"
                    endif
                endif
            endif
        endif


        if empty(l:cmd)
            let l:cmd=':FloatermNew --name=Help --wintype=split --position=bottom --autoclose=1 --height=0.4 --width=0.6 --title=Man-' .. &filetype

            if empty(l:word)
                let l:word = hw#misc#GetWord(a:mode)
            endif

            if empty(l:subcmd)
                let l:subcmd = printf("tldr %s -e", l:word)
            endif

            let l:cmd = l:cmd .. " " .. l:subcmd
        endif

        silent execute l:cmd
    endfun

    fun! s:toggle_terminal(mode)
        let l:command=':FloatermNew --name=Shell --wintype=split --position=bottom --autoclose=0 --height=0.4 --width=0.6 --title=Shell bash'
        silent execute l:command
    endfun

    command! -nargs=1 Tldr   execute 'FloatermNew --name=Help --wintype=split --position=bottom --autoclose=1 --height=0.4 --width=0.6 --title=Tldr tldr -e ' .. string(<q-args>)

    "autocmd FileType * nnoremap <buffer> <leader>ee :w<esc>:call <sid>compile_run()<cr>
    nnoremap <silent> <leader>ee      :"(*repl)Run me        "<c-U>w<esc>:call <sid>compile_run('n')<cr>
    vnoremap <silent> <leader>ee      :"(*repl)Run me        "<c-U>:'<,'>w! /tmp/vim.out<cr> \| :call <sid>compile_run('v')<cr>
    vnoremap <silent>        ;ee      :"(diag)Make buffer    "<c-U>make <C-R>=expand('%:t:r')<cr><cr><cr> \| :copen<cr> \| :wincmd p<cr>

    " Man (tldr)
    nnoremap <silent>         K      :"(Man)                 "<c-U>call <sid>man_show('k')<cr>
    nnoremap <silent> <leader>K      :"(Man)Tldr             "<c-U>call <sid>man_show('n')<cr>
    vnoremap <silent> <leader>K      :"(Man)Tldr             "<c-U>call <sid>man_show('v')<cr>

    if HasNoPlug('vim-floaterm-repl') && HasNoPlug('toggleterm.nvim')    | " {{{1
        nnoremap <silent> <C-\>          :"(Tool)Terminal        ":<c-U>call <sid>toggle_terminal('n')<cr>
        vnoremap <silent> <C-\>          :"(Tool)Terminal        ":<c-U>call <sid>toggle_terminal('v')<cr>
        inoremap <silent> <C-\>     <esc>:"(Tool)Terminal        ":<c-U>call <sid>toggle_terminal('v')<cr>
    endif
endif


if HasPlug('vim-slime') | " {{{1
    " for all buffers
    if executable('tmux')
        let g:slime_target = "tmux"
    endif

    if executable('nvr')
        nnoremap <silent> <leader>fo      :"(Terminal)RemoteOpen     ":<c-U>echomsg "Please execute 'nvr --remote' at other terminal first if failed!" \| !nvr -s --nostart --remote-tab %<cr>
    endif
elseif HasPlug('vimux') | " {{{1
    let g:VimuxUseNearest = v:true
    let g:VimuxCloseOnExit = 0
    let g:VimuxOrientation = "h"
    let g:VimuxAutoAction = ""

    " let g:VimuxUseNearest = v:false
    " let g:VimuxCloseOnExit = 1
    " let g:VimuxOrientation = "v"
    " let g:VimuxHeight = "40"

    nnoremap <silent> <leader>fo      :"(Terminal)RemoteOpen     ":<c-U>VimuxOpenRunner <cr> \| :call VimuxRunCommandInDir('vi', 1)<cr>
endif

if HasPlug('vim-dispatch') | " {{{1
    let g:dispatch_tmux_height = '50% -h'
endif


if HasPlug('vim-browser-search') | " {{{1
    nmap <silent> <Leader>sw <Plug>SearchNormal
    vmap <silent> <Leader>sw <Plug>SearchVisual
endif

" Pencil draw
if HasPlug('venn.nvim') | " {{{1
    "nnoremap <silent>   ;vb     :"(mode)Draw pencil box     "<c-U>ToggleVennDraw<cr>

    " Troubleshooting:
    "   let g:venn_debug = 1
    "   tail -f ~/.local/share/nvim/venn.log
    "
    command! ToggleVennDraw call s:VennToggleMap()
    let s:vennMapState=1
    function! s:VennToggleMap()
        if s:vennMapState
            let s:vennMap1 = hw#misc#SaveMaps(['J', 'K', 'K', 'H'], 'n', 1)
            let s:vennMap2 = hw#misc#SaveMaps(['b'], 'v', 1)
            "let old_ve=&ve
            setlocal ve=all
            " silent! unmap! J
            " silent! unmap! K
            " silent! unmap! L
            " silent! unmap! H
            " silent! unmap! bb
            nnoremap <silent> J  <C-v>j:VBox<cr>
            nnoremap <silent> K  <C-v>k:VBox<cr>
            nnoremap <silent> L  <C-v>l:VBox<cr>
            nnoremap <silent> H  <C-v>h:VBox<cr>
            vnoremap <silent> bb :VBox<cr>
        else
            "set ve=&old_ve
            setlocal ve=
            silent! unmap J
            silent! unmap K
            silent! unmap L
            silent! unmap H
            silent! unmap bb
            call hw#misc#RestoreMaps(s:vennMap1)
            call hw#misc#RestoreMaps(s:vennMap2)
        endif

        let s:vennMapState = !s:vennMapState
    endfunction
endif


if CheckPlug('new-gdb.vim', 1) || CheckPlug('vimgdb', 1) " {{{1
    "let g:neogdb_window = ['backtrace', 'breakpoint']
    let g:gdb_require_enter_after_toggling_breakpoint = 0

    let g:neogdb_gdbserver = 'dut.py'
    if exists("$NBG_ATTACH_REMOTE_STR")
        let g:neogdb_attach_remote_str = $NBG_ATTACH_REMOTE_STR
    else
        "let g:neogdb_attach_remote_str = 'sysinit/init dut:444 -u admin -p "" -t "gdb:wad"'
        let g:neogdb_attach_remote_str = 'sysinit/init'
    endif
elseif CheckPlug('vimspector', 1) | " {{{1
    "let g:vimspector_base_dir=expand( '$HOME/.vim/vimspector-config' )
    "let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-go', 'CodeLLDB' ]
    let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
    "let g:vimspector_enable_mappings = 'HUMAN'

    let g:vimspector_sidebar_width = 35
    let g:vimspector_bottombar_height = 5
    let g:vimspector_code_minwidth = 90
    let g:vimspector_terminal_maxwidth = 15
    let g:vimspector_terminal_minwidth = 5

    " Default:
    "sign define vimspectorBP         text=\ ● texthl=WarningMsg
    "sign define vimspectorBPCond     text=\ ◆ texthl=WarningMsg
    "sign define vimspectorBPDisabled text=\ ● texthl=LineNr
    "sign define vimspectorPC         text=\ ▶ texthl=MatchParen linehl=CursorLine
    "sign define vimspectorPCBP       text=●▶  texthl=MatchParen linehl=CursorLine

    " Customize
    sign define vimspectorBP         text=\ ● texthl=Search
    sign define vimspectorBPCond     text=\●² texthl=Search
    sign define vimspectorBPDisabled text=\ ● texthl=Function
    sign define vimspectorPC         text=\ ☛ texthl=Error linehl=CursorLine
    sign define vimspectorPCBP       text=●☛  texthl=Error linehl=CursorLine
    "sign define GdbCurrentLine   text=☛ texthl=Error
    "sign define GdbBreakpointEn  text=● texthl=Search
    "sign define GdbBreakpointDis text=● texthl=Function
    "sign define GdbBreakpointDel text=● texthl=Comment
    "let g:vimgdb_sign_breakpoints = ['●', '●²', '●³', '●⁴', '●⁵', '●⁶', '●⁷', '●⁸', '●⁹', '●ⁿ']

    nnoremap <silent> <f2>    :call vimspector#Launch()<CR>
    nnoremap <silent> <S-F2>  :VimspectorReset<CR>

    nnoremap <silent> <f3> :call vimspector#Stop()<CR>
    nnoremap <silent> <S-F3>  :vimspector#Restart()<CR>

    "nnoremap <silent> <leader>do :VimspectorShowOutput

    nnoremap <silent> <f4> :call vimspector#Continue()<CR>
    nnoremap <silent> <F14> :call vimspector#Pause()<CR>

    nnoremap <silent> <f5> :call vimspector#StepOver()<CR>
    "nnoremap <silent> <F15> :call vimspector#SkipOver()<CR>

    nnoremap <silent> <f6> :call vimspector#StepInto()<CR>
    nnoremap <silent> <F16> :call vimspector#StepOut()<CR>

    nnoremap <silent> <f7> :call vimspector#RunToCursor()<CR>
    "nnoremap <silent> <S-f7> :call vimspector#SkipToCursor()<CR>


    nnoremap <f8>    :VimspectorEval <c-r>=hw#misc#GetWord('n')<cr>
    vnoremap <f8>    :<c-u>VimspectorEval <c-r>=hw#misc#GetWord('v')<cr>
    "
    "nnoremap <F18>  :VimspectorWatch <c-r>=expand('<cword>')<cr>
    nnoremap <S-F8>  :VimspectorWatch <c-r>=hw#misc#GetWord('n')<cr>
    vnoremap <S-F8>  :<c-u>VimspectorWatch <c-r>=hw#misc#GetWord('v')<cr>

    nnoremap <silent> <f9> :call vimspector#ToggleBreakpoint()<CR>
    nnoremap <silent> <S-F9> :call vimspector#AddFunctionBreakpoint( '<cexpr>' )<CR>

endif


if CheckPlug('tabman.vim', 1) | " {{{1
    " disable old config
    let g:tabman_toggle = '<leader>xt'
    let g:tabman_focus  = '<leader>xf'
endif


if CheckPlug('neocomplcache.vim', 1) | " {{{1
    let g:acp_enableAtStartup = 0
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
endif


if CheckPlug('tcl.vim', 1) | " {{{1
    let tcl_extended_syntax = 1
endif


if CheckPlug('vim-rooter', 1) | " {{{1
    let g:rooter_manual_only = 1
    let g:rooter_patterns = ['Rakefile', '.git', '.git/', '.svn', '.svn/']
endif


if CheckPlug('neomake', 1) | " {{{1
    " make & asynrun
    let g:neomake_open_list = 0
    let g:neomake_place_signs = 1
    "let g:neomake_verbose = 3
    "let g:neomake_logfile = './log.make'
    let g:neomake_warning_sign = {
      \ 'text': 'W',
      \ 'texthl': 'WarningMsg',
      \ }
    let g:neomake_error_sign = {
      \ 'text': 'E',
      \ 'texthl': 'ErrorMsg',
      \ }
endif


if CheckPlug('neovim-fuzzy', 1) | " {{{1
    " fuzzy
    "let g:fuzzy_file_list = ["cscope.files"]
    "let g:fuzzy_file_tag = ['tags.x', '.tags.x']
endif


if CheckPlug('supertab', 1) | " {{{1
    let g:SuperTabDefaultCompletionType = "<c-n>"
endif


if CheckPlug('neoterm', 1) | " {{{1
    let g:neoterm_default_mod = 'vertical'
    let g:neoterm_autoinsert = 1
endif


if HasPlug('vim-easy-align') | " {{{1
    let g:easy_align_ignore_comment = 0 " align comments
    vnoremap <leader>cc      :"(edit)EasyAlign    theCommand"<c-U>'<,'>EasyAlign *\|<cr>
    nmap     <leader>cc      mzvic:"(edit)EasyAlign theCommand"<c-U>'<,'>EasyAlign *\|<cr> \| 'zzz
    vnoremap <leader>ga      :"(edit)EasyAlign theCommand"<c-U>'<,'>EasyAlign<cr>
    vnoremap <leader>ca      :"(edit)EasyAlign theCommand"<c-U>'<,'>EasyAlign " "<cr>

    let g:easy_align_delimiters = {
        \ '>': { 'pattern': '>>\|=>\|>' },
        \ '/': {
        \     'pattern':         '//\+\|/\*\|\*/',
        \     'delimiter_align': 'l',
        \     'ignore_groups':   ['!Comment'] },
        \ ']': {
        \     'pattern':       '[[\]]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ ')': {
        \     'pattern':       '[()]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ 'd': {
        \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
        \     'left_margin':  0,
        \     'right_margin': 0
        \   },
        \ 'm': {
        \     'pattern':      '/\\$/',
        \     'stick_to_left':0,
        \     'left_margin':  2,
        \     'right_margin': 0,
        \   },
        \ }
endif


if HasPlug('rainbow_parentheses.vim') | " {{{1
    let g:rainbow#max_level = 16
    let g:rainbow#pairs = [['(', ')'], ['[', ']']]

    " List of colors that you do not want. ANSI code or #RRGGBB
    "   :RainbowParenthesesColors
    let g:rainbow#blacklist = [241, 242, 244]
endif


if CheckPlug('vim-autotag', 1) | " {{{1
    " log: /tmp/vim-autotag.log
    let g:autotagVerbosityLevel = 10
    let g:autotagmaxTagsFileSize = 50 * 1024 * 1024
    let g:autotagCtagsCmd = "LC_COLLATE=C ctags --extra=+f"
    let g:autotagTagsFile = ".tags"
    let s:autotag_inter = 10
    let g:autotagExcSuff = ['tml', 'xml', 'text', 'txt', 'md', 'mk', 'conf', 'html', 'yml', 'css', 'scss']
endif


if HasPlug('asyncrun.vim')
    nnoremap <leader>gc         :"(git)clean-dryrun        theCommand"<c-U>AsyncStop! <bar> AsyncTask gitclean-dryrun<cr>
    nnoremap <leader>gx         :"(git)clean               theCommand"<c-U>AsyncStop! <bar> AsyncTask gitclean<cr>
    nnoremap <leader>f]         :"(tool)Auto generate tags theCommand"<c-U>AsyncRun! tagme<cr>

    if filereadable(expand('~/.vim_tasks.ini')) && !filereadable(expand('~/.vim/tasks.ini'))
        call system(expand('ln -s ~/.vim_tasks.ini ~/.vim/tasks.ini'))
    endif

    let g:asyncrun_silent = 1
    let g:asyncrun_open = 8
    let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
    let g:asynctasks_term_reuse = 1
    let g:asynctasks_term_focus = 1
    let g:asynctasks_term_pos = 'bottom'

    " Create template
    " :AsyncTaskEdit cargo
    let g:asynctasks_template = {}
    let g:asynctasks_template.cargo = [
                \ "[project-init]",
                \ "command=cargo update",
                \ "cwd=<root>",
                \ "",
                \ "[project-build]",
                \ "command=cargo build",
                \ "cwd=<root>",
                \ "errorformat=%. %#--> %f:%l:%c",
                \ "",
                \ "[project-run]",
                \ "command=cargo run",
                \ "cwd=<root>",
                \ "output=terminal",
                \ ]
endif


if CheckPlug('vista.vim', 1) | " {{{1
    let g:vista_icon_indent = ["▸ ", ""]
    let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -x -o - -c',
      \ }
    let g:vista_fzf_preview = ['right:50%']
    let g:vista#renderer#enable_icon = 0
    let g:vista_sidebar_width = 40
    let g:vista_echo_cursor = 0
    let g:vista_blink = [0, 0]
    let g:vista_top_level_blink = [0, 0]
    "let g:vista_sidebar_position = 'vertical botright'
endif


if CheckPlug('vim-bookmarks', 1) | " {{{1
    let g:bookmark_no_default_key_mappings = 1
    let g:bookmark_highlight_lines = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 0
    let g:bookmark_show_warning = 0
    "let g:bookmark_location_list = 1
endif


if CheckPlug('vim-tmux-navigator', 1) | " {{{1
    "" Disable tmux navigator when zooming the Vim pane
    let g:tmux_navigator_disable_when_zoomed = 1

    let g:tmux_navigator_no_mappings = 1
    noremap <silent> <c-h>     :<c-U>TmuxNavigateLeft<cr>
    noremap <silent> <c-j>     :<c-U>TmuxNavigateDown<cr>
    noremap <silent> <c-k>     :<c-U>TmuxNavigateUp<cr>
    noremap <silent> <c-l>     :<c-U>TmuxNavigateRight<cr>
    " Conflict with fzf: cause fzf jump to another tmux-panel, since fzf will feedkeys(<c-\>)
    "noremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>
endif


if CheckPlug('netrw', 1) | " {{{1, But not work like side-tree
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = 16
    let g:netrw_list_hide='.*\.png$,.*\.pdf,.*\.mp4,.*\.tga,.*\.mp3,.*\.jpg,.*\.svg,/*\.stl,.*\.mtl,.*\.ply'
endif


if HasPlug('nerdtree')
    nnoremap <silent> <leader>ve      :"(view)Explore(legacy)    theCommand"<c-U>NERDTreeToggle<cr><cr>
    nnoremap <silent> <leader>vf      :"(view)Explore Focus      theCommand"<c-U>NERDTreeFocus<cr>

    command! LoadNerdtree call s:loadNerdtree()

    fun s:loadNerdtree()
        " Conflicts with NERDTree menu ('m' key): And the only reason to create and remove maps is because of the conflicting m map in NERDTree.
        " https://github.com/kshenoy/vim-signature/issues/3
        let g:NERDTreeMapMenu='M'
        " Dicard this two key maps, avoid conflict <C-j/k>
        let g:NERDTreeMapJumpNextSibling = 'gJ'
        let g:NERDTreeMapJumpPrevSibling = 'gK'
        let g:NERDTreeMapOpenInTab = 'gT'

        let g:NERDTreeMouseMode = 3
        "let g:NERDTreeAutoDeleteBuffer = 1
        let g:NERDTreeMinimalUI = 1
        let g:NERDTreeDirArrows = 1
        let g:NERDTreeRespectWildIgnore = 1
        let g:NERDTreeShowBookmarks = 0
        let g:NERDTreeFileLines = 0
        let g:NERDTreeWinSize = 25

        let g:NERDTreeIgnore = [ 'null', ".DS_Store", "thumbs.db",
                    \ "tags", '.tags', '.tagx', '.cscope.files', 'cscope.in.out', 'cscope.out','cscope.po.out',
                    \ '.jshintrc', '.jscsrc', '.eslintignore', '.eslintrc.json',
                    \ '.gitattributes', '.git',
                    \ '.ccls-cache', '.devops','.arcconfig','.vscode',
                    \ ]
        " dir
        call extend(g:NERDTreeIgnore, ['__pycache__', 'CMakeFiles', 'htmlcov', 'node_modules', '.idea', '.git', '^build$', '^target$', '^obj$', ])
        " file
        call extend(g:NERDTreeIgnore, ['rusty-tags.vi', '\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', 'tags', '^cscope\.', '\.obj$', '\.o$', '\.lib$', '\.a$', '\.dll$', '\.pyc$'])

        let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']

        " Add spaces after comment delimiters by default
        let g:NERDSpaceDelims = 1
        " Use compact syntax for prettified multi-line comments
        let g:NERDCompactSexyComs = 1
        " Align line-wise comment delimiters flush left instead of following code indentation
        let g:NERDDefaultAlign = 'left'
        " Set a language to use its alternate delimiters by default
        let g:NERDAltDelims_java = 1
        " Add your own custom formats or override the defaults
        let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
        " Allow commenting and inverting empty lines (useful when commenting a region)
        let g:NERDCommentEmptyLines = 1
        " Enable trimming of trailing whitespace when uncommenting
        "let g:NERDTrimTrailingWhitespace = 1
    endfun
endif


if CheckPlug('nnn.vim', 1) | " {{{1
    " Opens the nnn window in a split
    "let g:nnn#layout = 'new' " or vnew, tabnew etc.

    " Or pass a dictionary with window size
    "let g:nnn#layout = { 'left': '~20%' } " or right, up, down

    " Floating window (neovim latest and vim with patch 8.2.191)
    let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
endif


if CheckPlug('defx.nvim', 1) | " {{{1
    let g:defx_icons_enable_syntax_highlight = 0
    let g:defx#_python_version_check = 1
endif


if CheckPlug('rust.vim', 1) | " {{{1
    let g:rustfmt_autosave = 1
endif


if CheckPlug('vim-buffergator', 1) | " {{{1
    let g:buffergator_suppress_keymaps = 1
    let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
    let g:buffergator_autoupdate = 1
    let g:buffergator_autodismiss_on_select = 1
    let g:buffergator_autoexpand_on_split = 0
    let g:buffergator_vsplit_size = 25
    "let g:buffergator_viewport_split_policy = 'L'   |" L, R, T, B, n/N
    let g:buffergator_show_full_directory_path = 0
    let g:buffergator_mru_cycle_loop = 1
    let g:buffergator_mru_cycle_local_to_window = 1
    let g:buffergator_sort_regime = 'filepath'
    "let g:buffergator_display_regime = 'basename'
endif


if HasPlug('fzf-folds.vim') | " {{{1
    " tpope/vim-markdown Fold:  zR openAll, zM closeAll, zr +foldLevel, zm -foldLevel, zo opencurr,
    nnoremap zs :Folds<CR>
    let g:fzf_folds_open = 1
endif


if CheckPlug('gist-vim', 1) | " {{{1
    let g:gist_show_privates = 1
    let g:gist_post_private = 1
    let g:gist_get_multiplefile = 1
endif


if CheckPlug('vim-startify', 1) | " {{{1
    let g:startify_list_order = ['sessions', 'bookmarks', 'files', 'dir', 'commands']
    let g:startify_relative_path = 1
    let g:startify_change_to_dir = 0
    let g:startify_session_autoload = 1
    let g:startify_session_dir = './.vim'
    let g:startify_session_persistence = 1
    let g:startify_session_delete_buffers = 1
    let g:startify_session_before_save = [
    	  \ 'echo "Cleaning up before saving.."',
    	  \ 'silent! cclose',
    	  \ 'silent! NERDTreeTabsClose'
    	  \ ]
endif


if CheckPlug('vim-workspace', 1) | " {{{1
    let g:workspace_session_name = '.Session.vim'
    let g:workspace_autosave_always = 1
    let g:workspace_persist_undo_history = 0
    " disable auto trim the trail-spaces
    let g:workspace_autosave_untrailspaces = 0
    let g:workspace_session_disable_on_args = 1
endif


if CheckPlug('vim-session', 1) | " {{{1
    let g:session_directory = getcwd()
    let g:session_default_name = ".Session"
    let g:session_default_overwrite = 1
    let g:session_autoload = 'yes'
    let g:session_autosave = 'yes'
    let g:session_autosave_periodic = 1
    let g:session_autosave_silent = 1
endif


if CheckPlug('deoplete.nvim', 1) | " {{{1
    let g:deoplete#enable_at_startup = 1
    autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
endif


if CheckPlug('neosnippet.vim', 1) | " {{{1
    "let g:neosnippet#enable_conceal_markers = 0
    " The last dir will be taken as default working dir.
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/bundle/vim-snippets.local/snippets, '

    " Comment out due to make <tab> not work insert-mode
    " imap <C-i>     <Plug>(neosnippet_expand_or_jump)
    " smap <C-i>     <Plug>(neosnippet_expand_or_jump)
    " xmap <C-i>     <Plug>(neosnippet_expand_target)

    " Use Tab to expand or jump, fallback to inserting a Tab
    inoremap <expr> <Tab> neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '<Tab>'
endif


if HasPlug('w3m.vim') | " {{{1
    command! LoadW3m call s:loadW3m()

    fun s:loadW3m()
        let g:w3m#command = '/usr/bin/w3m'
        let g:w3m#lang = 'en_US'
        let g:w3m#disable_vimproc = 1
        "let g:w3m#disable_default_keymap = 1
    endfun
endif


"let g:AutoComplPop_CompleteoptPreview = 1
"let g:AutoComplPop_Behavior = {
"        \ 'c': [ {'command' : "\<C-x>\<C-o>",
"        \       'pattern' : ".",
"        \       'repeat' : 0}
"        \      ]
"        \}
"


if CheckPlug('command-t', 1) | " {{{1
    let g:CommandTHighlightColor = 'Ptext'
    let g:CommandTNeverShowDotFiles = 1
    let g:CommandTScanDotDirectories = 0
endif


if HasPlug('quickfix-reflector.vim') | " {{{1
    " toggles the quickfix window.
    command! -bang -nargs=? QFix call QFixToggle(<bang>0)
    function! QFixToggle(forced)
        if exists("g:qfix_win") && a:forced == 0
            cclose
            unlet g:qfix_win
        else
            botright copen
            let g:qfix_win = bufnr("$")
        endif
    endfunction

    nnoremap <silent>  <leader>vq     :"(view)Quickfix         theCommand"<c-U>QFix<cr>
endif


if HasPlug('VOoM') | " {{{1
    nnoremap <silent>  <leader>vo     :"(view)Outline          theCommand"<c-U>VoomToggle<cr>
    nnoremap <silent>  <leader>v0     :"(view)Outline fmr1     theCommand"<c-U>VoomToggle fmr<cr>

    " nnoremap <silent>   <leader>v1         :"(helper)Insert outline header     theCommand"<c-U>call utils#VoomInsert(0) <CR>
    " vnoremap <silent>   <leader>v1         :"(helper)Insert outline header     theCommand"<c-U>call utils#VoomInsert(1) <CR>
endif


if HasPlug('tagbar') | " {{{1
    nnoremap <silent>  <leader>vt   :TagbarToggle<cr>
    command! LoadTagbar call s:loadTagbar()

    fun s:loadTagbar()
        "let g:tagbar_vertical = 25
        "let g:tagbar_show_linenumbers = 1
        "let NERDTreeWinPos = 'left'
        let g:tagbar_autofocus = 0
        "let g:tagbar_autoclose = 1
        let g:tagbar_position = 'left'
        let g:tagbar_sort = 0
        let g:tagbar_width = 40
        let g:tagbar_compact = 1
        let g:tagbar_silent = 1
        let g:tagbar_indent = 2
        let g:tagbar_foldlevel = 4
        let g:tagbar_iconchars = ['+', '-']
        let g:tagbar_map_hidenonpublic = "`"
        let g:tagbar_map_close = "q"

        " Support Rust tag list
        if executable('ctags')
            let path_ctags = systemlist("which ctags")[0]
            let g:rust_use_custom_ctags_defs = 1
            let g:tagbar_type_rust = {
                        \   'ctagsbin' : path_ctags,
                        \   'ctagstype' : 'rust',
                        \   'kinds' : [
                        \     'n:modules',
                        \     's:structures:1',
                        \     'i:interfaces',
                        \     'c:implementations',
                        \     'f:functions:1',
                        \     'g:enumerations:1',
                        \     't:type aliases:1:0',
                        \     'v:constants:1:0',
                        \     'M:macros:1',
                        \     'm:fields:1:0',
                        \     'e:enum variants:1:0',
                        \     'P:methods:1',
                        \   ],
                        \   'sro': '::',
                        \   'kind2scope' : {
                        \     'n': 'module',
                        \     's': 'struct',
                        \     'i': 'interface',
                        \     'c': 'implementation',
                        \     'f': 'function',
                        \     'g': 'enum',
                        \     't': 'typedef',
                        \     'v': 'variable',
                        \     'M': 'macro',
                        \     'm': 'field',
                        \     'e': 'enumerator',
                        \     'P': 'method',
                        \   },
                        \ }
        endif

        " Add support for markdown files in tagbar.
        if executable('markdown2ctags.py')
            let path_mdctags = systemlist("which markdown2ctags.py")[0]
            let g:markdown_use_custom_ctags_defs = 1
            let g:tagbar_type_markdown = {
                        \   'ctagsbin' : path_mdctags,
                        \   'ctagstype' : 'markdown',
                        \   'ctagsargs' : '-f - --sort=yes --sro=»',
                        \   'kinds' : [
                        \       's:sections',
                        \       'i:images'
                        \    ],
                        \    'sro' : '»',
                        \    'kind2scope' : {
                        \       's' : 'section',
                        \     },
                        \     'sort': 0,
                        \ }
        endif
    endfun
endif

if CheckPlug('taglist.vim', 1) | " {{{1
    "let Tlist_GainFocus_On_ToggleOpen = 1
    let Tlist_Auto_Update = 0
    let Tlist_Show_Menu = 0
    let Tlist_Use_Right_Window = 1
    let Tlist_WinWidth = 40
    let Tlist_File_Fold_Auto_Close = 1
    let Tlist_Show_One_File = 1
    let Tlist_Use_SingleClick = 1
    let Tlist_Enable_Fold_Column = 0
endif


if CheckPlug('minibufexpl.vim', 1) | " {{{1
    let g:miniBufExplSplitToEdge = 1
    let g:miniBufExplorerAutoStart = 1
endif


if CheckPlug('vim-json', 1) | " {{{1
    let g:vim_json_syntax_conceal = 0
endif


if CheckPlug('vim-sneak', 1) | " {{{1
    let g:sneak#s_next = 1
    let g:sneak#use_ic_scs = 1
endif


if CheckPlug('vimdiff', 1) | " {{{1
    " output to html ignore the same line
    let g:html_ignore_folding = 1
    let g:html_use_css = 0
    let g:enable_numbers = 0
endif


if HasPlug('vimwiki') | " {{{1
    " {'path': '$HOME/wiki', 'auto_toc': 1, 'syntax': 'markdown', 'ext': '.md', 'maxhi': 1, 'auto_tags': 1},
    let g:vimwiki_list = [
          \{'name': 'work',  'path': '$HOME/dotwiki', 'ext': '.md', 'syntax': 'markdown', 'auto_toc': 1, 'maxhi': 1, 'auto_tags': 1},
          \{'name': 'linux', 'path': '$HOME/wiki',    'ext': '.md', 'syntax': 'markdown', 'auto_toc': 1, 'maxhi': 1, 'auto_tags': 1},
          \]

    let g:vimwiki_global_ext = 0    | " only set the 'vimwiki' filetype of markdown files inside a wiki directory, rather than globally.
    let g:vimwiki_ext2syntax = {'.wiki': 'media', '.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown', '.mkd': 'markdown'}
    "let g:vimwiki_ext2syntax = {'.md': 'markdown', '.mkd': 'markdown', '.wiki': 'markdown'}

    let g:vimwiki_menu = ""         | "Disable error msg: No menu 'Vimwiki'
    let g:vimwiki_url_maxsave = 0   | "Turn off the link shortening
    let g:vimwiki_conceallevel = 0  | "Default=2, -1 Disable conceal

endif


if HasPlug('wiki.vim') | " {{{1
    let g:wiki_mappings_use_defaults = 'none'
    let g:wiki_root = '~/dotwiki'
    let g:wiki_log_verbose = 0
    let g:wiki_completion_enabled = 0
    let g:wiki_filetypes = ['md']
    let g:wiki_link_extension = '.md'
    let g:wiki_link_target_type = 'md'
    let g:wiki_link_toggle_on_follow = 1
    let g:wiki_fzf_pages_opts = '--preview "cat {1}"'

    nnoremap    <leader>wb      :"WikiLinkReturn    "<c-U>WikiLinkReturn<cr>
    "nnoremap    <leader>wc     :"WikiFzfTags       "<c-U>WikiFzfTags<cr>
    nnoremap    <leader>wd      :"WikiPageDelete    "<c-U>WikiPageDelete<cr>
    "nnoremap   <leader>wh      :"WikiFzfPages      "<c-U>WikiFzfPages<cr>
    nnoremap    <leader>wi      :"WikiIndex         "<c-U>WikiIndex<cr>
    nnoremap    <leader>wj      :"WikiLinkFollow    "<c-U>WikiLinkFollow<cr>
    nnoremap    <leader>wJ      :"WikiLinkToggle    "<c-U>WikiLinkToggle<cr>
    nnoremap    <leader>wn      :"WikiOpen          "<c-U>WikiOpen<cr>
    nnoremap    <leader>wr      :"WikiPageRename    "<c-U>WikiPageRename<cr>
    nnoremap    <leader>wt      :"WikiTags          "<c-U>FzfTagHomeCacheTag<cr>
    nnoremap    <leader>wT      :"CurPageCreateToc  "<c-U>WikiPageToc<cr>
    nnoremap    <leader>ww      :"WikiEnable        "<c-U>WikiEnable<cr>
endif


if HasPlug('fzf-cscope.vim') | " {{{1
    nnoremap    <leader>wh      :"TldrFzfHeader     "<c-U>Wiki2FzfHeader<cr>
    nnoremap    <leader>wH      :"TldrFzfText       "<c-U>Wiki2FzfText<cr>
    nnoremap    <leader>wl      :"TldrFzfFiles      "<c-U>Wiki2FzfFile<cr>

    nnoremap    <leader>ws      :"WikiFzfText       "<c-U>WikiFzfText<cr>
    nnoremap    <leader>wf      :"WikiFzfFiles      "<c-U>WikiFzfFiles<cr>

    nnoremap    <leader>ft      :"(fzf)Tag          "<c-U>FzfTagFilter<cr>
    nnoremap    <leader>fT      :"(fzf)WikiTag      "<c-U>FzfTagHomeCacheTag<cr>
endif


if HasPlug('tldr.nvim') | " {{{1
    nnoremap    ;ft      :"Tldr     "<c-U>Telescope tldr<cr>
endif


if HasPlug('vim-mark') | " {{{1
    let g:mw_no_mappings = 1
    let g:mwDefaultHighlightingPalette = 'extended'
    let g:mwHistAdd = '/@'
    let g:mwAutoSaveMarks = 0
    let g:mwMaxMatchPriority = -10
endif


if HasPlug('tpope_vim-markdown') | " {{{1
    let g:markdown_folding = 2
    "let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
    " About yaml fence-code:
    "   Download yaml.vim from https://github.com/stephpy/vim-yaml/blob/master/after/syntax/yaml.vim
    "                     to ~/.vim/bundle/tpope_vim-markdown/syntax/yaml.vim
    let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'java', 'c', 'yaml']
    let g:markdown_minlines = 500
    "let g:markdown_syntax_conceal = 0
    if exists("g:vim_markdown_conceal")
        let g:markdown_syntax_conceal = g:vim_markdown_conceal
    endif
endif


if HasPlug('vim-markdown') | " {{{1
    " ge: jump follow link
    " gx: open link in browser

    "set conceallevel=0
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_toc_autofit = 1

    let g:vim_markdown_auto_extension_ext = 'wiki'

    "let g:markdown_minlines = 200
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_override_foldtext = 0
    let g:vim_markdown_folding_level = 6
    "let g:vim_markdown_folding_style_pythonic = 1
    "
    let g:vim_markdown_emphasis_multiline = 0
    let g:vim_markdown_new_list_item_indent = 2
    "let g:vim_markdown_no_default_key_mappings = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_json_frontmatter = 1
    let g:vim_markdown_fenced_languages = ['C=c', 'c=c', 'Shell=sh', 'Java=java'
          \ , 'Csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini'
          \ , 'rust-script=rust', 'Rust=rust', 'RUST=rust'
          \ ]
    let g:markdown_fenced_languages = g:vim_markdown_fenced_languages
    let g:vim_markdown_autowrite = 1       | " automatically save before jump
    let g:vim_markdown_follow_anchor = 1   | " `ge` command to follow anchors: file#anchor or #anchor
    let g:vim_markdown_strikethrough = 1   | " ~~Scratch this.~~
    let g:vim_markdown_no_extensions_in_markdown = 1      | "`ge`: [link text](link-url), the (link-url) part donnot need .md extention, 'gx' open in browser


    if !CheckPlug('vimwiki', 1) | " {{{1
        augroup markdown_syntax
            au! BufNewFile,BufFilePre,BufRead *.md,*.wiki set filetype=markdown
        augroup END
    endif
endif


if HasPlug('context.vim') | " {{{1
    nnoremap <silent>   <leader>aa      :"(*)Context         theCommand"<c-U>ContextToggle<cr>
    command! LoadContextVim call s:loadContextVim()

    fun s:loadContextVim()
        let g:context_add_mappings = 0
        let g:context_enabled = 0
        " let g:context_presenter = 'nvim-float'
        " let g:context_highlight_normal = 'Normal'
        " let g:context_highlight_border = 'Comment'
        let g:context_highlight_tag    = '<hide>'
        let g:context_buftype_blacklist = ['floaterm', 'terminal', 'quickfix']
        let g:context_filetype_blacklist = ['floaterm', 'qt']
    endfun
endif


if HasPlug('lightline.vim') | " {{{1
   let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
endif

if CheckPlug('mkdx', 1) | " {{{1
    "let g:mkdx#settings = { 'map': { 'prefix': ';' } }

    let g:mkdx#settings = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 0 } },
                        \ 'toc': { 'text': 'Content', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 0 },
                        \ 'checkbox': { 'toggles': [' ', '-', 'x'] },
                        \ 'tokens': { 'enter': ['-', '*', '>'] },
                        \ }

    if CheckPlug('vim-markdown', 1) | " {{{1
        " For vim-polyglot users, it loads Plasticboy's markdown
        "   plugin which unfortunately interferes with mkdx list indentation.
        let g:polyglot_disabled = ['markdown']
    endif

    augroup mkdx_remap
        au! mkdx_remap
        au! FileType conf,markdown nnoremap ;i :call      mkdx#GenerateOrUpdateTOC()<Cr>
        "au! FileType conf,markdown nnoremap ;I :call      mkdx#QuickfixHeaders()<cr>
        "au! FileType conf,markdown  noremap ;t :call      mkdx#ToggleCheckboxTask()<Cr>
        "au! FileType conf,markdown  noremap ;l :call      mkdx#ToggleCheckList()<Cr>
        "au! FileType conf,markdown nnoremap ;L :call      mkdx#QuickfixDeadLinks()<cr>
        "au! FileType conf,markdown  noremap ;h :call      mkdx#JumpToHeader()<cr>
    augroup END
endif


if CheckPlug('vim-pandoc', 1) | " {{{1
    if CheckPlug('vimwiki', 1) | " {{{1
        augroup pandoc_syntax
            au! FileType vimwiki set syntax=markdown.pandoc
        augroup END
    else
        augroup pandoc_syntax
            au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
        augroup END
    endif
endif


if CheckPlug('vim-zettel', 1) | " {{{1
    let g:zettel_default_mappings = 0
    let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always "
    let g:zettel_fzf_options = ['--exact', '--tiebreak=end']
endif


if CheckPlug('python-mode', 1) | " {{{1
    " Activate rope
    " Keys:
    " K             Show python docs
    " <Ctrl-Space>  Rope autocomplete
    " <Ctrl-c>g     Rope goto definition
    " <Ctrl-c>d     Rope show documentation
    " <Ctrl-c>f     Rope find occurrences
    " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
    " [[            Jump on previous class or function (normal, visual, operator modes)
    " ]]            Jump on next class or function (normal, visual, operator modes)
    " [M            Jump on previous class or method (normal, visual, operator modes)
    " ]M            Jump on next class or method (normal, visual, operator modes)
    let g:pymode_rope = 0
    let g:pymode_run = 1
    let g:pymode_run_bind = '<leader>rr'

    " Documentation
    let g:pymode_doc = 1
    let g:pymode_doc_key = 'K'

    "Linting
    let g:pymode_lint = 0
    let g:pymode_lint_checker = "pyflakes,pep8"
    " Auto check on save
    let g:pymode_lint_write = 1

    " Support virtualenv
    let g:pymode_virtualenv = 1

    " Enable breakpoints plugin
    let g:pymode_breakpoint = 1
    let g:pymode_breakpoint_bind = '<leader>b'

    " syntax highlighting
    let g:pymode_syntax = 1
    let g:pymode_syntax_all = 1
    let g:pymode_syntax_indent_errors = g:pymode_syntax_all
    let g:pymode_syntax_space_errors = g:pymode_syntax_all

    " Don't autofold code
    let g:pymode_folding = 0
endif


if HasPlug('jedi-vim')
    " leader+t:   doctest
    let g:jedi#completions_command = "<C-Space>"
    let g:jedi#goto_command = "<leader>gg"
    let g:jedi#goto_assignments_command = "<leader>gd"
    let g:jedi#goto_definitions_command = "<C-]>"
    let g:jedi#documentation_command = "<leader>k"
    let g:jedi#usages_command = "<leader>u"
    let g:jedi#rename_command = ""
endif


if HasPlug('NrrwRgn')
    vnoremap    <leader>ei   vic:"(edit)Narrow edit    theCommand"<c-U>NRV<cr>
    command! LoadNrrwRgn call s:loadNrrwRgn()

    "fun s:loadNrrwRgn()
        let g:nrrw_rgn_nomap_nr = 1
        let g:nrrw_rgn_nomap_Nr = 1

        let g:nrrw_topbot_leftright = 'botright'
        let g:nrrw_rgn_resize_window = 'relative'
        let g:nrrw_rgn_wdth = 50
        "let g:nrrw_rgn_vert = 1
        let g:nrrw_rgn_rel_min = 30
        "let g:nrrw_rgn_rel_max = 80
    "endfun
endif


if HasPlug('SingleCompile')
    let g:SingleCompile_usequickfix=1
endif


if HasPlug('vim-go')
    let g:go_version_warning = 0
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1

    let g:go_fmt_command = "goimports"
    let g:go_term_enabled = 1
    let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    let g:go_list_type = "quickfix"
endif


if CheckPlug('haskellmode-vim', 1) | " {{{1
    let $PATH = $PATH . ':' . expand('~/.cabal/bin')

    " Configure browser for haskell_doc.vim
    let g:haddock_browser = "open"
    let g:haddock_browser_callformat = "%s %s"
    " First sudo apt install ghc-doc
    let g:haddock_docdir = "/usr/share/doc/ghc-doc/html/"

    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

    "autocmd BufWritePost *.hs call s:check_and_lint()
    autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    function! s:check_and_lint()
      let l:qflist = ghcmod#make('check')
      call extend(l:qflist, ghcmod#make('lint'))
      call setqflist(l:qflist)
      cwindow
      if empty(l:qflist)
        echo "No errors found"
      endif
    endfunction
endif


if CheckPlug('vim-yoink', 1) | " {{{1
    " yank/paste
    " Disable warning: Clipboard error : Target STRING not available when running
    let g:yankring_clipboard_monitor=0

    let g:yoinkIncludeDeleteOperations=0
    let g:yoinkSavePersistently=1
    let g:yoinkMoveCursorToEndOfPaste=1
    let g:yoinkIncludeNamedRegisters=1
    let g:yoinkSyncNumberedRegisters=1
endif


if CheckPlug('vim-gutentags', 1) | " {{{1
    " https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
    " https://github.com/skywind3000/gutentags_plus
    "
    " Troubleshooting
    "let g:gutentags_define_advanced_commands = 1
    "let g:gutentags_trace = 1


    if CheckPlug('c-utils.vim', 1)
        let g:gutentags_enabled = 0
    else
        let g:gutentags_enabled = 1
    endif


    " auto-load gtags file
    let g:gutentags_auto_add_gtags_cscope = 1


    command! Gtaggen    GutentagsGenerate
    command! Gtagup     GutentagsUpdate
    command! Gtagtrace  GutentagsToggleTrace
    command! -nargs=0 Gtagclear call system('rm ' . g:gutentags_cache_dir . '/*')


    " generate datebases in my cache directory, prevent gtags files polluting my project
    let g:gutentags_cache_dir = '/tmp/gtags'

    " disable all auto load, only keep manual alias command
    let g:gutentags_generate_on_new = 0
    let g:gutentags_generate_on_missing = 0
    let g:gutentags_generate_on_write = 0
    let g:gutentags_generate_on_empty_buffer = 0

    " change focus to quickfix window after search (optional).
    "let g:gutentags_plus_switch = 1

    " touch .root
    let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
    "let g:gutentags_ctags_tagfile = '.tags'

    "let s:vim_tags = expand('./.ccls-cache')
    "let g:gutentags_cache_dir = s:vim_tags
    "if !isdirectory(s:vim_tags)
    "    silent! call mkdir(s:vim_tags, 'p')
    "endif

    let g:gutentags_modules = []

    if executable('ctags')
        let g:gutentags_modules += ['ctags']
    endif

    "if executable('cscope')
    "    let g:gutentags_modules += ['cscope']
    "endif

    "brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    "(MacOS) $ brew install global
    "(Ubuntu) $ sudo apt install global
    if executable('gtags-cscope') && executable('gtags')
        let g:gutentags_modules += ['gtags_cscope']
    endif

    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--exclude=.git', '--exclude=node_modules', '--exclude=.ccls-cache']

    if filereadable("./cscope.files")
        let g:gutentags_ctags_extra_args += ['-L '. expand("%:p:h"). '/cscope.files']
    endif

    " Force universal ctags to generate old ctags format
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

    let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
endif


if CheckPlug('ale.vim', 1) | " {{{1
    let g:ale_cpp_ccls_init_options = {
      \   'cache': {
      \       'directory': './ccls-cache',
      \   },
      \ }
    "let g:ale_completion_enabled = 1
    call deoplete#custom#option('sources', {
      \ '_': ['ale'],
      \})

    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    let g:ale_lint_on_enter = 0
    "let g:ale_lint_on_save = 0
    "let g:ale_list_window_size = 5
    let g:ale_open_list = 1
    let g:ale_set_loclist = 0
    let g:ale_set_quickfix = 1
    let g:ale_keep_list_window_open = 1
endif


if CheckPlug('vim-prettier', 1) | " {{{1
    let g:prettier#autoformat = 0
    let g:prettier#quickfix_enabled = 0
    let g:prettier#quickfix_auto_focus = 0
endif


if CheckPlug('todo.vim', 1) | " {{{1
    " :Todo
    " :Todo {filter}
    let g:todo_root = '~/tools/todo.txt-cli-ex/todo'
    let g:todo_open_command = '~/tools/todo.txt-cli-ex/todo.sh'
endif


if CheckPlug('taskwiki', 1) | " {{{1
    let g:task_rc_override = 'rc.defaultwidth=0'
    let g:task_rc_override = 'rc.defaultheight=0'
    let g:task_report_name = 'long'

    " Troubleshooting:
    " If the edit file locked: rm ~/.task/task.*.task
    "
    "let g:taskwiki_suppress_mappings="yes"
    "let g:taskwiki_taskrc_location="~/.taskrc"
    "let g:taskwiki_data_location="~/.task"
    let g:taskwiki_sort_orders={"T": "project+,due-"}
endif


if CheckPlug('vim-editqf', 1) | " {{{1
    "let g:editqf_no_mappings = 1
    "let g:editqf_saveqf_filename  = "vim.qf"
    "let g:editqf_saveloc_filename = "vim.qflocal"
endif


if CheckPlug('vim-qf', 1) | " {{{1
    " Please silent and don't make troubles
    "let g:qf_mapping_ack_style = 0       | " donnot set this variable, for exist() trigger the keymap
    let g:qf_window_bottom = 0
    let g:qf_loclist_window_bottom = 0
    let g:qf_auto_open_quickfix = 0
    let g:qf_auto_open_loclist = 0
    let g:qf_auto_resize = 0
    let g:qf_auto_quit = 0
    let g:qf_save_win_view = 0
    let g:qf_max_height = 8
endif


if CheckPlug('vim-cpp-enhanced-highlight', 1) | " {{{1
    " improve performance
    let g:cpp_class_scope_highlight = 0
    let g:cpp_member_variable_highlight = 0
    let g:cpp_class_decl_highlight = 0
    let g:cpp_experimental_simple_template_highlight = 0
    let g:cpp_experimental_template_highlight = 0
    let g:cpp_concepts_highlight = 0
    let g:cpp_no_function_highlight = 0
endif


if HasPlug('vim-grepper')
    let g:grepper = {}
    let g:grepper.highlight = 0
    let g:grepper.open = 1
    let g:grepper.quickfix = 1
    let g:grepper.switch = 0
    let g:grepper.jump = 0
endif


if CheckPlug('vim-tmux-runner', 1) | " {{{1
    let g:VtrUseVtrMaps = 0
    let g:VtrClearBeforeSend = 0
    "let g:vtr_filetype_runner_overrides = {
    "      \ 'ruby': 'ruby -w {file}',
    "      \ 'haskell': 'runhaskell {file}'
    "      \ }
    let g:VtrUseMarkStart = 'u'
    let g:VtrUseMarkEnd = 'n'
    let g:VtrFindWindowByName = 0
    let g:VtrFindPaneByName = 0
endif


if CheckPlug('new.vim', 1) | " {{{1
    " neovim expect window
    let g:new#eager_render = 1
endif


if CheckPlug('vim-plugin-AnsiEsc', 1) | " {{{1
    let g:no_cecutil_maps = 1
endif


if CheckPlug('vim-ctrlspace', 1) | " {{{1
    let g:CtrlSpaceDefaultMappingKey = "<C-space> "
endif


if CheckPlug('vim-fugitive', 1) | " {{{1
    if executable('git')
        " 'git mydiff' yields the expected behavior, typing :wq in vim cycles to the next file in the changeset.
        "git config --global diff.tool vimdiff
        "git config --global difftool.prompt false
        "git config --global alias.mydiff difftool
        "
        call system('git config --global alias.vimdiff ''!f() { vim -p $(git diff --name-only) +"tabdo Gvdiff $@" +tabfirst; }; f''')
    endif
endif


if HasPlug('c-utils.vim')
    let g:tlTokenList = ["FIXME @wilson", "TODO @wilson", "XXX @wilson"]
    let g:ctrlsf_mapping = { "next": "n", "prev": "N", }
    let g:utilquickfix_file = $HOME."/.vim/vim.quickfix"
    let g:c_utils_map = get(g:, 'c_utils_map', 1)

    function! s:JumpComma(mode)
        if v:count == 0
            call utils#Declaration()
        else
        endif
    endfunction

    nnoremap <silent> <leader><leader>  :"(*)Preview Tag at right-side-window         theCommand"<c-U>call VimMotionPreview()<cr>
    vnoremap          <leader><leader>  :"(*)Preview Tag at right-side-window         theCommand"<c-U>call VimMotionPreview()<cr>

    let g:c_utils_prefer_dir = get(g:, 'c_utils_prefer_dir', '')

    nnoremap         ;bb    :"Search-rg all         "<c-U>Rg <c-r>=utils#GetSelected('n')<cr>
    nnoremap  <leader>bb    :"Search-rg all         "<c-U>Rg <c-r>=utils#GetSelected('n')<cr>

    nnoremap  <leader>gg    :"Search 'g:c_utils_prefer_dir' from '.vimrc.before'  "<c-U><C-\>e utilgrep#Grep(0, 0, exists('g:c_utils_prefer_dir') ? g:c_utils_prefer_dir : 'daemon/wad', 1)<cr>
    nnoremap         ;gg    :"Search 'g:c_utils_prefer_dir' from '.vimrc.before'  "<c-U><C-\>e utilgrep#Grep(0, 0, exists('g:c_utils_prefer_dir') ? g:c_utils_prefer_dir : 'daemon/wad', 1)<cr>
    vnoremap  <leader>gg    :<C-\>e utilgrep#Grep(0, 1, g:c_utils_prefer_dir, 1)<cr>
    vnoremap         ;gg    :<C-\>e utilgrep#Grep(0, 1, "",           1)<cr>

    nnoremap  <leader>vv    :"Search all            "<c-U><C-\>e utilgrep#Grep(0, 0, "",           1)<cr>
    nnoremap         ;vv    :"Search all            "<c-U><C-\>e utilgrep#Grep(0, 0, "",           1)<cr>
    vnoremap  <leader>vv    :<C-\>e utilgrep#Grep(0, 1, "",           1)<cr>
    vnoremap         ;vv    :<C-\>e utilgrep#Grep(0, 1, "",           1)<cr>
endif


if HasPlug('fzf-cscope.vim') | " {{{1
    let g:fzf_cscope_map = get(g:, 'fzf_cscope_map', 1)
    let g:fzfCscopeFilter = get(g:, 'fzfCscopeFilter', "daemon/wad/")

    if g:vim_confi_option.auto_install_tools
        if LINUX()
            if UBUNTU()
                if !executable('cscope')
                    echomsg "Auto installing cscope"
                    call system("sudo apt install -y cscope")
                endif
                if !executable('ctags')
                    echomsg "Auto installing ctags"
                    call system("sudo apt install -y ctags")
                endif
                if !executable('bat')
                    echomsg "Auto installing batcat"
                    call system("sudo apt install -y bat")
                endif
                if !executable('bat')
                    echomsg "Auto installing gawk"
                    call system("sudo apt install -y gawk")
                endif
            elseif CENTOS() || FEDORA()
                if !executable('cscope')
                    call system("sudo yum install cscope")
                endif
                if !executable('ctags')
                    call system("sudo yum install ctags")
                endif
            endif
        endif
    endif

    " symbol
    " 1. Please install 'batcat' first: sudo apt install bat
    " 2. Then check the config if batcat can't works:  batcat --diagnostic
    if !executable('batcat')
        echom "[fzf-cscope.vim] Please install `batcat` for fzf-preview: sudo apt install bat"
        finish
    endif

    if !executable('gawk')
        echom "[fzf-cscope.vim] Please install `gawk` for tags filter: sudo apt install gawk"
        finish
    endif

    " Keymap: <space>key, (+)advance ;key
    "         If using nvim-lspconfig neovim build-lsp plug, we can using them as our (+)advance mode
    "
    "  file     - ff            files         files from cscope.files
    "              +            files (all)   files from rg instance collect
    "  function - fs            mode-word     cscope 3(func-call),
    "                           mode-select   cscope 1(func-def),
    "                           mode-empty    tags all-function-uniq and filter-in 'g:fzfCscopeFilter'
    "              +            mode-word     cscope 0(symbol-all),
    "                           mode-select   cscope 0(symbol-all),
    "                           mode-empty    tags all-function-uniq
    "  symbol   - fw            mode-word     cscope 0(symbol) and filter-in 'g:fzfCscopeFilter'
    "                           mode-select   cscope 0(symbol) and filter-in 'g:fzfCscopeFilter'
    "                           mode-empty    tags not-func-symbol-uniq but filter-in 'g:fzfCscopeFilter'
    "              +            mode-word     cscope 9(be assigned value),
    "                           mode-select   cscope 9(be assigned value),
    "                           mode-empty    tags not-func-symbol-uniq
    "  symbol   - fe            same-as fw, but without filter
    "
    nnoremap <silent> <leader>ff    :"open Files            theCommand"<c-U>CSFileFilter<cr>
    vnoremap <silent> <leader>ff    :"open Files            theCommand"<c-U>CSFileFilter<cr>

    nnoremap <silent>        ;ff    :"open Files            theCommand"<c-U>CSFileFilter!<cr>
    vnoremap <silent>        ;ff    :"open Files            theCommand"<c-U>CSFileFilter!<cr>

    " 'nvim-lspconfig' clangd assign with the prefix ;
    "if HasNoPlug('nvim-lspconfig')
    "  nnoremap <silent>        ;fs    :     call cscope#preview('0', 'n', 1, 1)<cr>
    "  vnoremap <silent>        ;fs    :<c-u>call cscope#preview('0', 'v', 1, 1)<cr>
    "  nnoremap <silent>        ;fw    :     call cscope#preview('9', 'n', 0, 1)<cr>
    "  vnoremap <silent>        ;fw    :<c-u>call cscope#preview('9', 'v', 0, 1)<cr>
    "  nnoremap <silent>        ;fe    :     call cscope#preview('9', 'n', 0, 0)<cr>
    "  vnoremap <silent>        ;fe    :<c-u>call cscope#preview('9', 'v', 0, 0)<cr>
    "endif

    " Uppercase with filter define by g:fzfCscopeFilter
    " Symbol:
    nnoremap <silent> <leader>fs    :"(cscope)References        theCommand"<c-U>call cscope#preview('0', 'n', 0, 0)<cr>
    vnoremap <silent> <leader>fs    :"(cscope)References        theCommand"<c-U>call cscope#preview('0', 'v', 0, 0)<cr>
    nnoremap <silent> <leader>fS    :"(cscope)References(+)     theCommand"<c-U>call cscope#preview('0', 'n', 0, 1)<cr>
    vnoremap <silent> <leader>fS    :"(cscope)References(+)     theCommand"<c-U>call cscope#preview('0', 'v', 0, 1)<cr>

    " Function
    nnoremap <silent> <leader>fc    :"(cscope)Caller            theCommand"<c-U>call cscope#preview('3', 'n', 1, 0)<cr>
    vnoremap <silent> <leader>fc    :"(cscope)Caller            theCommand"<c-U>call cscope#preview('3', 'v', 1, 0)<cr>
    nnoremap <silent> <leader>fC    :"(cscope)Callee            theCommand"<c-U>call cscope#preview('2', 'n', 1, 0)<cr>
    vnoremap <silent> <leader>fC    :"(cscope)Callee            theCommand"<c-U>call cscope#preview('2', 'v', 1, 0)<cr>

    " Write
    nnoremap <silent> <leader>fw    :"(cscope)Write value       theCommand"<c-U>call cscope#preview('9', 'n', 0, 0)<cr>
    vnoremap <silent> <leader>fw    :"(cscope)Write value       theCommand"<c-U>call cscope#preview('9', 'v', 0, 0)<cr>
    nnoremap <silent> <leader>fW    :"(cscope)Write value(+)    theCommand"<c-U>call cscope#preview('9', 'n', 0, 1)<cr>
    vnoremap <silent> <leader>fW    :"(cscope)Write value(+)    theCommand"<c-U>call cscope#preview('9', 'v', 0, 1)<cr>

    " tExt
    nnoremap          <leader>fe    :"Search in               theCommand"<c-U><C-\>e utilgrep#Grep(0, 0, "", 1)<cr>
    nnoremap          <leader>f1    :"Search in 'wad'         theCommand"<c-U><C-\>e utilgrep#Grep(0, 0, "daemon/wad", 1)<cr>
    nnoremap          <leader>f2    :"Search in 'cmf'         theCommand"<c-U><C-\>e utilgrep#Grep(0, 0, "cmf/plugin", 1)<cr>
    " nnoremap        <leader>fe    :CscopeText! <c-r>=utils#GetSelected('')<cr>
    " vnoremap        <leader>fe    :<c-u>CscopeText! <c-r>=utils#GetSelected('')<cr>
    " nnoremap        <leader>fE    :CscopeGrep! <c-r>=utils#GetSelected('')<cr>
    " vnoremap        <leader>fE    :<c-u>CscopeGrep! <c-r>=utils#GetSelected('')<cr>

endif


if HasPlug('fzf-preview.vim')
    "nnoremap <leader>fF      :"(fzf)All files            theCommand"<c-U>FZFFiles<cr>
    nnoremap <leader>fg      :"(fzf)Grep                 theCommand"<c-U>FZFRg <c-r>=utils#GetSelected('n')<cr><cr>
    vnoremap <leader>fg      :"(fzf)Grep                 theCommand"<c-U>FZFRg <c-r>=utils#GetSelected('v')<cr>
endif


if HasPlug('fzf.vim') | " {{{1
    "nnoremap           ;vg   :"(fzf)git-status          theCommand"<c-U>GFiles?<cr>
    nnoremap           ;vc   :"(fzf)Changes             theCommand"<c-U>FZFChange<cr>
    "nnoremap           ;vb   :"(fzf)Buffers             theCommand"<c-U>Buffers<cr>
    "nnoremap           ;vm   :"(fzf)Marks               theCommand"<c-U>FZFMarks<cr>
    "nnoremap           ;vj   :"(fzf)Jumps               theCommand"<c-U>FZFJump<cr>
    "nnoremap           ;vl   :"(fzf)Lines               theCommand"<c-U>FZFBLines<cr>
    nnoremap           ;vw   :"(fzf)Windows             theCommand"<c-U>FZFWindows<cr>
    nnoremap           ;vh   :"(fzf)History             theCommand"<c-U>FZFHistory<cr>
    "nnoremap           ;vq   :"(fzf)Quickfix            theCommand"<c-U>FZFQuickFix<cr>
    "nnoremap           ;v:   :"(fzf)History:            theCommand"<c-U>History:<cr>
    "nnoremap           ;v/   :"(fzf)History/            theCommand"<c-U>History/<cr>
    "nnoremap           ;v;   :"(fzf)Commands            theCommand"<c-U>Commands<cr>


    let g:fzf_prefer_tmux = 1

    " Customize fzf colors to match your color scheme
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Function'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = '~/.local/share/fzf-history'

    command! -bang -nargs=? -complete=dir FilePre
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    command! -bang -nargs=* RgType
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -t c '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)


    ""https://github.com/junegunn/fzf.vim/issues/185
    ""CTRL-A CTRL-Q to select all and build quickfix list
    "function! s:build_quickfix_list(lines)
    "  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    "  copen
    "  cc
    "endfunction
    "
    "let g:fzf_action = {
    "  \ 'ctrl-q': function('s:build_quickfix_list'),
    "  \ 'ctrl-t': 'tab split',
    "  \ 'ctrl-x': 'split',
    "  \ 'ctrl-v': 'vsplit' }
    "
    "let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
endif


if HasPlug('telescope.nvim')
    nnoremap           ;vF   :"(fzf)All files           theCommand"<c-U>Telescope find_files<cr>

    nnoremap           ;vy   :"(fzf)Yanks               theCommand"<c-U>Telescope yank_history<cr>
    nnoremap           ;va   :"(fzf)autoCmd             theCommand"<c-U>Telescope autocommands<cr>
    nnoremap           ;vb   :"(fzf)Buffers             theCommand"<c-U>Telescope buffers<cr>
    nnoremap           ;vC   :"(fzf)git-commits         theCommand"<c-U>Telescope git_commits<cr>
    nnoremap           ;vm   :"(fzf)Marks               theCommand"<c-U>Telescope marks<cr>
    nnoremap           ;vM   :"(fzf)Key maps            theCommand"<c-U>Telescope keymaps<cr>
    nnoremap           ;vj   :"(fzf)Jumps               theCommand"<c-U>Telescope jumplist<cr>
    nnoremap    <leader>fl   :"(fzf)Lines               theCommand"<c-U>Telescope current_buffer_fuzzy_find<cr>
    nnoremap    <leader>fL   :"(fzf)Live-grep           theCommand"<c-U>Telescope live_grep<cr>
    nnoremap           ;vd   :"(fzf)Diagnostics         theCommand"<c-U>Telescope diagnostics<cr>
    nnoremap           ;vq   :"(fzf)Quickfix            theCommand"<c-U>Telescope quickfix<cr>
    nnoremap           ;vQ   :"(fzf)Quickfix-History    theCommand"<c-U>Telescope quickfixhistory<cr>
    nnoremap           ;v/   :"(fzf)History/            theCommand"<c-U>Telescope search_history<cr>
    nnoremap           ;v:   :"(fzf)Commands            theCommand"<c-U>Telescope commands<cr>
    nnoremap           ;v;   :"(fzf)Commands-History    theCommand"<c-U>Telescope command_history<cr>
endif


" Git {{{3
if HasPlug('vim-gitgutter')
    nnoremap <silent> ;gv   :"(git)GutterToggle          theCommand"<c-U>GitGutterToggle <cr>
    nnoremap <silent> ;gr   :"(git)Gutter                theCommand"<c-U>GitGutter <cr>
    "nnoremap <silent> ;gf  :"(git)Gutter sink-to QuickFix "<c-U>GitGutterQuickFix \| copen <cr>

    " Jump between hunks
    nnoremap <silent> ;gn   <Plug>(GitGutterNextHunk)
    nnoremap <silent> ;gp   <Plug>(GitGutterPrevHunk)

    " Hunk-add and hunk-revert for chunk staging
    nnoremap <silent> ;ga   <Plug>(GitGutterStageHunk)
    nnoremap <silent> ;gu   <Plug>(GitGutterUndoHunk)
endif

if HasPlug('vim-fugitive')
    "nnoremap <leader>bb :VCBlame<cr>
    nnoremap <leader>gl     :"(git)Log side by side    theCommand"<c-U>GV<cr>
    nnoremap <leader>gd     :"(git)Diff review         theCommand"<c-U>Gvdiff<cr>
    nnoremap <leader>gD     :"(git)Diff review tabs    theCommand"<c-U>DiffReview git show
    nnoremap <leader>gb     :"(git)Blame               theCommand"<c-U>Git blame<cr>
    nnoremap <leader>bb     :"(git)Blame               theCommand"<c-U>Git blame<cr>
    nnoremap <leader>gs     :"(git)Status              theCommand"<c-U>Gstatus<cr>
endif

if HasPlug('tig-explorer.vim')
    nnoremap <leader>gL     :"(tig)Log                 theCommand"<c-U>Tig<cr>
    nnoremap <leader>gp     :"(tig)Log --parent        theCommand"<c-U>Tig --first-parent -m<cr>
    nnoremap <leader>gP     :"(tig)Log --parent all    theCommand"<c-U>Tig --first-parent --all<cr>
    nnoremap <leader>gB     :"(tig)Blame               theCommand"<c-U>TigBlame<cr>
endif


if HasPlug('coc.nvim')
    autocmd CmdwinEnter * let b:coc_suggest_disable = 1
endif

if CheckPlug('vim-eval', 1) | " {{{1
    let g:eval_viml_map_keys = 0
endif


if CheckPlug('vim-quickrun', 1) | " {{{1
    let g:eval_viml_map_keys = 0
endif


if CheckPlug('vim-repl', 1) | " {{{1
    let g:repl_position = 3
    let g:repl_cursor_down = 1

    let g:repl_program = {
                \   'python': 'ipython',
                \   'default': 'zsh',
                \   'r': 'R',
                \   'lua': 'lua',
                \   'vim': 'vim -e',
                \   }
    let g:repl_predefine_python = {
                \   'numpy': 'import numpy as np',
                \   'matplotlib': 'from matplotlib import pyplot as plt'
                \   }
    let g:repl_python_automerge = 1
    let g:repl_ipython_version = '7'
endif


if CheckPlug('vim-sleuth', 1) | " {{{1
    let g:sleuth_automatic = 1
endif


if CheckPlug('vim-submode', 1) | " {{{1
    " A message will appear in the message line when you're in a submode
    " and stay there until the mode has existed.
    let g:submode_always_show_submode = 1
    "let g:submode_keep_leaving_key=1
    let g:submode_timeout = 0
    "let g:submode_timeoutlen=5000

    " Implement feature 'dstein64/vim-win'
        " We're taking over the default <C-w> setting. Don't worry we'll do
        " our best to put back the default functionality.
        call submode#enter_with('window', 'n', '', '<C-w>')
        " Note: <C-c> will also get you out to the mode without this mapping.
        " Note: <C-[> also behaves as <ESC>
        call submode#leave_with('window', 'n', '', '<ESC>')
                " Go through every letter
                for key in ['a','b','c','d','e','f','g','h','i','j','k','l','m',
                \           'n','o','p','q','r','s','t','u','v','w','x','y','z']
                  " maps lowercase, uppercase and <C-key>
                  call submode#map('window', 'n', '', key, '<C-w>' . key)
                  call submode#map('window', 'n', '', toupper(key), '<C-w>' . toupper(key))
                  call submode#map('window', 'n', '', '<C-' . key . '>', '<C-w>' . '<C-'.key . '>')
                endfor
                " Go through symbols. Sadly, '|', not supported in submode plugin.
                for key in ['=','_','+','-','<','>']
                  call submode#map('window', 'n', '', key, '<C-w>' . key)
                endfor

        " Old way, just in case.
        nnoremap <Leader>w <C-w>
endif


if CheckPlug('nvim-libmodal', 1) | " {{{1
    " Mode windows: Implement feature 'dstein64/vim-win'
        nnoremap <Leader>w :call <sid>windowsMode()<cr>

        let s:windowsModeRecurse = 0
        let s:windowsModeCombos = {
                    \   'j': 'wincmd j',
                    \   'k': 'wincmd k',
                    \   'h': 'wincmd h',
                    \   'l': 'wincmd l',
                    \   'H': '3 wincmd >',
                    \   'L': '3 wincmd <',
                    \   'J': '3 wincmd +',
                    \   'K': '3 wincmd -',
                    \   'r': 'wincmd r',
                    \   'x': 'wincmd x',
                    \}

        " define the BarMode() function which is called whenever the user presses 'z'
        function! s:windowsMode()
            let s:windowsModeRecurse += 1
            call libmodal#Enter('windows' . s:windowsModeRecurse, s:windowsModeCombos)
            let s:windowsModeRecurse -= 1
        endfunction
endif


if HasPlug('vim-multiple-cursors') | " {{{1
    let g:multi_cursor_use_default_mapping=0
endif


if HasPlug('vim-visual-multi')
    " https://github.com/mg979/vim-visual-multi/wiki/Quick-start#cursor-mode-vs-extend-mode
    let g:VM_maps = {}
    let g:VM_maps['Find Under']         = '<C-d>'
    let g:VM_maps['Find Subword Under'] = '<C-d>'
endif


if HasPlug('delimitMate') | " {{{1
    let delimitMate_expand_space = 1
    let delimitMate_expand_cr = 2
    "let delimitMate_jump_expansion = 1
    let delimitMate_expand_inside_quotes = 1
    let delimitMate_nesting_quotes = ['"','`']
    let delimitMate_excluded_regions = ""
endif


if HasPlug('vwm.vim') | " {{{1
    " Example layouts

    " Vista attempts to move itself, the sleep prevents a race.
    let s:dev_panel = {
          \  'default': {
          \      'name': 'default',
          \      'opnAftr': ['edit'],
          \      'right': {
          \          'v_sz': 33,
          \          'init': ['NERDTree'],
          \          'bot': {
          \              'init': ['Vista', 'sleep 50ms']
          \          }
          \      }
          \  }
          \}


    "Make sure the right tab is closed on vimdiff toggle
    fun! s:open_vimdiff()
      tabnew
      setlocal bh=wipe " Vwm always makes it's open buffer so get rid of this buf when it's closed
      let s:vimdiff_tid = tabpagenr()
    endfun

    fun! s:close_vimdiff()
      execute(s:vimdiff_tid . 'tabn')
      tabclose
    endfun

    let s:vimdiff = {
          \  'vimdiff': {
          \      'name': 'vimdiff',
          \      'opnBfr': [function('s:open_vimdiff')],
          \      'clsAftr': [function('s:close_vimdiff')],
          \      'set_all': ['nobl', 'bh=wipe', 'nomodified'],
          \      'init': ['normal imerge'],
          \      'top': {
          \          'init': ['normal ibase'],
          \          'left': {
          \              'init': ['normal ilocal']
          \          },
          \          'right': {
          \              'init': ['normal iremote']
          \          }
          \      }
          \  }
          \}

    let s:frame = {
          \  'frame': {
          \      'name': 'frame',
          \      'top': {
          \          'init': ['norm itop'],
          \          'left': {
          \              'init': ['norm itop-left']
          \          },
          \          'right': {
          \              'init': ['norm itop-right']
          \          }
          \      },
          \      'bot': {
          \          'init': ['norm ibot'],
          \          'left': {
          \              'init': ['norm ibot-left']
          \          },
          \          'right': {
          \              'init': ['norm ibot-right']
          \          }
          \      },
          \      'left': {
          \          'init' :['norm ileft']
          \      },
          \      'right': {
          \          'init' :['norm iright']
          \      }
          \  }
          \}

    let s:bot_panel = {
          \  'bot_panel': {
          \      'name': 'bot_panel',
          \      'bot': {
          \          'h_sz': 12,
          \          'left': {
          \              'init': []
          \          }
          \      }
          \  }
          \}

    if !exists('g:vwm#layouts')
        let g:vwm#layouts = {}
    endif

    let g:vwm#layouts = hw#misc#merge(g:vwm#layouts, s:dev_panel)
    let g:vwm#layouts = hw#misc#merge(g:vwm#layouts, s:vimdiff)
    let g:vwm#layouts = hw#misc#merge(g:vwm#layouts, s:frame)
    let g:vwm#layouts = hw#misc#merge(g:vwm#layouts, s:bot_panel)

    if exists('g:vwm#active')
        VwmReinit
    endif
endif


if HasPlug('vim-projectionist') | " {{{1
    function! VimConfigLoadProjectionistJson(proj_jsn)
        " filter-out the comment line: beginwith '//'
        let l:json = filter(readfile(a:proj_jsn), 'match(v:val, "\s*//.*") < 0')
        let l:dict = projectionist#json_parse(l:json)
        call projectionist#append(getcwd(), l:dict)
    endfunction
endif

if HasPlug('vim-gitgutter') | " {{{1
    let g:gitgutter_enabled = 0
    let g:gitgutter_map_keys = 0
    let g:gitgutter_max_signs = 500  " default value (Vim < 8.1.0614, Neovim < 0.4.0)
    let g:gitgutter_show_msg_on_hunk_jumping = 0
    let g:gitgutter_override_sign_column_highlight = 1
    let g:gitgutter_highlight_lines = 1
    let g:gitgutter_preview_win_floating = 1
    let g:gitgutter_diff_relative_to = 'index'  " default 'index', 'working_tree'

    " Use fontawesome icons as signs
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '>'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_sign_removed_first_line = '^'
    let g:gitgutter_sign_modified_removed = '<'
endif


if HasPlug('vim-diff-enhanced') | " {{{1
    set diffopt+=internal,algorithm:patience
    "EnhancedDiffIgnorePat ^WARNING:.*
    let g:enhanced_diff_ignore_pat = '^WARNING:.*'
endif


if HasPlug('editorconfig-vim') | " {{{1
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
    au FileType gitcommit let b:EditorConfig_disable = 1
    let g:EditorConfig_disable_rules = ['trim_trailing_whitespace']
endif

if HasPlug('vim-searchindex') | " {{{1
    let g:searchindex_line_limit=1000000
endif


if HasPlug('any-jump.vim') | " {{{1
    let g:any_jump_disable_default_keybindings = 1
    nnoremap ;jj :AnyJump<CR>
    xnoremap ;jj :AnyJumpVisual<CR>
    nnoremap ;jb :AnyJumpBack<CR>
    nnoremap ;jl :AnyJumpLastResults<CR>

    " Prefered search engine: rg or ag
    let g:any_jump_search_prefered_engine = 'ag'
endif


if HasPlug('nerdcommenter') | " {{{1
    let g:NERDCreateDefaultMappings = 0
    let g:NERDCompactSexyComs = 1
    let g:NERDSpaceDelims = 1
    let g:NERDDefaultAlign = 'left'
    let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
    let g:NERDAltDelims_java = 1
    let g:NERDCommentEmptyLines = 1
    let g:NERDTrimTrailingWhitespace = 1
    let g:NERDToggleCheckAllLines = 1

    " Remap as <c-/>
    nnoremap <silent> <c-_>    :call nerdcommenter#Comment('n', "Sexy")<cr>
    xnoremap <silent> <c-_>    :call nerdcommenter#Comment('x', "Sexy")<cr>gv

    "nnoremap    <leader>c   :"Comment toggle but not fancy!              "<c-U>call nerdcommenter#Comment('n', "Toggle")<cr>
    "xnoremap    <leader>c                                                     :call nerdcommenter#Comment('x', "Toggle")<cr>gv
    "nnoremap    ;c      :"Comment: <C-/> or <leader>c add,   <;c> uncomment"<c-U>call nerdcommenter#Comment('n', "Uncomment")<cr>
    "xnoremap    ;c                                                            :call nerdcommenter#Comment('x', "Uncomment")<cr>gv
endif


if HasPlug('vim-signify') | " {{{1
    " Diff by commit SHA: 76748de92fa
    "             OR SHA..HEAD:
    let g:signify_sha_range = $VimGit

    if len(g:signify_sha_range) > 8
        echomsg "GitGutter by "..g:signify_sha_range
        let g:signify_vcs_cmds = {
                \ 'git': 'git diff '.. g:signify_sha_range .. ' --no-color --no-ext-diff -U0 -- %f'
                \ }
    else
        let g:signify_vcs_cmds = {
                \ 'git': 'git diff HEAD --no-color --no-ext-diff -U0 -- %f'
                \ }
    endif
endif


if HasPlug('cheatsheet.nvim')
    let g:coq_settings = {
                \ 'auto_start': 'shut-up',
                \ 'display.icons.mode': 'none',
                \}
endif


if HasPlug('neomux')
    " If don't change from <leader> to ';', cause the terminal <space> slow
    "   We can check by :verbose tmap <leader>
    let g:neomux_no_exit_term_map = 1
    let g:neomux_exit_term_mode_map = ";sX"

    let g:neomux_start_term_map = ";sx"
    let g:neomux_start_term_split_map = ";sh"
    let g:neomux_start_term_vsplit_map = ";sv"
endif


if HasPlug('vim-windowswap')
    let g:windowswap_map_keys = 0
    "nnoremap <silent> <leader>wy :call WindowSwap#MarkWindowSwap()<CR>
    "nnoremap <silent> <leader>wp :call WindowSwap#DoWindowSwap()<CR>
    nnoremap <silent> <leader>va :"(view)BufferWindowSwap              theCommand"<c-U>call WindowSwap#EasyWindowSwap()<CR>
endif


if HasPlug('vim-terminal-help')
    let g:terminal_key = "<C-\\>"
    let g:terminal_cwd = 0
    let g:terminal_shell = "/bin/bash"
    let g:terminal_kill = "term"
    let g:terminal_list = 0
    let g:terminal_close = 1
endif


if HasPlug('nvim-lspconfig')
    if HasPlug('fzf-lsp.nvim')
        nnoremap <silent>        ;fD    :Declarations <cr>
        nnoremap <silent>        ;fd    :Definitions <cr>
        nnoremap <silent>        ;fi    :Implementations <cr>
        nnoremap <silent>        ;fr    :CodeActions <cr>
        nnoremap <silent>        ;fs    :References <cr>
        nnoremap <silent>        ;f1    :IncomingCalls <cr>
        nnoremap <silent>        ;f2    :OutgoingCalls <cr>
        nnoremap <silent>        ;f3    :Diagnostics <cr>
        nnoremap <silent>        ;f4    :DiagnosticsAll <cr>
    endif
endif


if HasPlug('neo-tree.nvim')
    let s:viewBuff = 0
    fun s:toggleBuffers()
        if s:viewBuff == 0
            let s:viewBuff = 1
            exec 'Neotree buffers'
        else
            let s:viewBuff = 0
            exec 'Neotree close buffers'
        endif
    endfunc


    let s:viewGit = 0
    fun s:toggleGitStatus()
        if s:viewGit == 0
            let s:viewGit = 1
            exec 'Neotree git_status'
        else
            let s:viewGit = 0
            exec 'Neotree close git_status'
        endif
    endfunc

    nnoremap  <silent> <leader>vE  :"(view)Explore File           theCommand"<c-U>Neotree toggle<cr>
    nnoremap  <silent> <leader>vF  :"(view)Explore Focus          theCommand"<c-U>Neotree reveal<cr>
    nnoremap  <silent> <leader>vb  :"(view)Explore buffer         theCommand"<c-U>call <sid>toggleBuffers()<cr>
    nnoremap  <silent> <leader>vg  :"(view)Explore git            theCommand"<c-U>call <sid>toggleGitStatus()<cr>
endif


if HasPlug('nvim-notify')
    lua vim.notify = require("notify")
endif


if HasPlug('vim-expand-region')
    map W <Plug>(expand_region_expand)
    map B <Plug>(expand_region_shrink)
endif

if HasPlug('nvim-autopairs')
    lua require("nvim-autopairs").setup {}
endif

if HasPlug('toggleterm.nvim')
    lua require("toggleterm").setup()
endif

if HasPlug('wilder.nvim')
    " Disable auto active, but <tab> it
    call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'enable_cmdline_enter': 0,
      \ })

    " Can also be passed to the 'highlights' option
    call wilder#set_option('renderer', wilder#popupmenu_renderer({
                \ 'highlighter': wilder#basic_highlighter(),
                \ 'highlights': {
                \   'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}]),
                \ },
                \ }))

endif

