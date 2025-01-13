-- vim: ft=lua setlocal autoindent cindent et ts=4 sw=4 sts=4:

local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- Function to search man pages
M.search = function()
  local tldr_pages = vim.fn.systemlist("tldr --list")  -- Get list of all available man pages

  pickers.new({}, {
    prompt_title = "Tldr Pages",
    finder = finders.new_table({
      results = tldr_pages,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local tldr_page = selection[1]
        vim.cmd("Tldr " .. tldr_page)
      end)
      return true
    end,
  }):find()
end


function M.load()
    -- Register the function as a Telescope extension with a new name
    require('telescope').register_extension({
        exports = {
            tldr = M.search  -- Use the shorter name for the command
        }
    })
end

return M


