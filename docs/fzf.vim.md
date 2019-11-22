fzf.vim
===

# config

## config color

### method-1 [good: from vimrc]

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

### method-2 [bad: zshrc]

https://jonasjacek.github.io/colors/

Append this to our bashrc/zshrc:

```bash

export FZF_DEFAULT_OPTS='
--color fg:-1,bg:-1,hl:178,fg+:3,bg+:233,hl+:220
--color info:150,prompt:110,spinner:150,pointer:167,marker:174
'
```

So here the color use 'Xterm Number'

```vim
Display 	 Xterm Number 	 Xterm Name     	 HEX     	 RGB        	 HSL
color   	 178          	 Black (SYSTEM) 	 #000000 	 rgb(0,0,0) 	 hsl(0,0%,0%)
```

## Config Keys

Use different keys to navigate between matched candidates.
Append this to our bashrc/zshrc:

```bash
export FZF_DEFAULT_OPTS='--bind=ctrl-p:up,ctrl-n:down'
```

# Commands

:Files      is for finding files by name. I used to use Ctrl-P for this, but FZF is so much better and quicker that I ditched Ctrl-P almost immediately (though you can map :Files to it if you want to use the same key).
:Rg         uses Ripgrep to search for content in files, so you can search for a specific string. This makes it an excellent replacement for the Ggrep command from Fugitive.
:Snippets   works with Ultisnips to provide a filterable list of available snippets you can insert, making it much more useful
:Tags       allows you to filter and search tags in the project as a whole
:BTags      does the same, but solely in the current buffer
:Lines      allows you to find lines in the project and navigate to them.
:BLines     does the same, but solely in the current buffer.

