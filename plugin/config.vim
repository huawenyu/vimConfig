" Version:      1.0

if exists('g:loaded_myplugs_config') || &compatible
  finish
else
  let g:loaded_myplugs_config = 'yes'
endif


let g:AutoPairsFlyMode = 1

if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif

" vimfiler {{{2}}}
let g:vimfiler_as_default_explorer = 1
"let g:signify_vcs_list = [ 'git', 'svn' ]

" indentwise: 'T@ 193-'
"let g:indentwise_skip_prefix = 7
"let g:indentwise_preserve_col_pos = 1

" vebugger {{{2}}}
"let g:vebugger_leader = ';'

" neogdb.vim {{{2}}}
"let g:neogdb_window = ['backtrace', 'breakpoint']
let g:gdb_require_enter_after_toggling_breakpoint = 0

let g:neogdb_gdbserver = 'dut.py'
if exists("$NBG_ATTACH_REMOTE_STR")
  let g:neogdb_attach_remote_str = $NBG_ATTACH_REMOTE_STR
else
  let g:neogdb_attach_remote_str = 'sysinit/init dut:444 -u admin -p "" -t "gdb:wad"'
endif

" tabman: disable old config {{{2
    let g:tabman_toggle = '<leader>xt'
    let g:tabman_focus  = '<leader>xf'
"}}}

" neocomplcache {{{2
    let g:acp_enableAtStartup = 0
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
"}}}

" tcl.vim{{{2
    let tcl_extended_syntax=1
"}}}

" vim-rooter{{{2
    let g:rooter_manual_only = 1
    let g:rooter_patterns = ['Rakefile', '.git', '.git/', '.svn', '.svn/']
"}}}

" neomake: make & asynrun{{{2
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
"}}}

" fuzzy{{{2
    "let g:fuzzy_file_list = ["cscope.files"]
    "let g:fuzzy_file_tag = ['tags.x', '.tags.x']
"}}}

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" neoterm{{{2
    let g:neoterm_default_mod = 'vertical'
    let g:neoterm_autoinsert = 1
"}}}

" easymotion {{{2
    let g:EasyMotion_do_mapping = 0 " Disable default mappings

    " Jump to anywhere you want with minimal keystrokes, with just one key binding.
    " `s{char}{label}`
    nmap s <Plug>(easymotion-overwin-f)

    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    "nmap s <Plug>(easymotion-overwin-f2)
"}}}


" autotag {{{2
" Logfile: /tmp/vim-autotag.log
    let g:autotagVerbosityLevel = 10
    let g:autotagmaxTagsFileSize = 50 * 1024 * 1024
    let g:autotagCtagsCmd = "LC_COLLATE=C ctags --extra=+f"
    let g:autotagTagsFile = ".tags"
    let s:autotag_inter = 10
    let g:autotagExcSuff = ['tml', 'xml', 'text', 'txt', 'md', 'mk', 'conf', 'html', 'yml', 'css', 'scss']
"}}}

" AsyncRun {{{2
    let g:asyncrun_silent = 1
    let g:asyncrun_open = 8
"}}}

" vim-bookmarks {{{2
    let g:bookmark_no_default_key_mappings = 1
    let g:bookmark_highlight_lines = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 0
    let g:bookmark_show_warning = 0
    "let g:bookmark_location_list = 1
"}}}

" vim-tmux-navigator{{{2
    "" Disable tmux navigator when zooming the Vim pane
    let g:tmux_navigator_disable_when_zoomed = 1
    "let g:tmux_navigator_no_mappings = 1
    "nnoremap <silent> <a-h> :TmuxNavigateLeft<cr>
    "nnoremap <silent> <a-j> :TmuxNavigateDown<cr>
    "nnoremap <silent> <a-k> :TmuxNavigateUp<cr>
    "nnoremap <silent> <a-l> :TmuxNavigateRight<cr>
    "nnoremap <silent> <a-\> :TmuxNavigatePrevious<cr>
