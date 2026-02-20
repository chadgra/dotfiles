-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable auto-formatting of files on "Save"
-- formatting can still be triggered manually with `leader>cf`
vim.g.autoformat = false

vim.opt.number = true
vim.opt.relativenumber = false

-- Clipboard over SSH + tmux: send OSC 52 escape sequences directly
-- to the tmux client's TTY, bypassing tmux's escape sequence handling.
-- This works because kitty (on the Mac) understands OSC 52 natively.
-- When not in tmux, write to the terminal via nvim_chan_send.
local function osc52_copy(lines)
  local encoded = vim.base64.encode(table.concat(lines, "\n"))
  local osc = string.format("\027]52;c;%s\027\\", encoded)

  if vim.env.TMUX then
    -- Get the tmux client TTY and write directly to it, bypassing tmux
    local handle = io.popen("tmux display-message -p '#{client_tty}'")
    if handle then
      local client_tty = handle:read("*l")
      handle:close()
      if client_tty and client_tty ~= "" then
        local tty = io.open(client_tty, "w")
        if tty then
          tty:write(osc)
          tty:close()
          return
        end
      end
    end
  end

  -- Fallback: write via neovim's terminal channel
  vim.api.nvim_chan_send(2, osc)
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52_copy,
    ["*"] = osc52_copy,
  },
  paste = {
    ["+"] = function()
      return vim.split(vim.fn.getreg('"'), "\n")
    end,
    ["*"] = function()
      return vim.split(vim.fn.getreg('"'), "\n")
    end,
  },
}

-- LazyVim sets clipboard="" when SSH_CONNECTION is detected, which prevents
-- yanks from reaching the +/* registers. Override so yanks use our provider.
vim.opt.clipboard = "unnamedplus"
