--[[
=====================================================================
==================== MARKDOWN RENDERING          ====================
=====================================================================
--]]

return{
  { -- Pretty rendering of markdown files
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    opts = {
      pipe_table = {
        enabled = true,
        head = 'RenderMarkdownTableRow',  -- Turn off bright table headers
      },
      heading = {
        enabled = true,
        -- Use Ayu's blue instead of orange for headers
        backgrounds = { 'Type', 'Type', 'Type', 'Type', 'Type', 'Type' },
        foregrounds = { 'Type', 'Type', 'Type', 'Type', 'Type', 'Type' },
        -- Default icons are too small
        icons = {'I. ', 'II. ', 'III. ', 'IIII. ', 'IV. ', 'V. '},
        sign = false,  -- No extra icons in the sign column
        position = 'overlay',  -- Overlays the '#' with a cleaner title style
      },
      -- Disable indentions
      indent = {
        enabled = false
      },
      code = {
        enabled = true,
        style = 'normal',  -- Turn off language icons & block highlighting
        disable_background = true,
        border = 'thin',
        sign = false,
        position = 'left',
        width = 'block',
      },
      -- For blockquotes starting with '>'
      quote = {
        enabled = true,
        icon = '│',  -- Simple, vertical bar for quotes
      },
      -- Leave bullets and checkboxes alone for now.
      dash = { enabled = false },
      bullet = { enabled = false },
      checkbox = { enabled = false },

      -- Disable latex and yaml support to silence warning in checkhealth
      latex = { enabled = false },
      yaml = { enabled = false },
    }
  },
}