"}}}

" EasyAlign {{{2
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nnoremap ga <Plug>(EasyAlign)
"}}}

" netrw {{{2
    "let g:netrw_banner = 0
    "let g:netrw_liststyle = 3
    "let g:netrw_browse_split = 4
    "let g:netrw_altv = 1
    "let g:netrw_winsize = 16
    "let g:netrw_list_hide='.*\.png$,.*\.pdf,.*\.mp4,.*\.tga,.*\.mp3,.*\.jpg,.*\.svg,/*\.stl,.*\.mtl,.*\.ply' 
"}}}

" NerdTree/NerdComment {{{2
    let NERDTreeMouseMode = 3
    let NERDTreeAutoDeleteBuffer = 1
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let NERDTreeAutoDeleteBuffer = 1
    let NERDTreeRespectWildIgnore = 1
    "let NERDTreeShowBookmarks = 1
    let NERDTreeWinSize = 25
    let g:NERDTreeIgnore = ['^build$', 'rusty-tags.vi', '^target$', 'tags']

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
    let g:NERDTrimTrailingWhitespace = 1
"}}}

" Defx {{{2
let g:defx_icons_enable_syntax_highlight = 0

" Buffergator{{{2
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
"}}}

" voom {{{3}}}
let g:voom_tree_width = 45
let g:voom_tree_placement = 'right'


" Gist {{{2}}}
let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_get_multiplefile = 1

let g:tlTokenList = ["FIXME @wilson", "TODO @wilson", "XXX @wilson"]
let g:ctrlsf_mapping = { "next": "n", "prev": "N", }

" startify&Session {{{2
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
"}}}

" vim workspace {{{2
    let g:workspace_session_name = '.Session.vim'
    let g:workspace_autosave_always = 0
    let g:workspace_persist_undo_history = 0
    " disable auto trim the trail-spaces
    let g:workspace_autosave_untrailspaces = 0
    let g:workspace_session_disable_on_args = 1
"}}}

" vim-session {{{2
    let g:session_directory = getcwd()
    let g:session_default_name = ".Session"
    let g:session_default_overwrite = 1
    let g:session_autoload = 'yes'
    let g:session_autosave = 'yes'
    let g:session_autosave_periodic = 1
    let g:session_autosave_silent = 1
"}}}

" Deoplete {{{2}}}
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" w3m {{{2}}}
let g:w3m#command = '/usr/bin/w3m'
let g:w3m#lang = 'en_US'

" plasticboy/vim-markdown {{{2
  " ge: jump follow link
  " gx: open link in browser
  "
  "set conceallevel=0
  "let g:vim_markdown_conceal = 1
  "let g:vim_markdown_toc_autofit = 1
  "
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_override_foldtext = 0
  let g:vim_markdown_folding_level = 6
  let g:vim_markdown_folding_style_pythonic = 1
  "
  let g:vim_markdown_emphasis_multiline = 0
  let g:vim_markdown_new_list_item_indent = 2
  "let g:vim_markdown_no_default_key_mappings = 1
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_fenced_languages = ['C=c', 'c=c', 'Shell=sh', 'Java=java'
        \ , 'Csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
  let g:vim_markdown_autowrite = 1       | " automatically save before jump
  let g:vim_markdown_follow_anchor = 1   | " `ge` command to follow anchors: file#anchor or #anchor
  let g:vim_markdown_strikethrough = 1   | " ~~Scratch this.~~
  "let g:vim_markdown_no_extensions_in_markdown = 1      | "`ge`: [link text](link-url), the (link-url) part donnot need .md extention
"}}}

let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\       'pattern' : ".",
\       'repeat' : 0}
\      ]
\}

" CommandT {{{2}}}
let g:CommandTHighlightColor = 'Ptext'
let g:CommandTNeverShowDotFiles = 1
let g:CommandTScanDotDirectories = 0

