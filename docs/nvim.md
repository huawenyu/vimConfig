nvim
===

# Quickstart

0. Download this vimrc:
      wget -O ~/.vimrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
1. Auto-Setup-IDE-with-Plugs:
      nvim -u ~/.vimrc
2. Hi, the <leader> is <space> and ',' :)
      let mapleader = ","
      nmap <space> <leader>
3. Help: press 'K'
   When focus a plug's name, for example, please move cursor to following line, then press 'K':
      @note:nvim

# Config

```vim
@mode: ['all', 'basic', 'theme', 'local',
      \   'editor', 'admin', 'QA', 'coder',
      \
      \   'vimscript', 'c', 'python', 'latex', 'perl', 'javascript', 'clojure', 'database',
      \   'golang', 'tcl', 'haskell', 'rust',
      \   'note', 'script',
      \]

  Sample:
     'mode': ['all', ],
     'mode': ['basic', 'theme', 'local 'editor', ],
     'mode': ['basic', 'theme', 'local', 'editor', ],
let g:vim_confi_option = {
     \ 'mode': ['all', ],
     \ 'theme': 1,
     \ 'conf': 1,
     \ 'upper_keyfixes': 1,
     \ 'auto_install_plugs': 1,
     \ 'plug_note': 'vim.before',
     \ 'plug_patch': 'vim.after',
     \
     \ 'auto_chdir': 0,
     \ 'auto_restore_cursor': 1,
     \ 'auto_qf_height': 1,
     \
     \ 'keywordprg_filetype': 1,
     \}
```

