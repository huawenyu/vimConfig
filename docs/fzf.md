fzf
===

# Config fzf using ripgrep

```sh
    ## fish shell
    #set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
    #
    ## bash / zsh:
    #"export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
    #export FZF_DEFAULT_COMMAND='rg --line-number --color never --no-heading ""'
    #
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
    --color info:254,prompt:37,spinner:108,pointer:235,marker:235
    '
```

# Commands

:Files      is for finding files by name. I used to use Ctrl-P for this, but FZF is so much better and quicker that I ditched Ctrl-P almost immediately (though you can map :Files to it if you want to use the same key).
:Rg         uses Ripgrep to search for content in files, so you can search for a specific string. This makes it an excellent replacement for the Ggrep command from Fugitive.
:Snippets   works with Ultisnips to provide a filterable list of available snippets you can insert, making it much more useful
:Tags       allows you to filter and search tags in the project as a whole
:BTags      does the same, but solely in the current buffer
:Lines      allows you to find lines in the project and navigate to them.
:BLines     does the same, but solely in the current buffer.

