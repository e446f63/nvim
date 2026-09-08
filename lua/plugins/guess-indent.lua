-- Detect indentation settings from existing file contents.

---@module 'lazy'
---@type LazySpec
return {
  'NMAC427/guess-indent.nvim',
  opts = {
    on_tab_options = {
      expandtab = false,
      tabstop = 4,
      shiftwidth = 0,
    },
  },
}
