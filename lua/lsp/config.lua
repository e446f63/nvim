--[[
NOTE:
=====================================================================
==================== LSP CONFIGURATION           ====================
=====================================================================
--]]
-- Called from `lua/plugins/lsp.lua`

local M = {}

function M.setup()
  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buf = event.buf, desc = '' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, 'rename')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, 'goto code [a]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, 'goto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- inlay hints may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'inlay hints')
      end

      -- Enable :help lsp-inline-completion to receive Copilot suggestions
      -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#copilot
      -- Note this version is modified to fit into this file instead of a standalone function.
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
        -- By default, inline completion is disabled because it can be a bit noisy, but can be toggled with the keymap below.
        -- vim.lsp.inline_completion.enable(true, { bufnr = event.buf })  -- Uncomment to enable by default.
        map('<leader>ai', function() vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled { bufnr = event.buf }) end, 'Toggle Inline Completion')

        -- Commenting out because 'accept inline completion' is now handled by <Tab> in `lua/plugins/blink.lua`
        -- vim.keymap.set(
        --   'i',
        --   '<C-F>',
        --   vim.lsp.inline_completion.get,
        --   { desc = 'LSP: accept inline completion', buf = event.buf }
        -- )
        vim.keymap.set(
          'i',
          '<C-G>',
          vim.lsp.inline_completion.select,
          { desc = 'LSP: switch inline completion', buf = event.buf }
        )
      end
    end
  })

  -- NOTE: Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = false, -- Text shows up at the end of the line
    virtual_lines = true, -- Text shows up underneath the line, with virtual lines

    -- Gutter icons
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.INFO] = ' ',
        [vim.diagnostic.severity.HINT] = ' 󰌵',
      },
    },

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(diagnostic, bufnr)
        if not diagnostic then
          return
        end
        vim.diagnostic.open_float { bufnr = bufnr }
      end,
    },
    -- old (pre 0.12) syntax for the block above.
    -- jump = { float = true },
  }

  -- Enable the language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- clangd = {},
    -- rust_analyzer = {},
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`ts_ls`) will work just fine
    -- ts_ls = {},
    --
    -- `gopls` defaults include `gotmpl`, which triggers a `:checkhealth vim.lsp`
    -- warning unless you also define that filetype. Trim it for now.
    gopls = {
      filetypes = { 'go', 'gomod', 'gowork' },
    },
    pyright = {},
    bashls = {},
    copilot = {
      settings = {
        telemetry = {
          telemetryLevel = "none"
        },
      },
    },

    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        -- Keep LuaLS fast by giving it a small, curated library.
        --
        -- We intentionally do NOT point at all of `stdpath('data')/lazy`, since
        -- that causes LuaLS to index whole plugin repos (including tests/docs)
        -- and slows completions and diagnostics dramatically.
        --
        -- Instead, add only the plugin files that define the annotation types we
        -- actually use in this config, such as `LazySpec`, `MasonSettings`, and
        -- `blink.cmp.Config`.
        local function plugin_type_file(plugin, relpath)
          local path = vim.fn.stdpath('data') .. '/lazy/' .. plugin .. '/' .. relpath
          return vim.uv.fs_stat(path) and path or nil
        end

        local library = {
          vim.env.VIMRUNTIME,
          -- Include lspconfig's own LuaCATS annotations so LuaLS understands the
          -- LSP settings tables used in this config.
          vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
          '${3rd}/luv/library',
          '${3rd}/busted/library',
        }

        -- These are the specific plugin files that declare the annotation types
        -- referenced throughout this repo. Keeping the list explicit preserves
        -- performance and makes future type additions intentional.
        for _, path in ipairs {
          plugin_type_file('lazy.nvim', 'lua/lazy/types.lua'),
          plugin_type_file('mason.nvim', 'lua/mason/settings.lua'),
          plugin_type_file('gitsigns.nvim', 'lua/gitsigns/config.lua'),
          plugin_type_file('which-key.nvim', 'lua/which-key/config.lua'),
          plugin_type_file('todo-comments.nvim', 'lua/todo-comments/config.lua'),
          plugin_type_file('blink.cmp', 'lua/blink/cmp/config/init.lua'),
          plugin_type_file('blink.cmp', 'lua/blink/cmp/config/types_partial.lua'),
        } do
          if path then
            table.insert(library, path)
          end
        end

        local lua_settings = client.config.settings.Lua
        if type(lua_settings) ~= 'table' then
          lua_settings = {}
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', lua_settings, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- Use the curated library above so we get plugin annotation types
            -- without regressing to the very broad, slow upstream workspace.
            library = library,
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
      },
    },
  }

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- 'stylua' is a formatter, not an LSP server, so it goes here.
    'stylua',
    -- You can add other tools (non-LSP servers) here that you want Mason to install
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

return M
