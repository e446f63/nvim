--[[
NOTE:
=====================================================================
==================== Custom OpenWRT Plugin       ====================
=====================================================================
--]]

return {
  {
    dir = '/home/eric/dev/openWRT',
    name = 'openwrt.nvim',
    -- Lazy's `cond` setting to conditionally enable this plugin.
    cond = function()
        return vim.uv.fs_stat('/home/eric/dev/openWRT') ~= nil
    end,
    -- List commands so Lazy knows when to load module.
    cmd = {
      'OpenWrtTestConnection',
      'OpenWrtDashboard',
      'OpenWrtUci',
      'OpenWrtUciTerminal',
      'OpenWrtUciReload',
    },
    config = function()
      require('openwrt').setup {
        ssh_host = '192.168.31.1',
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'nosduco/remote-sshfs.nvim',
        dependencies = {
          'nvim-telescope/telescope.nvim',
          'nvim-lua/plenary.nvim',
        },
        opts = {},
      },
    },
  },

  { -- NOTE: Local Blink augmentation for OpenWRT
    'saghen/blink.cmp',
    opts = function(_, opts)
      -- This local module should only layer OpenWRT-specific behavior on top of the
      -- general Blink config from `lua/plugins/blink.lua`.

      opts.completion = vim.tbl_deep_extend('force', opts.completion or {}, {
        -- All these `trigger` settings were done for OpenWRT autocomplete.
        trigger = {
          show_on_trigger_character = true,
          -- Re-trigger completions after accepting a completion that inserts a trigger char.
          show_on_accept_on_trigger_character = true,
          -- Allow space as a trigger character for UCI terminal (default blocks it).
          show_on_blocked_trigger_characters = function()
            if vim.bo.filetype == 'openwrt-uci-terminal' then
              -- Don't block any trigger characters in UCI terminal.
              return {}
            end
            -- Default: block space, newline, tab.
            return { ' ', '\n', '\t' }
          end,
        },

        -- Other settings specifically for OpenWRT autocomplete.
        -- menu = {
        --   max_height = 6, -- Limit height to keep it compact
        --   direction_priority = { 'n', 's' }, -- Open upward (above cursor) first
        -- },
      })

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Add the OpenWRT provider without replacing the general source list from
      -- `lua/plugins/blink.lua`.
      if not vim.tbl_contains(opts.sources.default, 'openwrt') then
        table.insert(opts.sources.default, 'openwrt')
      end

      -- Tried to get UCI autocomplete to work with blink, but failed miserably so far.
      -- opts.sources.providers.openwrt_uci = {
      --   name = 'OpenWrt UCI',
      --   module = 'openwrt.integrations.uci_terminal_blink',
      -- }

      opts.sources.providers.openwrt = {
        name = 'openwrt',
        module = 'openwrt.integrations.uci_terminal_blink',
        enabled = function()
          return vim.bo.filetype == 'openwrt-uci-terminal' or vim.bo.filetype == 'uci'
        end,
      }
    end,
  },
}
