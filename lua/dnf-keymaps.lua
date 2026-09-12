--[[
NOTE:
=====================================================================
==================== DNF KEYMAPS                 ====================
=====================================================================
--]]
-- Keymaps for getting DNF package info and correct changlogs within Neovim terminal
-- No `return {}` needed since this code simply executes to register the keymaps

local dnf_buf

-- Create scratch buffer
local function preview(lines)
  -- If scratch buffer doesn't exist or has been wiped, create (or recreate) it.
  if not dnf_buf or not vim.api.nvim_buf_is_valid(dnf_buf) then
    dnf_buf = vim.api.nvim_create_buf(false, true)
    -- Map 'q' to quickly close the 'dnf_buf' preview buffer
    vim.keymap.set('n', 'q', '<Cmd>pclose<CR>', {
      buf = dnf_buf,
      silent = true,
      desc = '[q]uit DNF preview',
    })
    -- Wipe the buffer automatically when no longer displayed
    vim.bo[dnf_buf].bufhidden = 'wipe'
  end

  -- Set the buffer's text to be the passed-in DNF output
  -- Reuses buffer if it already exists from previous DNF output
  vim.api.nvim_buf_set_lines(dnf_buf, 0, -1, false, lines)
  -- Open a 'preview' window to display the buffer
  vim.cmd('pbuffer ' .. dnf_buf)
  vim.cmd 'wincmd P'
end

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('dnf_keymaps', { clear = true }),
  callback = function(event)
    local buf = event.buf
    -- Only add the keymaps if we're in a 'terminal' buffer
    -- (redundant since 'TermOpen' in the event type)
    if vim.bo[buf].buftype == 'terminal' then

      -- Get the DNF advisories for package under the cursor
      vim.keymap.set('n', '<leader>da', function()
        vim.cmd [[normal! 0"zyt.]] -- yank package name *without* architecture to 'z' register
        local pkg = vim.trim(vim.fn.getreg 'z')
        local out = vim.fn.systemlist('dnf advisory info --contains-pkgs=' .. vim.fn.shellescape(pkg))

        preview(out)
      end, { buf = buf, silent = true, desc = 'package advisories' })

      -- Get the DNF changelog for package under the cursor
      vim.keymap.set('n', '<leader>dc', function()
        vim.cmd [[normal! 0"zyt ]] -- yank package name *with* architecture to 'z' register
        local pkg = vim.trim(vim.fn.getreg 'z')
        local out = vim.fn.systemlist('dnf changelog ' .. vim.fn.shellescape(pkg))

        preview(out)
      end, { buf = buf, silent = true, desc = 'package changelog' })

      -- Get the DNF info for package under the cursor
      vim.keymap.set('n', '<leader>di', function()
        vim.cmd [[normal! 0"zyt ]] -- yank package name *with* architecture to 'z' register
        local pkg = vim.trim(vim.fn.getreg 'z')
        local out = vim.fn.systemlist('dnf info ' .. vim.fn.shellescape(pkg))

        preview(out)
      end, { buf = buf, silent = true, desc = 'package information' })
    end
  end,
})