# Install

   Install neovim {{{2
   -------------------
   [doc]("https://github.com/neovim/neovim/wiki/Installing-Neovim)

   Using Plugin-Manage {{{2
   ------------------------
   [code](https://github.com/junegunn/vim-plug)

```sh
    from vi -c 'help nvim-from-vim'
    $ mkdir ~/.vim
    $ mkdir ~/.config
    $ ln -s ~/.vim ~/.config/nvim
    $ ln -s ~/.vimrc ~/.config/nvim/init.vim

    ### Make **neovim** work with plugs
    $ curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    ### Make **vim** work with plugs
    $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    $ vi -c 'PlugInstall'
    $ vi -c 'checkhealth'

    ### After pip install neovim, keep health warning, maybe we're using brew's python.
    ### Please remove brew's python first:
    $ brew list python
    $ brew unlink python@2
    $ brew unlink python@3
    $ sudo apt install python-pip
    $ sudo apt install python3-pip

    $ sudo pip2 install neovim
    $ sudo pip3 install neovim
    $ sudo pip2 install --upgrade neovim
    $ sudo pip3 install --upgrade neovim
```

# Usage
   -------------------
   [vimscript-functions](https://devhints.io/vimscript-functions)
   [vim regex](http://vimregex.com/)
   [Writing Plugin](http://stevelosh.com/blog/2011/09/writing-vim-plugins/)
   [Scripting the Vim editor](https://www.ibm.com/developerworks/library/l-vim-script-4/index.html)

   Usage {{{2
   ----------
   - 'K' on c-function         ' open man document
   - :man key-word             ' Open man document of `find`
   - Vselect then 'g Ctrl-G'   ' Show the number of lines, words and bytes selected.
   - gn                        ' re-select the next match.
   - gv                        ' re-select the last match.
   - search/replace:
   -     :%s///gc              ' replace occurrences of the last search pattern with confirmation
   -     :%s/pattern//gn       ' count the number of occurrences of a word
   -     :%s/\n\{3,}/\r\r/e    ' replace three or more consecutive line endings with two line endings (a single blank line)
   -     :g/^$/d               ' delete blank lines, remove multi blank line
   -     :%s/\s\+$//g          ' remove the tail spaces
   -     :%s/\s\+$//e          ' remove unwanted whitespace from line end
   -     :%s/^\s\+//e          '   remove from begin
   -     :%s/^M//g             ' remove windows's CTRL-M characters: type CTRL-V, then CTRL-M
   -     :s/x/X/g 5            ' substitute 'x' by 'X' in the current line and four following lines
   -     :23d 4                ' delete lines 23, 24, 25 and 26

   - :VoomToggle markdown      ' outline as markdown
   - :VoomToggle markdown      ' outline as markdown
   - <l>ec                     ' eval viml selected
   - folding:
   -     'zc' (close), 'zo' (open), and 'za' (toggle) operate on one level of folding
   -     'zC',  'zO' and 'zA' are similar, but operate on all folding levels
   -     'zr' reduces folding by one more level of folds, 'zR' to open all folds.
   -     'zm' gives more folding by closing one more level, 'zM' to close all folds.
   - Search:
         /patt1\|patt2
         /some_\(hold\|put\), <or>  /\vsome(hold|put)
   Filetype:
       :setfiletype <Ctrl-D>   ' list all available syntax
       :setfiletype ip<Tab>    ' Search the syntax begin with `ip`
   Plug:
       vip             select the same indent block
       a+p/n           jump next/prev same indent line
   Runtime:
       :set all              ' Check all options values
       :set filetype?        ' Check this option value
   Motions, Operators, and Text Objects: Operator-pending mode
       Ref:  http://codyveal.com/posts/vim-killer-features-part-1-text-objects/
             https://www.tandrewnichols.me/motions-operators-text-objects-introduction/
       {operator}[{motion}]{*wise-specifier}
     -Operators:  :h operator
       - d:   delete
       - v:   select
       - c:   change
       - y:   yank
       - >:   indent
       - <:   outdent
       - =:   fix indenting
     -motions:
       - f/F:  forward/backward find and stop on the char
       - t/T:  forward/backward find and stop before the char
       - /:    search ?
     -wise specifier:
       - characterwise: vjjjj
       - wordwise:      vwwww  <or> veee
       - linewise:      Vjjjjj
       - blockwise:     <C-v>hhjjjj
       - Objectwise:  Built-in Text obj, or customize added obj base on Plug 'kana/vim-textobj-user'
           All text objects come in two forms
             - a    around, normal(prefixed by 'a')
             - i    innner, inner (prefixed by 'i')

           Built-in Text Objects:
             - w       Word by punctuation
             - W       Word by whitespace
             - s       Sentence
             - p       Paragraph
             - ',`     Quotes
             - (,),b   Parentheses
             - [,]     Brackets
             - {,},B   Braces
             - <,>     Angle Brackets
             - t       Tags (e.g. <html>inner</html>)

   Command line move:
       ctrl-c          quit command mode
       ctrl-r          paste from vim register
       ctrl-d          command-line completion
       ctrl-b          move to the begin
       ctrl-e          move to the end
       ctrl-h          delete one letter
       ctrl-u          delete to begin
       ctrl-w          delete one word

   Maps check:
      :verbose map <C-j>          check who map this
      :map <some-keys> check the map valid or not
      howto map Shift+F#:
        - Goto insert mode and hit Ctrl-V Shift-F#, which gotted we can use that to map.
        - For example: We get "<F15>" when input Shift+F5, so ':nmap <F15> echo "HELLO"<cr>' should be work.

   Registers:
       \"ry            add the selected text to the register r.
       \"rp            paste the content of this register r.
       Ctrl-r r        access the registers in insert/command mode with Ctrl-r + register name.
   Terminal-mode:
       - enter terminal mode   i
       - exit terminal mode    <C-\><C-n>
       - :help terminal-emulator
   howto:
       :bufdo e                ' reload all buffers at once
       :setfiletype ip<Tab>    ' Search the syntax begin with `ip`

# Log

## in .vimrc

```vim
    silent! call logger#init('ALL', ['/dev/stdout', '/tmp/vim.log'])
```

## At begin of every our vimscript file

```vim
    silent! let s:log = logger#getLogger(expand('<sfile>:t'))
 !!!Or guard avoid multi-load
    if !exists("s:init")
        let s:init = 1
        silent! let s:log = logger#getLogger(expand('<sfile>:t'))
    endif
```

## Use it
```vim
    silent! call s:log.info('hello world')
```

## Support current function-name like C's __FUNCTION__
```vim
    function! ourfile#foobar()
        let l:__func__ = substitute(expand('<sfile>'), '.*\(\.\.\|\s\)', '', '')
        silent! call s:log.info(l:__func__, " args=", string(g:gdb.args))
    endfunction
```

## Check log

    $ tail -f /tmp/vim.log


# Troubleshooting

## enable log for a plug

## start slow: enable starttime

      $ vi --startuptime /tmp/log.1
