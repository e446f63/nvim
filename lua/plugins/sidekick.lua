--[[
NOTE:
=====================================================================
==================== Sidekick                    ====================
=====================================================================
--]]

return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        -- Commented out since I don't use muxers
        -- mux = {
        --   backend = "zellij",
        --   enabled = true,
        -- },
      },
    },
    keys = {
      -- {
      --  Commented out because Blink handles <Tab> behavior for completions and snippets.
      --  See `lua/plugins/blink.lua` for the configuration.
      --   "<tab>",
      --   function()
      --     -- if there is a next edit, jump to it, otherwise apply it if any
      --     if not require("sidekick").nes_jump_or_apply() then
      --       return "<Tab>" -- fallback to normal tab
      --     end
      --   end,
      --   expr = true,
      --   desc = "Goto/Apply Next Edit Suggestion",
      -- },
      {
        -- Toggle NES on/off.
        "<leader>an",
        function() require("sidekick.nes").toggle() end,
        desc = "Sidekick Toggle NES",
        mode = { "n" },
      },
      {
        -- Blink handles this with `<Tab>` in Insert mode; this is for Normal mode.
        "<leader>aa",
          -- if there is a next edit, jump to it, otherwise apply it if any
        function() require("sidekick").nes_jump_or_apply() end,
        desc = "Goto / Apply NES",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      -- I don't currently use Claude
      -- {
      --   "<leader>ac",
      --   function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      --   desc = "Sidekick Toggle Claude",
      -- },
    },
  }
}
