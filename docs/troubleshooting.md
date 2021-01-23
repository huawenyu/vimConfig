troubleshooting
===

## start vi with verbosefile

	$ vi -V20/tmp/vim.log Promise.txt

	### using another window (feel better if using tmux)
	$ tail -f /tmp/logfile.txt

	<or> =but you can't do them at same time=

	set directly from .vimrc:
        set verbose=20
        set verbosefile=/tmp/vim.log

## plug use logger to file

1. Put in .vimrc:

	silent! call logger#init('ALL', ['/dev/stdout', '/tmp/vim.log'])

2. Init: Put these in the header of your script file.

	if !exists("s:init")
		let s:init = 1
		silent! let s:log = logger#getLogger(expand('<sfile>:t'))
	endif

3. Use:

	silent! call s:log.debug("test=", var)

4. View log

	$ tail -f /tmp/vim.log

## log to list by vim-basic.vlog tool

	call vlog#warn("before then")

	### view by vim command, current map to <leader>el
	:VlogDisplay \| Messages \| VlogClear