" taglist tagbar plugin {{{2
  "let g:tagbar_autoclose = 1
  let g:tagbar_sort = 0
  let g:tagbar_width = 40
  let g:tagbar_compact = 1
  let g:tagbar_silent = 1
  let g:tagbar_indent = 2
  let g:tagbar_foldlevel = 4
  let g:tagbar_iconchars = ['+', '-']
  let g:tagbar_map_hidenonpublic = "`"
  let g:tagbar_map_close = "q"

  "let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Auto_Update = 0
  let Tlist_Show_Menu = 0
  let Tlist_Use_Right_Window = 1
  let Tlist_WinWidth = 40
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Show_One_File = 1
  let Tlist_Use_SingleClick = 1
  let Tlist_Enable_Fold_Column = 0
"}}}

let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1
let g:utilquickfix_file = $HOME."/.vim/vim.quickfix"
let g:vim_json_syntax_conceal = 0

" sneek motion {{{2}}}
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0
let g:enable_numbers = 0

" vimwiki
" {'path': '$HOME/wiki', 'auto_toc': 1, 'syntax': 'markdown', 'ext': '.md', 'maxhi': 1, 'auto_tags': 1},
let g:vimwiki_list = [
      \{'name': 'work', 'path': '$HOME/dotwiki', 'syntax': 'markdown', 'auto_toc': 1, 'maxhi': 1, 'auto_tags': 1},
      \{'name': 'linux', 'path': '$HOME/wiki', 'syntax': 'markdown', 'auto_toc': 1, 'maxhi': 1, 'auto_tags': 1},
      \]

let g:vimwiki_menu = ""         | "Disable error msg: No menu 'Vimwiki'
"let g:vimwiki_url_maxsave = 0
let g:vimwiki_conceallevel = 0 | "Default=2, -1 Disable conceal

" Python-mode{{{2
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
"}}}


" Jedi-vim{{{2
  " leader+t:   doctest
  let g:jedi#completions_command = "<C-Space>"
  let g:jedi#goto_command = "<leader>gg"
  let g:jedi#goto_assignments_command = "<leader>gd"
  let g:jedi#goto_definitions_command = "<C-]>"
  let g:jedi#documentation_command = "<leader>k"
  let g:jedi#usages_command = "<leader>u"
  let g:jedi#rename_command = ""
"}}}

" SingleCompile{{{2
  let g:SingleCompile_usequickfix=1
"}}}

" Golang-mode{{{2
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

  au FileType go nmap <leader>gr <Plug>(go-run)
  au FileType go nmap <leader>gb <Plug>(go-build)
  au FileType go nmap <leader>gt <Plug>(go-test)
  au FileType go nmap <leader>gc <Plug>(go-coverage)
  au FileType go nmap <leader>gd <Plug>(go-doc)<Paste>
  au FileType go nmap <leader>gi <Plug>(go-info)
  au FileType go nmap <leader>ge <Plug>(go-rename)
  au FileType go nmap <leader>gg <Plug>(go-def-vertical)
"}}}

" Haskell-mode{{{2
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
"}}}

"======================================================================
" Tabularize{{{2
    if exists(":Tabularize")
      nnoremap <leader>a= :Tabularize /=<CR>
      vmap <leader>a= :Tabularize /=<CR>
      nnoremap <leader>a: :Tabularize /:\zs<CR>
      vmap <leader>a: :Tabularize /:\zs<CR>
    endif
"}}}

" Disable warning: Clipboard error : Target STRING not available when running
let g:yankring_clipboard_monitor=0

" vim-yoink: yank/paste {{{2
    let g:yoinkIncludeDeleteOperations=0
    let g:yoinkSavePersistently=1
    let g:yoinkMoveCursorToEndOfPaste=1
    let g:yoinkIncludeNamedRegisters=1
    let g:yoinkSyncNumberedRegisters=1
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
"}}}


