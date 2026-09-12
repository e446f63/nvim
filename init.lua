--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||    e446f63.NVIM    ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:my kickstart.nvim  ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

Originally from Kickstart.nvim by T.J. DeVries

  At: https://github.com/nvim-lua/kickstart.nvim

  Most comments have removed, some kept for informational and/or eductational
  value.

  Learn more about a Lua at:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

  Remember to use :help!
    There's a built-in keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.
--]]

--[[
NOTE:
=====================================================================
==================== INITAL SETTINGS             ====================
=====================================================================
--]]

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font is installed and selected in the terminal
vim.g.have_nerd_font = true

-- Check if we're in VS Code; if so, load only vscode.lua
if vim.g.vscode then
  require 'vscode-init'
  return
end

-- Enable Neovim’s built-in Lua module cache
-- Neovim can cache compiled Lua chunks and load them faster on later startup.
vim.loader.enable()

-- Set primary colorscheme. Options: 'tokyonight-night', 'ayu', or 'default'.
--   also 'shatur-ayu-dark' if uncommented.
-- See `lua/plugins/colorschemes.lua`
vim.g.active_colorscheme = 'ayu'

-- Set statusline. Options: 'lualine', 'mini.statusline', or 'default'.
vim.g.active_statusline = 'lualine'

--[[
NOTE:
=====================================================================
==================== OPTIONS                     ====================
=====================================================================
--]]

--See `:help vim.o`. For more options, you can see `:help option-list`

-- One statusline for all windows
vim.o.laststatus = 3

-- Give pop-ups (like <S>-K) borders
vim.o.winborder = 'single'

-- Make relative line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Disable mouse (prevents infuriating cursor trackpad jumps)
vim.o.mouse = ''

-- Don't show the mode since it's in the statusline, unless using 'default'.
-- vim.o.showmode = false  -- disables it completely
vim.o.showmode = vim.g.active_statusline == 'default'

-- Sync clipboard between OS and Neovim.
-- This puts the OS clipboard into the 'unnamed' and '+' registers
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time for swap file writes and `CursorHold` operations
vim.o.updatetime = 250

-- Decrease mapped sequence wait time (i.e. keypress sequences)
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options` and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions in a quickfist-like split live as they are typed
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Use 'Terminal-mode' (i.e. Insert mode) when opening `:terminal`
vim.cmd 'autocmd TermOpen * startinsert'

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- enable experimental feature intended to replace the builtin message + cmdline presentation layer.
-- default options shown
require('vim._core.ui2').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
}

--[[
NOTE:
=====================================================================
==================== KEYMAPS                     ====================
=====================================================================
--]]
--See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Open diagnostic in location (aka quickfix) list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'quickfix list' })

-- Exit terminal mode in the builtin terminal with <ESC><ESC>
-- Otherwise, you normally need to press <C-\><C-n>.
--
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle spell-checking
--  Simple syntax:
--  vim.keymap.set('n', '<leader>ts', '<cmd>lua vim.o.spell = not vim.o.spell<CR>', { desc = 'spellchecking' })
vim.keymap.set('n', '<leader>ts', function()
  vim.o.spell = not vim.o.spell
  -- Print a message to show current state
  if vim.o.spell then
    print 'spellcheck enabled'
  else
    print 'spellcheck disabled'
  end
end, { desc = 'spellcheck' })

-- Toggle text wrap, which is mainly for markdown tables.
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  -- Print a message to show current state
  if vim.wo.wrap then
    print 'text wrap enabled'
  else
    print 'text wrap disabled'
  end
end, { desc = 'wrap text' })

-- Toggle diagnostics
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  -- Print a message to show current state
  if vim.diagnostic.is_enabled() then
    print 'diagnostics enabled'
  else
    print 'diagnostics disabled'
  end
end, { desc = 'diagnostics' })

-- Sidekick / Copilot / NES Keymaps
-- Jump or Apply the next edit suggestion from Sidekick's NES (Next Edit Suggestion) system.
--  See `lua/plugins/sidekick.lua` for more information on Sidekick and NES.
-- In Insert mode, this is handled by Blink with the `<Tab>` key, so this is for Normal mode.
-- <leader>aa also works, but <leader><Tab> is quicker.
vim.keymap.set('n', '<leader><Tab>', function() require('sidekick').nes_jump_or_apply() end, { desc = 'goto/apply NES' })

-- DNF Keymaps
require 'dnf-keymaps'

--[[
NOTE:
=====================================================================
==================== AUTOCOMMANDS                ====================
=====================================================================
--]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking or deleting text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking or deleting text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- When 'clean-init.lua' is saved, auto-sync it to the Windows Neovim 'init.lua'
-- `pcall` to silently fail when running on Windows where the script doesn't exist
require 'scripts.windows-init-sync'

--[[
NOTE:
=====================================================================
==================== LAZY.NVIM                   ====================
=====================================================================
--]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

-- Specify the Node.js provider because it's installed with 'mise' and Neovim can't find it by default.
local node_host = vim.fn.exepath 'neovim-node-host'
if node_host ~= '' then vim.g.node_host_prog = node_host end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {

  --  Here are some example plugins included in the Kickstart repository.
  --  To install any of these, move the '.lua' file from `lua/kickstart/` to `lua/plugins/` and restart Neovim.
  --  Lazy will then automatically install them with the `import = 'plugins'` statement.
  --
  -- 'kickstart.plugins.debug',
  -- 'kickstart.plugins.lint',
  -- 'kickstart.plugins.autopairs',

  -- Define Lazy's plugin specs
  spec = {
    -- Import all Lazy plugins from 'lua/plugins/'
    { import = 'plugins' },

    -- Check for 'lua/local/plugins/' path for local-only plugins; if exists, import those too.
    unpack(vim.uv.fs_stat(vim.fn.stdpath 'config' .. '/lua/local/plugins') and {
      { import = 'local.plugins' },
    } or {}),
  },

  ---@diagnostic disable-line: missing-fields
  rocks = {
    enabled = false,
  },

  ui = {
    -- If using a Nerd Font, set icons to an empty table which will use the default
    -- lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
