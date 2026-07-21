--[[
NOTE:
=====================================================================
==================== Custom OpenWRT Plugin       ====================
=====================================================================
--]]

-- check if the openWRT path exists
local openwrt_path = '/home/eric/dev/openWRT'
local has_openwrt = vim.uv.fs_stat(openwrt_path) ~= nil

-- Create table with openwrt.nvim config
local specs = {
  {
    dir = openwrt_path,
    name = 'openwrt.nvim',
    -- Lazy's `cond` setting to conditionally enable this plugin.
    cond = function()
      return has_openwrt
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
}

-- Conditionally append the Blink config extension
if has_openwrt then
  table.insert(specs, {
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
      })

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Add the OpenWRT provider without replacing the general source list from
      -- `lua/plugins/blink.lua`.
      if not vim.tbl_contains(opts.sources.default, 'openwrt') then
        table.insert(opts.sources.default, 'openwrt')
      end

      opts.sources.providers.openwrt = {
        name = 'openwrt',
        module = 'openwrt.integrations.uci_terminal_blink',
        enabled = function()
          return vim.bo.filetype == 'openwrt-uci-terminal' or vim.bo.filetype == 'uci'
        end,
      }
    end,
  })
end

-- Return the fully constructed table
return specs
