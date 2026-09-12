--[[
Clean 'init.lua' with minimal QoL settings for fast file editing.
In Linux, this is aliased to `vim` in .bashrc (`alias vim='nvim -u clean-init.lua'`)

'GLOBAL' items should work when running in VS Code; all others come after an 'EJECT'
  block which returns early if VS Code environment is detected.
--]]

---------- GLOBAL SETTINGS -----------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.timeoutlen = 300

vim.o.inccommand = 'split'

---------- GLOBAL AUTOCOMMANDS -------------------------------------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

---------- GLOBAL KEYMAPS ------------------------------------------------------

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

---------- VS CODE EJECT -------------------------------------------------------
-- If running in VS Code, configure custom keymaps and stop here.
if vim.g.vscode then
  local vscode = require 'vscode'

  vim.keymap.set('n', '<C-h>', function() vscode.action 'workbench.action.navigateLeft' end)
  vim.keymap.set('n', '<C-l>', function() vscode.action 'workbench.action.navigateRight' end)
  vim.keymap.set('n', '<C-j>', function() vscode.action 'workbench.action.navigateDown' end)
  vim.keymap.set('n', '<C-k>', function() vscode.action 'workbench.action.navigateUp' end)

  return
end

---------- SETTINGS ------------------------------------------------------------

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_winsize = 25

vim.g.have_nerd_font = true

vim.o.breakindent = true

vim.o.updatetime = 250

---------- OPTIONS -------------------------------------------------------------

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = ''

vim.o.undofile = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.cursorline = false

vim.o.scrolloff = 10

vim.o.expandtab = false
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.softtabstop = -1

vim.o.confirm = true

vim.cmd 'autocmd TermOpen * startinsert'

---------- MARKDOWN HIGHLIGHTS -------------------------------------------------
-- Used to colorize markdown headers with the default colorscheme

---@param source string
---@return vim.api.keyset.highlight
-- Take in the colorscheme's named style and bold it.
local function markdown_heading_style(source)
  local source_style = vim.api.nvim_get_hl(0, { name = source, link = false })

  return {
    fg = source_style.fg,
    ctermfg = source_style.ctermfg,
    bold = true,
    cterm = { bold = true },
  }
end

-- 'String' uses the default colorscheme's green color
local heading_green = markdown_heading_style 'String'
-- 'Identifier' uses the default colorscheme's blue color
local heading_blue = markdown_heading_style 'Identifier'

vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', heading_green)

for level = 2, 6 do
  vim.api.nvim_set_hl(0, ('@markup.heading.%d.markdown'):format(level), heading_blue)
end

---------- BLACK BACKGROUND ----------------------------------------------------

-- Set pure black background for colorscheme by default
vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000', update = true })

---------- AUTOCOMMANDS --------------------------------------------------------

-- When 'clean-init.lua' is saved, auto-sync it to the Windows Neovim 'init.lua'
-- `pcall` to silently fail when running on Windows where the script doesn't exist
pcall(require, 'scripts.windows-init-sync')

---------- PLUGINS -------------------------------------------------------------

vim.pack.add {
  { src = 'https://github.com/folke/which-key.nvim', name = 'which-key' },
}

require('which-key').setup {
  preset = 'helix',
  delay = 0,
  win = { border = 'none' },
  spec = {
    -- Numbered list of current buffers
    { '<leader>b', group = 'buffers', expand = function() return require('which-key.extras').expand.buf() end },
  },
}

---------- SIDEBAR -------------------------------------------------------------
-- Create a read-only left sidebar (experimental)

-- File the sidebar will use: 'blank.txt' | 'lines.txt' | 'text.txt'
local sidebar_filename = 'blank.txt'

-- If sidebar is the last window, close it
vim.api.nvim_create_autocmd('WinEnter', {
  callback = function()
    if vim.fn.winnr('$') == 1 -- confirm only 1 window exists
      and vim.api.nvim_buf_get_name(0):match(sidebar_filename .. '$')
      then
        vim.cmd.quit()
      end
    end,
  })

-- Create the sidebar
local function create_sidebar()
  -- Define the file to open in the sidebar
  local sidebar_file = vim.fn.stdpath 'config' .. '/assets/sidebar/' .. sidebar_filename

  -- Close if already open
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(b):match(sidebar_filename .. '$') then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- Create a new buffer directly (false = unlisted, true = scratch)
  local buf = vim.fn.bufadd(sidebar_file)

  -- Load buffer and configure it
  vim.fn.bufload(buf)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false

  -- Open the split natively
  -- 'false' prevents entering the window
  vim.api.nvim_open_win(buf, false, {
    split = 'left',
    width = 30,
    style = 'minimal',
  })
end

-- Create the sidebar by default, but after Neovim launches
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Only auto-open the sidebar if a file was passed at launch
    if vim.fn.argc() > 0 then create_sidebar() end
  end,
  once = true,
})

---------- KEYMAPS -------------------------------------------------------------

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'quickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Open the Neovim config directory in Netrw
vim.keymap.set('n', '<leader>n', function() vim.cmd.edit(vim.fn.stdpath 'config') end, { desc = 'neovim files' })

-- Toggle the sidebar
vim.keymap.set('n', '<leader>s', function() create_sidebar() end, { desc = 'toggle sidebar' })

-- vim: ts=2 sts=-1 sw=2 et
