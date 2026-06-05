local M = {}

M.buf = nil
M.win = nil
M.source_file = nil

M.config = {
  fg = "#6A9955", -- default green
  bg = nil,       -- optional
}

local function apply_highlight()
  vim.api.nvim_set_hl(0, "NoteNormal", {
    fg = M.config.fg,
    bg = M.config.bg,
  })
end

local function ensure_buf()
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    M.buf = vim.api.nvim_create_buf(false, true)

    vim.bo[M.buf].buftype = "nofile"
    vim.bo[M.buf].swapfile = false
    vim.bo[M.buf].bufhidden = "hide"
    vim.bo[M.buf].modifiable = true
  end
  return M.buf
end

function M.hide()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
  end
end

local function calc_size()
  local columns = vim.o.columns
  local lines = vim.o.lines

  local width = math.floor(columns / 3)
  local height = math.floor(lines / 3)

  -- safety minimum
  width = math.max(width, 30)
  height = math.max(height, 5)

  return width, height
end

function M.show(content)
  local buf = ensure_buf()

  local width, height = calc_size()

  local lines = vim.split(content, "\n", { plain = true })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  M.hide()

  M.win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    row = 1,
    col = vim.o.columns - width - 2,
    width = width,
    height = height,

    style = "minimal",
    border = "rounded",
    focusable = false,

    -- nicer layout feel
    title = " Notes ",
    title_pos = "center",
  })

  -- wrapping ON
  vim.wo[M.win].wrap = true
  vim.wo[M.win].linebreak = true
  vim.wo[M.win].breakindent = true
  vim.wo[M.win].cursorline = false

  -- visual polish
  vim.wo[M.win].winblend = 10

  apply_highlight()

  vim.wo[M.win].winhl = table.concat({
    "Normal:NoteNormal",
    "FloatBorder:DiagnosticWarn",
    "FloatTitle:DiagnosticWarn",
  }, ",")
end

function M.show_file(file)
  file = vim.fn.expand(file)

  if vim.fn.filereadable(file) ~= 1 then
    vim.notify("Note file not found: " .. file, vim.log.levels.ERROR)
    return
  end

  M.source_file = file

  local content = table.concat(vim.fn.readfile(file), "\n")
  M.show(content)
end

function M.reload()
  if not M.source_file then
    vim.notify("No note file loaded")
    return
  end
  M.show_file(M.source_file)
end

function M.edit()
  if not M.source_file then
    vim.notify("No note file loaded")
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(M.source_file))
end

return M
