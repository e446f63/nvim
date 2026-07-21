--[[
NOTE:
=====================================================================
==================== lualine                     ====================
=====================================================================
--]]

return {

  --NOTE: lualine
  {
    'nvim-lualine/lualine.nvim',
    cond = function()
      --This variable is set in 'init.lua'
      return vim.g.active_statusline == 'lualine'
    end,
    config = function()

      -- set the theme to the default 'auto' unless one of the 'if' branches below overrides it.
      local lualine_theme = 'auto'

      -- NOTE: If active colorscheme is set to 'ayu' in init.lua, 
      -- customize inactive statusline and ayu_dark theme
      if vim.g.active_colorscheme == 'ayu' then
        -- The defaults are at `~/.local/share/nvim/lazy/lualine.nvim/lua/lualine/themes`
        local custom_ayu_dark = require 'lualine.themes.ayu_dark'

        -- Change inactive window statusline for better separation and darker blue.
        custom_ayu_dark.inactive.a.bg = '#283d52'
        custom_ayu_dark.inactive.a.fg = '#36a3d9'
        custom_ayu_dark.inactive.b.fg = '#36a3d9'
        custom_ayu_dark.inactive.c.bg = '#283d52'
        custom_ayu_dark.inactive.c.fg = '#36a3d9'
        -- Use regular text instead of bold in section a (and z)
        custom_ayu_dark.inactive.a.gui = ''

        -- Change normal mode statusline to blue
        custom_ayu_dark.normal.c.bg = '#2f93c4'
        custom_ayu_dark.normal.c.fg = '#14191f'

        -- Update colors when mode changes
        for mode, colors in pairs(custom_ayu_dark) do
          if type(colors) == "table" and mode ~= 'inactive' then
            -- Set c colors to match a always, commented out for now.
            -- Need these lines because most modes don't have c or x defined.
            -- colors.c = colors.c or {}
            -- colors.x = colors.x or {}
            -- colors.c.bg = colors.a.bg
            -- colors.c.fg = colors.a.fg
            -- colors.x.fg = colors.c.fg
            -- colors.x.bg = colors.c.bg
            --
            -- Set b text color to match a's background
            colors.b.fg = colors.a.bg
            -- Use regular text instead of bold in section a (and z)
            colors.a.gui = ''
          end
        end

        lualine_theme = custom_ayu_dark

      -- NOTE: If active colorscheme is set to 'shatur-ayu-dark' in init.lua, 
      -- use lualine's regular 'ayu' theme.
      elseif vim.g.active_colorscheme == 'shatur-ayu-dark' then
        lualine_theme = require('lualine.themes.ayu')
        -- optional Shatur-specific tweaks

      end

      -- Define custom statusline sections once; apply to both active and inactive below.
      local sections = {
        lualine_a = { 'mode' },
        -- if no git branch info, insert placeholder text to keep statusline pretty.
        lualine_b = {
          {
            'branch',
            fmt = function(str)
              if str == '' or str == nil then
                return 'no git repo'
              end
              return str
            end,
          },
          'diff',
          'diagnostics',
        },
        lualine_c = { { 'filename', path = 4 } },
        -- show buffer numbers, not names
        lualine_x = { { 'buffers', mode = 3 } },
        -- set `colored = true` to use the 'filetype' icons brand color instead
        lualine_y = { 'fileformat', { 'filetype', colored = false }, 'progress' },
        lualine_z = { 'location' },
      }

      require('lualine').setup {
        options = { theme = lualine_theme },

        -- Use custom statusline sections.
        sections = sections,

        -- Use same sections as active.
        inactive_sections = sections,
      }
    end,
  },

}