" vim-gutentags {{{1
    let g:cutils_cscope_map = 1
    if !g:cutils_cscope_map
        " Disable auto-load gtags file
        let g:gutentags_auto_add_gtags_cscope = 1

        " touch .root
        let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project', 'Makefile']
        let g:gutentags_ctags_tagfile = '.tags'

        "let s:vim_tags = expand('./.ccls-cache')
        "let g:gutentags_cache_dir = s:vim_tags
        "if !isdirectory(s:vim_tags)
        "    silent! call mkdir(s:vim_tags, 'p')
        "endif

        let g:gutentags_modules = []
        "if executable('ctags')
        "    let g:gutentags_modules += ['ctags']
        "endif
        if executable('gtags-cscope') && executable('gtags')
            let g:gutentags_modules += ['gtags_cscope']
        endif

        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--exclude=.git', '--exclude=node_modules', '--exclude=.ccls-cache']
        if filereadable("./cscope.files")
            let g:gutentags_ctags_extra_args += ['-L cscope.files']
        endif

        " Force universal ctags to generate old ctags format
        let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

        " gutentags_plus
        let g:cutils_cscope_map = 0
        let g:gutentags_plus_nomap = 1
        noremap <silent> <leader>fs :GscopeFind s <C-R><C-W><cr>
        noremap <silent> <leader>fg :GscopeFind g <C-R><C-W><cr>
        noremap <silent> <leader>fc :GscopeFind c <C-R><C-W><cr>
        noremap <silent> <leader>ft :GscopeFind t <C-R><C-W><cr>
        noremap <silent> <leader>fe :GscopeFind e <C-R><C-W><cr>
        noremap <silent> <leader>ff :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fd :GscopeFind d <C-R><C-W><cr>
        noremap <silent> <leader>fa :GscopeFind a <C-R><C-W><cr>

        "let g:gutentags_plus_nomap = 1
        "noremap <silent> <leader>fs :cs find s <C-R><C-W><cr>
        "noremap <silent> <leader>fg :cs find g <C-R><C-W><cr>
        "noremap <silent> <leader>fc :cs find c <C-R><C-W><cr>
        "noremap <silent> <leader>ft :cs find t <C-R><C-W><cr>
        "noremap <silent> <leader>fe :cs find e <C-R><C-W><cr>
        "noremap <silent> <leader>ff :cs find f <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fi :cs find i <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fd :cs find d <C-R><C-W><cr>
        "noremap <silent> <leader>fa :cs find a <C-R><C-W><cr>
    endif
"}}}

