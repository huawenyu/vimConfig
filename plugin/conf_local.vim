" Version:      1.0

if exists('g:loaded_local_myconfig') || &compatible
  finish
else
  let g:loaded_local_myconfig = 'yes'
endif

" viminfo {{{2}}}
" Tell vim to remember certain things when we exit
"  !    :  The uppercase global VARIABLE will saved
"  '30  :  marks will be remembered for up to 10 previously edited files
"  "300 :  will save up to 100 lines for each register
"  :30  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files,
"            here save to /tmp means we have another viminfo manager 'workspace'
if has("nvim")
    set viminfo=!,'30,\"30,:30,%,n~/.nviminfo
else
    "set viminfo=!,'30,\"300,:30,%,n/tmp/viminfo
    set viminfo='30,\"30,:30,n~/.viminfo
endif

if &history < 1000
    set history=5000
endif

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,.idea,node_modules

"hi CursorLine guibg=Grey40
"hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" Disable insert mode color change
hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi Visual term=reverse cterm=reverse guibg=Grey

"hi MatchParen cterm=bold ctermfg=cyan
"hi MatchParen cterm=none ctermbg=green ctermfg=none
"hi MatchParen cterm=none ctermbg=green ctermfg=blue
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" change highlight color for search hits
"hi Search guibg=peru guifg=wheat
"hi Search ctermfg=grey ctermbg=darkblue cterm=NONE
hi Search ctermfg=Red ctermbg=NONE cterm=NONE

"hi TabLineFill ctermfg=Black ctermbg=Green cterm=NONE
hi TabLine ctermfg=DarkBlue ctermbg=NONE cterm=NONE
hi TabLineSel ctermfg=Red ctermbg=NONE cterm=NONE
hi TabLineFill ctermfg=NONE ctermbg=NONE cterm=NONE

"hi NonText ctermfg=7 guifg=Gray
hi NonText ctermfg=DarkGrey guifg=DarkGrey
hi clear SpecialKey
hi link SpecialKey NonText

" The characters after tab is U+2002. in vim with Ctrl-v u 2 0 0 2 (in insert mode).
set listchars=tab:»\ ,trail:~,extends:<,nbsp:.
"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:>.,trail:~,extends:<,nbsp:.
"set listchars=tab:> ,trail:~,extends:<,nbsp:.

"set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" tags {{{2

    " # Issue using tags:
    "   olddir/tags
    "   newdir/tags
    "   cd newdir; vi ../olddir/file1 and 'ptag func'		# which will open the file in olddir
    " # If using 'set cscopetag', this issue not exist.
    " But if auto-update the tags with current file, we must using tags not 'set cscopetag'.
    " And the follow one-line can fix the issue.
    set notagrelative

    "if filereadable("./cscope.out")
    "    set cscopetag
    "endif

    " http://arjanvandergaag.nl/blog/combining-vim-and-ctags.html
    set tags=./tags,tags,./.tags,.tags;$HOME
"}}}

