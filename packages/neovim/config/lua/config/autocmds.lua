-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Configure Autosave for when we leave buffers or windows
local autosave = vim.api.nvim_create_augroup("AutoSave", { clear = true })

local function autosave_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if not vim.bo[buf].modified or not vim.bo[buf].modifiable or vim.bo[buf].buftype ~= "" then
    return
  end

  if vim.api.nvim_buf_get_name(buf) == "" then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! update!")
  end)
end

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = autosave,
  callback = function(event)
    autosave_buffer(event.buf)
  end,
})
