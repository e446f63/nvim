-- Show pending keybinds as you type them

---@module 'lazy'
---@type LazySpec
return {
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
        { pattern = 'command', icon = ' ', color = 'blue' },
        { pattern = 'cli', icon = ' ', color = 'blue' },
        { pattern = 'help', icon = '󰋖 ', color = 'blue' },
        { pattern = 'keymaps', icon = '󰌌 ', color = 'blue' },
        { pattern = 'resume', icon = '󰜉 ', color = 'blue' },
        { pattern = 'wrap', icon = '󰴐 ', color = 'blue' },
        { pattern = 'spell', icon = '󰓆 ', color = 'blue' },
        { pattern = 'send file', icon = '󰈪 ', color = 'blue' },
        { pattern = 'send this', icon = ' ', color = 'blue' },
        { pattern = 'send visual', icon = '󱣿 ', color = 'blue' },
        { pattern = 'prompt', icon = ' ', color = 'blue' },
        { pattern = 'goto', icon = '󰅩 ', color = 'blue' },
        { pattern = 'lsp', icon = '󰅩 ', color = 'blue' },
        { pattern = 'rename', icon = ' ', color = 'blue' },
      },
    },

    -- Document existing key chains
    spec = {
      { '<leader>s', group = 'telescope search', mode = { 'n', 'v' } },
      { '<leader>t', group = 'toggle' },
      { '<leader>a', group = 'AI (sidekick)', mode = { 'n', 't', 'i', 'x' }, icon = ' ' },
      { '<leader>d', group = 'dnf commands', icon = ' ' },
      { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } },
      { 'gr', group = 'LSP actions', mode = { 'n' } },
    },
  },
}
