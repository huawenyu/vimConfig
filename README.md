# vim plugs config

My vim/zsh/tmux plugs config/map/command, prefer lazy load.

# Install (neovim only)

```bash
    ### Install my all-in-one vim-plugin/linux-tool/zsh-plugins
    curl -fLo ~/.config/nvim/init.vim --create-dirs https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc

    ### Install modified vim-plug: support config/setup when loaded a lazy plugin as `config -> loaded -> setup`
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/huawenyu/vim-plug/master/plug.vim
```

# vimConfig config a new plugin

```python

    | ~/.vim/bundle/vimConfig $ tree
    | .
    | files                             | Add a lua plugin          | Add a vim plugin | Add my map/cmd/
    | ----                              | ----                      | ---              | ----
    | ~/.vimrc; ~/.config/nvim/init.vim | 1. add plugin, try `lazy` | 1. add plugin    |
    | .                                 |                           |                  |
    | ├── after                         |                           |                  |
    | │   ├── ftplugin                  |                           |                  |
    | │   │   └── qf.vim                |                           |                  |
    | │   ├── plugin                    |                           |                  |
    | │   │   └── map.vim               |                           |                  |
    | │   └── syntax                    |                           |                  |
    | │       └── json.vim              |                           |                  |
    | ├── lua                           |                           |                  |
    | │   └── vimConfig                 | 2. create setup           |                  |
    | │       ├── auto-session.lua      |                           |                  |
    | │       ├── cmp-nvim-lsp.lua      |                           |                  |
    | │       ├── common.lua            |                           |                  |
    | │       ├── edgy.lua              |                           |                  |
    | │       ├── fidget.lua            |                           |                  |
    | │       ├── fzf-lsp.lua           |                           |                  |
    | │       ├── glow.lua              |                           |                  |
    | │       ├── hop.lua               |                           |                  |
    | │       ├── hydra.lua             |                           |                  |
    | │       ├── init.lua              | 3. load plug              |                  |
    | │       ├── lspfuzzy.lua          |                           |                  |
    | │       ├── lualine.lua           |                           |                  |
    | │       ├── multicursors.lua      |                           |                  |
    | │       ├── neo-tree.lua          |                           |                  |
    | │       ├── nvim-web-devicons.lua |                           |                  |
    | │       ├── symbols-outline.lua   |                           |                  |
    | │       ├── todo.lua              |                           |                  |
    | │       ├── toggleterm.lua        |                           |                  |
    | │       └── which-key.lua         |                           |                  |
    | ├── plugin                        |                           |                  |
    | │   ├── conf_cmd.vim              |                           |                  | my cmd
    | │   ├── conf_local.vim            |                           |                  | my local
    | │   ├── conf_map.vim              |                           |                  | my map
    | │   ├── conf_plug.vim             |                           | 2. conf vim plug |
    | │   └── map.vim                   |                           |                  |
    | ├── README.md                     |                           |                  |
    | └── templates                     |                           |                  |
    |     ├── =template=.1              |                           |                  |
    |     ├── =template=1.md            |                           |                  |
    |     ├── =template=.lua            |                           |                  |
    |     ├── =template=.md             |                           |                  |
    |     └── =template=.nroff          |                           |                  |

```

