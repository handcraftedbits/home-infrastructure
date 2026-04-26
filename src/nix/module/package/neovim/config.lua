-- Helper: Find the main buffer (not nvim-tree, not aerial)
local function get_main_buf()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype

    if ft ~= "NvimTree" and ft ~= "aerial" then
      return buf
    end
  end

  return nil
end

-- Helper: Check if main buffer has unsaved changes
local function main_buf_modified()
  local buf = get_main_buf()

  if buf then
    return vim.bo[buf].modified
  end

  return false
end

-- Helper: Save main buffer and quit all
local function save_main_and_quit()
  local buf = get_main_buf()

  if buf and vim.bo[buf].modified then
    local current_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_current_buf(buf)
    vim.cmd("write")
    vim.api.nvim_set_current_buf(current_buf)
  end

  vim.cmd("quitall")
end

local function set_indent(size)
  vim.opt_local.tabstop = size
  vim.opt_local.shiftwidth = size
  vim.opt_local.softtabstop = size
end

-- Helper: Handle quit with optional bang
local function try_quit(opts)
  if opts.bang then
    vim.cmd("quitall!")
  else
    if main_buf_modified() then
      vim.api.nvim_err_writeln("E37: No write since last change in main buffer (add ! to override)")
    else
      vim.cmd("quitall")
    end
  end
end

-- Open nvim-tree, aerial, then focus main buffer on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      require("aerial").open()
      require("nvim-tree.api").tree.open()

      vim.defer_fn(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype

          if ft ~= "NvimTree" and ft ~= "aerial" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end, 50)
    end, 10)
  end,
})

-- Command abbreviations to intercept built-in quit commands
vim.cmd([[
  cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() ==# 'q') ? 'Q' : 'q'
  cnoreabbrev <expr> q! (getcmdtype() == ':' && getcmdline() ==# 'q!') ? 'Q!' : 'q!'
  cnoreabbrev <expr> qa (getcmdtype() == ':' && getcmdline() ==# 'qa') ? 'Qa' : 'qa'
  cnoreabbrev <expr> qa! (getcmdtype() == ':' && getcmdline() ==# 'qa!') ? 'Qa!' : 'qa!'
  cnoreabbrev <expr> quit (getcmdtype() == ':' && getcmdline() ==# 'quit') ? 'Quit' : 'quit'
  cnoreabbrev <expr> quit! (getcmdtype() == ':' && getcmdline() ==# 'quit!') ? 'Quit!' : 'quit!'
  cnoreabbrev <expr> wq (getcmdtype() == ':' && getcmdline() ==# 'wq') ? 'Wq' : 'wq'
  cnoreabbrev <expr> wqa (getcmdtype() == ':' && getcmdline() ==# 'wqa') ? 'Wqa' : 'wqa'
  cnoreabbrev <expr> x (getcmdtype() == ':' && getcmdline() ==# 'x') ? 'X' : 'x'
  cnoreabbrev <expr> xa (getcmdtype() == ':' && getcmdline() ==# 'xa') ? 'Xa' : 'xa'
]])

-- Custom commands: Q, Qa, Quit (quit with unsaved change protection)
vim.api.nvim_create_user_command("Q", try_quit, { bang = true })
vim.api.nvim_create_user_command("Qa", try_quit, { bang = true })
vim.api.nvim_create_user_command("Quit", try_quit, { bang = true })

-- Custom commands: Wq, Wqa (write main buffer then quit)
vim.api.nvim_create_user_command("Wq", save_main_and_quit, {})
vim.api.nvim_create_user_command("Wqa", save_main_and_quit, {})

-- Custom commands: X, Xa (write main buffer if modified then quit)
vim.api.nvim_create_user_command("X", save_main_and_quit, {})
vim.api.nvim_create_user_command("Xa", save_main_and_quit, {})

-- Keymaps: ZQ (force quit), ZZ (save and quit)
vim.keymap.set("n", "ZQ", function()
  vim.cmd("quitall!")
end, { noremap = true })

vim.keymap.set("n", "ZZ", save_main_and_quit, { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua", "json", "yaml", "xml", "markdown", "html", "dockerfile", "containerfile", "vim" },
  callback = function()
    set_indent(2)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "go", "java", "javascript", "less", "sh" },
  callback = function()
    set_indent(5)
  end,
})
