return {
  "echasnovski/mini.files",
  keys = {
    {
      "<leader>fM",
      false,
    },
    {
      "<leader>fm",
      "",
      desc = "mini.files",
    },
    {
      "<leader>fmf",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (directory of current file)",
    },
    {
      "<leader>fmc",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>fmr",
      function()
        require("mini.files").open(LazyVim.root(), true)
      end,
      desc = "Open mini.files (root)",
    },
  },
}