" using coc.vim/ale with ccls-cache which base on clang {{{1
    nmap <silent> <a-]> <Plug>(coc-definition)
    nmap <silent> <a-\> <Plug>(coc-references)
    nmap <silent> <a-h> <Plug>(coc-type-definition)
    nmap <silent> <a-j> <Plug>(coc-implementation)
    nmap <silent> <a-[> call CocAction('doHover')
    nmap <silent> <a-r> <Plug>(coc-rename)
    nmap <silent> <a-,> <Plug>(coc-diagnostic-prev)
    nmap <silent> <a-.> <Plug>(coc-diagnostic-next)

    "autocmd CursorHold * silent call CocActionAsync('highlight')
"}}}

" using ale.vim ccls {{{1
    "nmap <silent> <a-]> :ALEGoToDefinition<cr>
    "nmap <silent> <a-\> :ALEFindReferences<cr>
    "nmap <silent> <a-h> :ALESymbolSearch<cr>
    "nmap <silent> <a-[> :ALEHover<cr>
    "nmap <silent> <a-,> <Plug>(ale_previous_wrap)
    "nmap <silent> <a-.> <Plug>(ale_next_wrap)

    "let g:ale_cpp_ccls_init_options = {
    "  \   'cache': {
    "  \       'directory': './ccls-cache',
    "  \   },
    "  \ }
    ""let g:ale_completion_enabled = 1
    "call deoplete#custom#option('sources', {
    "  \ '_': ['ale'],
    "  \})

    "let g:ale_lint_on_text_changed = 'never'
    "let g:ale_lint_on_insert_leave = 0
    "let g:ale_lint_on_enter = 0
    ""let g:ale_lint_on_save = 0
    ""let g:ale_list_window_size = 5
    "let g:ale_open_list = 1
    "let g:ale_set_loclist = 0
    "let g:ale_set_quickfix = 1
    "let g:ale_keep_list_window_open = 1
"}}}

" vim-prettier{{{1
    nmap <Leader>fm <Plug>(Prettier)

    let g:prettier#autoformat = 0
    let g:prettier#quickfix_enabled = 0
    let g:prettier#quickfix_auto_focus = 0
"}}}

" todo.vim{{{1
"   :Todo
"   :Todo {filter}
    let g:todo_root = '~/tools/todo.txt-cli-ex/todo'
    let g:todo_open_command = '~/tools/todo.txt-cli-ex/todo.sh'
"}}}

" vim-taskwarrior/taskwiki{{{1
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
"}}}

" vim-editqf/vim-qf {{{1
    "let g:editqf_no_mappings = 1
    "let g:editqf_saveqf_filename  = "vim.qf"
    "let g:editqf_saveloc_filename = "vim.qflocal"

    " Please silent and don't make troubles
    "let g:qf_mapping_ack_style = 0       | " donnot set this variable, for exist() trigger the keymap
    let g:qf_window_bottom = 0
    let g:qf_loclist_window_bottom = 0
    let g:qf_auto_open_quickfix = 0
    let g:qf_auto_open_loclist = 0
    let g:qf_auto_resize = 0
    let g:qf_auto_quit = 0
    let g:qf_save_win_view = 0
    let g:qf_max_height = 4

    "nnoremap <leader>mn :QFAddNote note:
    nnoremap <leader>ms :SaveList
    nnoremap <leader>mS :SaveListAdd
    nnoremap <leader>ml :LoadList
    nnoremap <leader>mL :LoadListAdd
    nnoremap <leader>mo :copen<cr>
    nnoremap <leader>mn :cnewer<cr>
    nnoremap <leader>mp :colder<cr>

    nnoremap <leader>md :Doline
    nnoremap <leader>mx :RemoveList
    nnoremap <leader>mh :ListLists<cr>
    "nnoremap <leader>mk :Keep
    nnoremap <leader>mF :Reject
"}}}

" vim-cpp-enhanced-highlight{{{1
    let g:cpp_class_scope_highlight = 0
    let g:cpp_member_variable_highlight = 0
    let g:cpp_class_decl_highlight = 0
    let g:cpp_experimental_simple_template_highlight = 0
    let g:cpp_experimental_template_highlight = 0
    let g:cpp_concepts_highlight = 0
    let g:cpp_no_function_highlight = 0
"}}}

" vim-grepper{{{1
    let g:grepper = {}
    let g:grepper.highlight = 0
    let g:grepper.open = 1
    let g:grepper.quickfix = 1
    let g:grepper.switch = 0
    let g:grepper.jump = 0
"}}}

" vim-tmux-runner{{{1
    let g:VtrClearBeforeSend = 0
    "let g:vtr_filetype_runner_overrides = {
    "      \ 'ruby': 'ruby -w {file}',
    "      \ 'haskell': 'runhaskell {file}'
    "      \ }

    nnoremap <silent> <leader>tf :VtrSendFile<CR>
    nnoremap <silent> <leader>tt :VtrSendCommandToRunner<CR>
    nnoremap <silent> <leader>tl :VtrSendLinesToRunner<CR>
    nnoremap <silent> <leader>tg :VtrFlushCommand<CR>
    nnoremap <silent> <leader>tc :VtrClearRunner<CR>
"}}}

" new.vim: neovim expect window {{{1
    let g:new#eager_render = 1
"}}}

