-- local-floaterm: Terminal runner with compile-and-run for multiple languages
local M = {}

function M.setup()
  local compile_run_swap = 0

  local function compile_run(mode)
    local command = ":FloatermNew --name=repl --wintype=split --position=bottom --autoclose=0--title=Repl-" .. vim.bo.filetype
    local fname_org = vim.fn.expand("%")
    local fname, fname_bin, fpath_bin

    if mode == "v" then
      fname = vim.fn.expand("%")
      fname_bin = vim.fn.expand("%:r")
      fpath_bin = "./" .. vim.fn.expand("%:r")
    else
      fname = "/tmp/vim.out" .. compile_run_swap
      fname_bin = "/tmp/vim.out" .. compile_run_swap
      fpath_bin = "/tmp/vim.out" .. compile_run_swap
    end

    local ft = vim.bo.filetype
    if ft == "c" then
      command = command .. string.format("  gcc -pthread -lrt -g -O0 -finstrument-functions -fms-extensions -o %s %s && %s", fname_bin, fname_org, fpath_bin)
    elseif ft == "cpp" then
      command = command .. string.format("  g++ -pthread -lrt -g -O0 -finstrument-functions -fms-extensions -o %s %s && %s", fname_bin, fname_org, fpath_bin)
    elseif ft == "rust" then
      if mode == "v" then
        local fname_bin_t = vim.fn.fnamemodify(fname_bin, ":t")
        command = command .. string.format("  cargo test '%s::test::' -- --nocapture", fname_bin_t)
      else
        command = command .. string.format("  rust-script %s", fname_org)
      end
    elseif ft == "java" then
      command = command .. string.format("  java %s", fname_org)
    elseif ft == "javascript" then
      command = command .. string.format("  node %s", fname_org)
    elseif ft == "python" then
      command = command .. string.format("  python %s", fname_org)
    elseif ft == "tcl" then
      command = command .. string.format("  expect %s", fname_org)
    elseif ft == "awk" then
      command = command .. string.format("  LC_ALL=C awk -f %s", fname_org)
    elseif ft == "sh" then
      command = command .. string.format("  LC_ALL=C bash %s", fname_org)
    elseif ft == "markdown" then
      vim.cmd(string.format("!rm -rf %s", fname_bin))
      vim.cmd("AsyncStop!")
      command = string.format("!pandoc -f markdown --standalone --to man %s -o %s", fname_org, fname_bin)
      vim.cmd(command)
      command = string.format("  Snman %s", fname_bin)
    elseif ft == "nroff" then
      command = string.format("  Snman %s", fname_org)
    else
      vim.notify("Not support filetype: " .. ft, vim.log.levels.WARN)
      return
    end

    vim.cmd("echomsg 'Debug: " .. command .. "'")
    vim.cmd("silent execute '" .. command .. "'")
  end

  local function get_man_word()
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local char = line:sub(col, col)
    if char:match("%w") or char:match("[.-]") then
      local saved_iskeyword = vim.bo.iskeyword
      for _, key in ipairs({ 2, 1, 0 }) do
        vim.bo.iskeyword = saved_iskeyword
        if key == 2 then
          vim.bo.iskeyword = saved_iskeyword .. ",.,-"
        elseif key == 1 then
          vim.bo.iskeyword = saved_iskeyword .. ",-"
        end
        local the_word = vim.fn.expand("<cword>")
        if the_word:match("^%x{7,40}$") then
          vim.bo.iskeyword = saved_iskeyword
          return { "Git", the_word }
        end
        if vim.fn.system("man -w " .. the_word) then
          vim.bo.iskeyword = saved_iskeyword
          return { "Man", the_word }
        end
        if vim.fn.system("tldr --list | grep -e '^" .. the_word .. "$'") == 0 then
          vim.bo.iskeyword = saved_iskeyword
          return { "Tldr", the_word }
        end
        the_word = ""
      end
      vim.bo.iskeyword = saved_iskeyword
    end
    if char:match("%w") then
      return { "none", vim.fn.expand("<cword>") }
    end
    return { "none", "" }
  end

  local function man_show(mode)
    local cmd = ""
    local word = ""
    if mode == "k" then
      local words = get_man_word()
      if not words[2] or words[2] == "" then
        word = vim.fn.expand("<cword>")
      else
        word = words[2]
        if words[1] == "Man" then
          vim.cmd(string.format("Man %s", word))
          return
        elseif words[1] == "Git" then
          vim.fn.system(string.format("git show --stat -p %s > /tmp/vim_a.diff", words[2]))
          if vim.v.shell_error == 0 then
            cmd = "PreviewFile /tmp/vim_a.diff"
          end
        end
      end
    end
    if cmd == "" then
      cmd = ":FloatermNew --name=Help --wintype=split --position=bottom --autoclose=1 --height=0.4 width=0.6 --title=Man-" .. vim.bo.filetype
      if word == "" then
        word = vim.fn.expand("<cword>")
      end
      cmd = cmd .. " tldr " .. word .. " -e"
    end
    vim.cmd("silent execute '" .. cmd .. "'")
  end

  local function toggle_terminal(mode)
    local command = ":FloatermNew --name=Shell --wintype=split --position=bottom --autoclose=0--title=Shell bash"
    vim.cmd("silent execute '" .. command .. "'")
  end

  vim.keymap.set("n", "<leader>ee", function()
    vim.cmd("w")
    compile_run("n")
  end, { desc = "(*repl) Run me" })

  vim.keymap.set("v", "<leader>ee", function()
    vim.cmd("'<,'>w! /tmp/vim.out")
    compile_run("v")
  end, { desc = "(*repl) Run me" })

  vim.keymap.set("v", ";ee", function()
    vim.cmd("make " .. vim.fn.expand("%:t:r"))
    vim.cmd("copen")
    vim.cmd("wincmd p")
  end, { desc = "(diag) Make buffer" })

  vim.keymap.set("n", "K", function() man_show("k") end, { desc = "(Man) Show help" })
  vim.keymap.set("n", "<leader>K", function() man_show("n") end, { desc = "(Man) Tldr" })
  vim.keymap.set("v", "<leader>K", function() man_show("v") end, { desc = "(Man) Tldr" })

  vim.keymap.set({ "n", "v" }, "<C-\\>", function() toggle_terminal("n") end, { desc = "(view) Terminal *" })
  vim.keymap.set("i", "<C-\\>", function()
    vim.cmd("silent execute ':FloatermNew --name=Shell --wintype=split --position=bottom --autoclose=0--title=Shell bash'")
  end, { desc = "(Tool) Terminal" })

  vim.api.nvim_create_user_command("Tldr", function(opts)
    vim.cmd(string.format("FloatermNew --name=Help --wintype=split --position=bottom --autoclose=1--title=Tldr tldr -e %s", opts.args))
  end, { nargs = 1 })
end

return M
