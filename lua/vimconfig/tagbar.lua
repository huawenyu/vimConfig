-- local-tagbar: Tagbar configuration for multiple languages
local M = {}

function M.setup()
  vim.g.tagbar_autofocus = 0
  vim.g.tagbar_position = 'left'
  vim.g.tagbar_sort = 0
  vim.g.tagbar_width = 40
  vim.g.tagbar_compact = 1
  vim.g.tagbar_silent = 1
  vim.g.tagbar_indent = 2
  vim.g.tagbar_foldlevel = 4
  vim.g.tagbar_iconchars = { '+', '-' }
  vim.g.tagbar_map_hidenonpublic = "`"
  vim.g.tagbar_map_close = "q"

  if vim.fn.executable('ctags') == 1 then
    local path_ctags = vim.fn.systemlist("which ctags")[1]
    vim.g.rust_use_custom_ctags_defs = 1
    vim.g.tagbar_type_rust = {
      ctagsbin = path_ctags, ctagstype = 'rust',
      kinds = { 'n:modules', 's:structures:1', 'i:interfaces', 'c:implementations', 'f:functions:1', 'g:enumerations:1', 't:type aliases:1:0', 'v:constants:1:0', 'M:macros:1', 'm:fields:1:0', 'e:enum variants:1:0', 'P:methods:1' },
      sro = '::',
      kind2scope = { n = 'module', s = 'struct', i = 'interface', c = 'implementation', f = 'function', g = 'enum', t = 'typedef', v = 'variable', M = 'macro', m = 'field', e = 'enumerator', P = 'method' },
    }
  end

  if vim.fn.executable('tag4md.py') == 1 then
    local path_mdctags = vim.fn.systemlist("which tag4md.py")[1]
    vim.g.markdown_use_custom_ctags_defs = 1
    vim.g.tagbar_type_markdown = {
      ctagsbin = path_mdctags, ctagstype = 'markdown', ctagsargs = '-f - --sort=yes --sro=»',
      kinds = { 'n:modules', 's:sections', 'i:images' }, sro = '»', kind2scope = { n = 'module', s = 'section' }, sort = 0,
    }
  end

  if vim.fn.executable('tag4log') == 1 then
    local path_logctags = vim.fn.systemlist("which tag4log")[1]
    vim.g.log_use_custom_ctags_defs = 1
    vim.g.tagbar_type_log = {
      ctagsbin = path_logctags, ctagstype = 'log',
      kinds = { 'n:modules', 's:sections', 'i:images' }, sro = '»', kind2scope = { n = 'module', s = 'section' }, sort = 0,
    }
  end
end

return M
