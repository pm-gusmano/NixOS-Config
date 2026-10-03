-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Signature Help" })

vim.keymap.set("i", "<C-Space>", function()
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    blink.show()
  elseif vim.lsp.completion then
    vim.lsp.completion.get()
  end
end, { desc = "Show Completion" })
