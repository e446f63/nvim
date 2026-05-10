--[[
NOTE:
=====================================================================
==================== COLORSCHEMES                ====================
=====================================================================
--]]
-- The active default colorscheme (`vim.g.active_colorscheme`) is set in `init.lua`.

-- Colorize window separator to be able to tell splits apart easier.
-- This only works if using global statuline, which is set by:
-- `:set laststatus=3` -- instead of default '2'
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "WhichKeyIcon", { link = "String" })
  end,
})

return {
  {
    'folke/tokyonight.nvim',
    -- Load before all other start plugins, if colorscheme is set as default.
    priority = vim.g.active_colorscheme == 'tokyonight-night' and 1000 or 0,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        -- Darken theme's background (same bg as my Ayu config).
        on_colors = function(c)
          c.bg = "#0D1017"
          c.bg_dark = "#0A0C12"
          c.bg_sidebar = "#0D1017"
          c. bg_float = "#0D1017"
        end,
      }

      -- Load the colorscheme here, if colorscheme is set as default.
      if vim.g.active_colorscheme == 'tokyonight-night' then
        vim.cmd.colorscheme 'tokyonight-night'
      end
    end,
  },

  {
    'Luxed/ayu-vim',
    -- Load before all other start plugins, if colorscheme is set as default.
    priority = vim.g.active_colorscheme == 'ayu' and 1000 or 0,

    config = function()
      vim.g.ayu_sign_contrast = 0 -- default, but leaving in for reference
      vim.g.ayu_extended_palette = 1

      -- Load the colorscheme, if colorscheme is set as default.
      if vim.g.active_colorscheme == 'ayu' then
        vim.cmd.colorscheme 'ayu'
      end
    end,
  },

  -- { -- NOTE: Different Ayu colorscheme, fully written in lua
  --   -- This needs additional tweaks / customizing in order to run alongside Luxed/ayu-vim
  --   -- Commented out until I have the time/desire to mess with that.

  --   'Shatur/neovim-ayu',
  --   priority = vim.g.active_colorscheme == 'shatur-ayu-dark' and 1000 or 0,
  --   config = function()
  --     if vim.g.active_colorscheme == 'shatur-ayu-dark' then
  --       require('ayu').setup({
  --         mirage = false,
  --         terminal = true,
  --       })
  --
  --       vim.cmd.colorscheme('ayu-dark')
  --     end
  --   end,
  -- }
}
