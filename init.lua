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

This file was originally from Kickstart.nvim by T.J. DeVries

  Original at: https://github.com/nvim-lua/kickstart.nvim

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

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Check if we're in VS Code; if so, load only vscode.lua
if vim.g.vscode then
  require 'vscode-init'
  return
end

--[[
NOTE:
=====================================================================
==================== OPTIONS                     ====================
=====================================================================
--]]
--See `:help vim.o`. For more options, you can see `:help option-list`

-- Set primary colorscheme. Options: 'tokyonight-night', 'ayu', or 'default'.
--   also 'shatur-ayu-dark' if uncommented.
-- See `lua/plugins/colorschemes.lua`
vim.g.active_colorscheme = 'ayu'

-- Set statusline. Options: 'lualine', 'mini.statusline', or 'default'.
vim.g.active_statusline = 'lualine'

-- Give pop-ups (like <S>-K) borders
vim.o.winborder = 'single'

-- Make relative line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
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

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
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
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- enable experimental feature intended to replace the builtin message + cmdline presentation layer.
-- default options shown
require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5 -- Maximum height while expanded for messages beyond 'cmdheight'.
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
})

--[[
NOTE:
=====================================================================
==================== KEYMAPS                     ====================
=====================================================================
--]]
--See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Open diagnostic in quickfix list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'quickfix list' })

-- Exit terminal mode in the builtin terminal with <ESC><ESC>
-- Otherwise, you normally need to press <C-\><C-n>.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--  If these don't work, see original kickstart.nvim file for different versions.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle spell checking
vim.keymap.set('n', '<leader>ts', '<cmd>lua vim.o.spell = not vim.o.spell<CR>', { desc = 'spellchecking' })

-- Toggle text wrap, which is mainly for markdown tables.
vim.keymap.set('n', '<leader>tw', function()
    vim.wo.wrap = not vim.wo.wrap
    -- Optional: print a message so you know the current state
    if vim.wo.wrap then
        print("Text Wrap: Enabled")
    else
        print("Text Wrap: Disabled")
    end
end, { desc = 'wrap text' })

-- DNF Keymaps
-- Get the DNF advisory info (changelogs) for highlighted text in Visual mode
vim.keymap.set("x", "<leader>da", function()
  vim.cmd([[normal! "zy]])
  local pkg = vim.trim(vim.fn.getreg("z"))
  local out = vim.fn.systemlist("dnf advisory info --contains-pkgs=" .. vim.fn.shellescape(pkg))

  vim.cmd("new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
end, { silent = true, desc = "advisories for selected package" })

-- Get the DNF info for highlighted text in Visual mode
vim.keymap.set("x", "<leader>di", function()
  vim.cmd([[normal! "zy]])
  local pkg = vim.trim(vim.fn.getreg("z"))
  local out = vim.fn.systemlist("dnf info " .. vim.fn.shellescape(pkg))

  vim.cmd("new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
end, { silent = true, desc = "info for selected package" })

-- Sidekick / Copilot / NES Keymaps
-- Jump or Apply the next edit suggestion from Sidekick's NES (Next Edit Suggestion) system.
--  See `lua/plugins/sidekick.lua` for more information on Sidekick and NES.
-- In Insert mode, this is handled by Blink with the `<Tab>` key, so this is for Normal mode.
-- <leader>aa also works, but <leader><Tab> is quicker.
vim.keymap.set( "n", "<leader><Tab>", function() require("sidekick").nes_jump_or_apply() end, { desc = "goto / apply NES" })

--[[
NOTE:
=====================================================================
==================== AUTOCOMMANDS                ====================
=====================================================================
--]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

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

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`
  {
    'NMAC427/guess-indent.nvim',
    opts = {
      on_tab_options = {
        expandtab = false,
        tabstop = 4,
      }
    }
  },

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        colors = false,
        rules = {
          { pattern = "command", icon = " ", color = "blue" },
          { pattern = "cli", icon = " ", color = "blue" },
          { pattern = "help", icon = "󰋖 ", color = "blue" },
          { pattern = "keymaps", icon = "󰌌 ", color = "blue" },
          { pattern = "resume", icon = "󰜉 ", color = "blue" },
          { pattern = "wrap", icon = "󰴐 ", color = "blue" },
          { pattern = "spell", icon = "󰓆 ", color = "blue" },
          { pattern = "send file", icon = "󰈪 ", color = "blue" },
          { pattern = "send this", icon = " ", color = "blue" },
          { pattern = "send visual", icon = "󱣿 ", color = "blue" },
          { pattern = "prompt", icon = " ", color = "blue" },
          { pattern = "goto", icon = "󰅩 ", color = "blue" },
          { pattern = "lsp", icon = "󰅩 ", color = "blue" },
          { pattern = "rename", icon = " ", color = "blue" },
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = 'telescope search', mode = { 'n', 'v' } },
        { '<leader>t', group = 'toggle' },
        { '<leader>a', group = 'AI (Sidekick)', icon = ' ' },
        { '<leader>d', group = 'dnf commands', mode = { 'v' }, icon = ' ' },
        { '<leader>tn', desc = 'neo-tree' },
        { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  To install any of these, move the '.lua' file from inside the kickstart directory to `lua/plugins/` and restart Neovim.
  --  Lazy will then automatically install them with the `import = 'plugins'` statement.
  --
  -- 'kickstart.plugins.debug',
  -- 'kickstart.plugins.lint',
  -- 'kickstart.plugins.autopairs',
  -- 'kickstart.plugins.gitsigns', -- (installed) adds gitsigns recommended keymaps

  -- Import all Lazy plugins from 'lua/plugins/'
  { import = 'plugins' },

  -- Check for 'lua/local/plugins/' path; if exists, import those plugins too.
  -- These are for machine-specific plugins
  unpack(vim.uv.fs_stat(vim.fn.stdpath 'config' .. '/lua/local/plugins') and {
    { import = 'local.plugins' },
  } or {}),

  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
},
{ ---@diagnostic disable-line: missing-fields
  rocks = {
    enabled = false,
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
) -- Closed lazy's setup() function.

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
