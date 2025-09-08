return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    init = function()
      vim.g.opencode_opts = {}
      vim.opt.autoread = true
    end,
    keys = {
      {
        "<leader>oA",
        function()
          require("opencode").ask()
        end,
        desc = "Ask opencode",
      },
      {
        "<leader>oa",
        function()
          require("opencode").ask("@cursor: ")
        end,
        desc = "Ask opencode about this",
      },
      {
        "<leader>oa",
        function()
          require("opencode").ask("@selection: ")
        end,
        mode = "v",
        desc = "Ask opencode about selection",
      },
      {
        "<leader>on",
        function()
          require("opencode").command("session_new")
        end,
        desc = "New opencode session",
      },
      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        mode = { "n", "v" },
        desc = "Select opencode prompt",
      },
      {
        "<leader>oe",
        function()
          require("opencode").prompt("Explain @cursor and its context")
        end,
        desc = "Explain this code",
      },
      {
        "<leader>ot",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle opencode",
      },
    },
  },
}

