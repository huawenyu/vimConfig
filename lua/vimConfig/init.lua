local M = {}

M.whicyKey = require('vimConfig.which-key')
M.nvimWebDevicons = require('vimConfig.nvim-web-devicons')
M.edgy = require('vimConfig.edgy')
M.neoTree = require('vimConfig.neo-tree')
M.lualine = require('vimConfig.lualine')
M.glow = require('vimConfig.glow')
M.hop = require('vimConfig.hop')
M.autoSession = require('vimConfig.auto-session')
M.todo = require('vimConfig.todo')
M.toggleterm = require('vimConfig.toggleterm')
M.fzfLsp = require('vimConfig.fzf-lsp')
M.CmpNvimLsp = require('vimConfig.cmp-nvim-lsp')
M.lspfuzzy = require('vimConfig.lspfuzzy')
M.multicursors = require('vimConfig.multicursors')
M.hydra = require('vimConfig.hydra')
M.fidget = require('vimConfig.fidget')


function M.setup()
	M.whicyKey.load()
	M.nvimWebDevicons.load()
	M.edgy.load()
	M.lualine.load()
	M.hop.load()

	M.neoTree.load()
	M.glow.load()
	M.todo.load()
	M.autoSession.load()
	M.toggleterm.load()

	M.fzfLsp.load()
	M.CmpNvimLsp.load()
	M.lspfuzzy.load()

	M.multicursors.load()
	M.hydra.load()
	M.fidget.load()
end


return M

