# `Vim Help`:
    `LD-leader` is <space>  | `LD2-leader2` is `;`
    `<LD>*`         : c-Change  v-Views  d-Trim  g-Git  t-Terminal  m-Make/Mark  s-Save
<QuickStart>        : `K`-Help | `;q`-Smartclose  `<LD>q`-Exit `<LD><LD>`-Preview Tag `<LD2><LD2>`-Nop
<Windows>   `#`     : `<C-#>`-Terminal Tab  `<A-#>`-Tmux Tab  `<C-hjkl>`-Win|Pane  `;#`-Vim Tab
<Views>     `<A-*>` : `;v*`| <A-w>-Maximize  <A-e>-Explore  `<LD>vo`-Outline as fmr `<A-'>`-Outline  `<A-;>`-QF  `<A-/>`-tag
<Motion>    `<C-*>` : `<C-]>`-tag  `<C-io>`-history  `<C-np>`-QF  `<C-/>`-Comment  `<C-\>`-Terminal
<Find>      `<LD>f*`:  `f|F`-Files `s`-Symbol `c`-Caller `w`-Assign  `t`-tags `b`-buffers  `e`-changes  `j`-Jumps  `m`-Marks
<Jump>      `g*`    : `gf`-Openfile  `gi`-Last insert  `gv`-Reselect  `gd`-Definition  `g;`-older change  `g,`-newer change  `gg`/`G`-begin/end   zt/zz/zb-Top/Middle/Bottom
<QuickFix>  `-QF-`  : `<c-q><cr>`-Fzf to quickfix  `mf`-filterQF  `mc`-callerQF
<Option>    `o[*`   : <space>-add blank lines  `e`-exchange lines  `n`-conflict
<Object>    `v*`    : `vie`-buffer  `vif`-function  `vi'`-fence  `vi'`-Quota `viu`-URL  `vij`-Brace  `vic`-Comment  `vib`-Block
<Mode>      `-GDB-` : `F4`-Cont  `F5`-next(S-skip)  `F6`-stepIn(S-Finish)  `F7`-RunToHere  `F8`-Evaluate(S-Watch)  `F9`-ToggleBreak
<Mode>      `Search`: `;#`-Count  `;^`-Popup  `;*`-ToQF
<Misc>      `-note-`: `<LD>w;`-buf Swap `<LD>ee`-exec| Diff(env $VimGit)
                    : `:e ++ff=dos`| `:set ff=unix`| `:C0|C2|C4|C08`
                    : `:verbose map|function *`|
                    : `1G`-file path|


- Debug log/troubleshooting:
-------------
  1. Enable log from global config:
        "let g:vim_confi_option.debug = 1
        # <or> specify from command line
        debug=1 vim <file>
  2. Ensure the log instance existed:
        " Insert this line to the front of our vimscript:
        silent! let s:log = logger#getLogger(expand('<sfile>:t'))
  3. Debug/print:
        silent! call s:log.info(l:__func__, 'enter')
  4. Check log:    (LinuxPC) $ tail -f /tmp/vim.log

Install:  help 'H' on the topic
- [Windows]
    ### Install
       - Doc: https://jdhao.github.io/2018/11/15/neovim_configuration_windows/
       - Install neovim, https://github.com/neovim/neovim/wiki/Installing-Neovim
       - Install Git (available at https://git-scm.com/downloads)
       - Copy the plug.vim and place it in "autoload" directory of vim.
       - In your .vimrc, include the plugins that you need to install.
       - Save and source the .vimrc.
       - Run ":PlugInstall"

- [Debian]
    ### Auto setup/install env
        wget --no-check-certificate -O ~/chk-ubuntu  https://raw.githubusercontent.com/huawenyu/zsh-local/master/bin/chk-ubuntu
        chmod +x ~/chk-ubuntu
        ~/chk-ubuntu

    ### Install neovim:
        sudo apt-get install neovim
        sudo update-alternatives --config vi
        sudo update-alternatives --config vim

    ### 1. Update latest vim config:
        wget --no-check-certificate -O ~/.vimrc  https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ### 2.1 Update vim from repo:
        #sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt-get install neovim
    ### 2.2 [OR] Update vim from binary:
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv /usr/bin/nvim /usr/bin/nvim.old
        sudo mv nvim.appimage /usr/bin/nvim
    ### 3. Take `.vimrc` as Config [Reference: vi -c 'help nvim-from-vim']
        ### oneline version
        $ mkdir -p ~/.vim && rm -fr ~/.vim/init.vim && ln -s ~/.vimrc ~/.vim/init.vim && mkdir -p ~/.config && rm -fr ~/.config/nvim && ln -s ~/.vim ~/.config/nvim

        ### Split into multiple lines
        $ mkdir ~/.vim
        $ ln -s ~/.vimrc ~/.vim/init.vim
        $ mkdir ~/.config
        $ ln -s ~/.vim ~/.config/nvim

    $ vi -c 'PlugInstall'

- [Optional] - other config/tool
    + zshrc -- Simpler zshrc for oh-my-zsh
      $ sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
      $ wget --no-check-certificate -O ~/.zshrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.zshrc
    + oh-my-bash
      $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
        OSH_THEME="robbyrussell"
        DISABLE_AUTO_UPDATE="true"
    + tmux.conf -- Simpler zshrc for oh-my-zsh
      $ wget --no-check-certificate -O ~/.tmux.conf https://raw.githubusercontent.com/huawenyu/dotfiles/master/.tmux.conf
    + [neovim-remote](https://github.com/mhinz/neovim-remote)
- [QuickStart]
    - checkhealth

