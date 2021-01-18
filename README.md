# vim plugs config

My plugs config base on different plugs.

## Writing Vim Syntax Plugins
https://neovim.io/doc/user/filetype.html
https://thoughtbot.com/blog/writing-vim-syntax-plugins
https://learnvimscriptthehardway.stevelosh.com/chapters/44.html

## Auto work by filetype

Vim command	:`echo join(map(split(globpath(&rtp, 'ftplugin/*.vim'), '\n'), 'fnamemodify(v:val, ":t:r")'), "\n")`

Vim filetype list:

  elixir vader markdown vimwiki tmux markdown_tablemode rst_tablemode defx w3m
  neosnippet 8th a2ps aap abap abaqus ada alsaconf ant arch art aspvbs
  automake awk bash bdf bst btm bzl c calendar cdrdaoconf cfg ch changelog
  chicken clojure cmake cobol conf config context cpp crm cs csc csh css
  cucumber cvsrc debchangelog debcontrol denyhosts dictconf dictdconf diff
  dircolors docbk dockerfile dosbatch dosini dtd dtrace dune eiffel elinks
  erlang eruby eterm falcon fetchmail flexwiki fortran framescript fvwm
  gdb git gitcommit gitconfig gitrebase gitsendemail go gpg gprof groovy
  group grub haml hamster haskell help hgcommit hog hostconf hostsaccess
  html htmldjango indent initex ishd j java javascript javascriptreact
  jproperties json jsp kconfig kwt ld less lftp libao limits liquid lisp
  logcheck loginaccess logindefs logtalk lprolog lua m4 mail mailaliases mailcap
  make man manconf markdown

### work with tpope/vim-projectionist plugin

You can also create youself a `.projections.json` in the root of the project.

Suppose we have a global config file `~/.projections.json`, which should load for all filetypes,
and the other projections.json should load depend-on filetype.
So we can put the load-global script into `ftdetect`, then put the load filetype-related-projections.json into `ftplugin`.

Step by step, if we want to add a projectionist control file for c:
 - put a projectionist config file `c.json` into dir `conf`,
 - copy a ftplugin vim as `c.vim`, then put into ftplugin:
   - the vimscript load the filetype-related config file from dir `conf`.

#### projectionist command:

Commands
  :A	Edit alternate
  :A {file}	Edit file
  :AS	Edit in split
  :AV	Edit in vsplit
  :AT	Edit in tab
  :AD	Replace with template
  :Cd	cd to root
  :Cd {path}	cd to path in root
  :Lcd	cd to root using :lcd
  :ProjectDo {cmd}	run command in root

#### projectionist buildin variable

Vim-projectionist global config file: {{{1

  This config file as global config for vim plugin-projectionist.vim,
    and auto loaded by my plugin vim.config.

  You can always see all the available transformations inside your vim session with
    :let g:projectionist_transformations.
    {dot}
    {underscore}
    {backslash}
    {colons}
    {hyphenate}
    {blank}
    {uppercase}
    {camelcase}
    {capitalize} — aliased as \{}
    {snakecase}
    {dirname}
    {basename}
    {singular}
    {plural}
    {open}
    {close}

#### projectionist full options config sample template.json:
```json
{
	// Available options {{{1
	"lib/*.rb": {
		// Navigation commands:
		//   Auto generate related command, here is `:Elib`,
		//     the command auto apply template into current file
		"type": "lib",
		"template": [],

		// :A
		"alternate": "test/{}_spec.rb",

		// :Console
		"console": "node",
		// :Dispatch (dispatch.vim)
		"dispatch": "rspec {file}",
		// :Start (dispatch.vim)
		"start": "rails server",

		// makeprg
		"make": "rake",
		// gf
		"path": "include"
	}
}
```
