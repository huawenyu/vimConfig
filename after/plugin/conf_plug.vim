" Version:      1.0

if exists('g:loaded_local_config_after') || &compatible
    finish
else
    let g:loaded_local_config_after = 'yes'
    silent! let s:log = logger#getLogger(expand('<sfile>:t'))
endif


if HasPlug('vwm.vim') | " {{{1
    " Example layouts

    " Vista attempts to move itself, the sleep prevents a race.
    let s:dev_panel = {
          \  'name': 'dev_panel',
          \  'opnAftr': ['edit'],
          \  'right':
          \  {
          \    'v_sz': 33,
          \    'init': ['NERDTree'],
          \    'bot':
          \    {
          \      'init': ['Vista', 'sleep 50ms']
          \    }
          \  }
          \}
    let g:vwm#layouts += [s:dev_panel]

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
          \  'name': 'vimdiff',
          \  'opnBfr': [function('s:open_vimdiff')],
          \  'clsAftr': [function('s:close_vimdiff')],
          \  'set_all': ['nobl', 'bh=wipe', 'nomodified'],
          \  'init': ['normal imerge'],
          \  'top':
          \  {
          \    'init': ['normal ibase'],
          \    'left':
          \    {
          \      'init': ['normal ilocal']
          \    },
          \    'right':
          \    {
          \      'init': ['normal iremote']
          \    }
          \  }
          \}

    let s:frame = {
          \  'name': 'frame',
          \  'top': {
          \    'left': {
          \      'init': []
          \    },
          \    'right': {
          \      'init': []
          \    }
          \  },
          \  'bot': {
          \    'left': {
          \      'init': []
          \    },
          \    'right': {
          \      'init': []
          \    }
          \  },
          \  'left': {
          \    'init' :[]
          \  },
          \  'right': {
          \    'init' :[]
          \  }
          \}

    let s:bot_panel = {
          \    'name': 'bot_panel',
          \    'bot':
          \    {
          \      'h_sz': 12,
          \      'left':
          \      {
          \        'init': []
          \      }
          \    }
          \  }

    let g:vwm#layouts += [ s:vimdiff, s:frame, s:bot_panel ]
endif

