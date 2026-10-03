local ok, err = pcall(function()
  vim.g.trouble_lualine = true
  require("lazy").load({ plugins = { "lualine.nvim" } })
  local symbols = require("trouble.config").get("symbols")
  assert(symbols.source == "lsp.document_symbols", "Trouble LSP symbol source missing")
  local statusline = require("trouble").statusline({ mode = "symbols", groups = {}, title = false })
  assert(type(statusline.get) == "function", "Trouble statusline failed to initialize")
  vim.cmd("doautocmd User VeryLazy")
  local lazy = require("lazy.core.config")
  assert(#(lazy.spec.notifs or {}) == 0, vim.inspect(lazy.spec.notifs))
  assert(vim.g.colors_name:match("^catppuccin"), "Catppuccin was not loaded")
  assert(vim.fn.maparg("<C-Space>", "i") ~= "", "Custom completion mapping missing")
  assert(#vim.api.nvim_get_autocmds({ group = "AutoSave" }) == 2, "Autosave missing")
  for name, plugin in pairs(lazy.plugins) do
    assert(plugin.dir:match("^/nix/store/"), "Non-Nix plugin: " .. name)
    assert(vim.fn.isdirectory(plugin.dir) == 1, "Missing Nix plugin: " .. name)
    assert(not plugin._.build, "Pending runtime build: " .. name)
  end
  assert(not lazy.plugins["mason.nvim"], "Mason should be disabled")
  local treesitter = require("lazy.core.plugin").values(lazy.plugins["nvim-treesitter"], "opts", false)
  assert(#treesitter.ensure_installed == 0, "Runtime parser installs enabled")
  for _, lang in ipairs({ "lua", "python", "json", "markdown", "toml" }) do
    vim.treesitter.language.add(lang)
    assert(vim.treesitter.query.get(lang, "highlights"), "Missing queries: " .. lang)
  end
  for _, name in ipairs({ "hunk.nvim", "jj-diffconflicts", "refactoring.nvim", "neotest", "mini.align" }) do
    assert(lazy.plugins[name], "Missing plugin: " .. name)
  end
  require("lazy").load({ plugins = { "nvim-lspconfig", "blink.cmp", "nvim-dap-python", "neotest" } })
  local blink = require("blink.cmp.config")
  assert(blink.keymap["<CR>"][1] == "fallback")
  assert(blink.keymap["<Tab>"][1] == "select_and_accept")
  assert(vim.wait(3000, function()
    return require("blink.cmp.fuzzy").implementation_type == "rust"
  end), "Rust completion library missing")
  local lsp = require("lazy.core.plugin").values(lazy.plugins["nvim-lspconfig"], "opts", false)
  assert(lsp.servers.basedpyright.settings.basedpyright.analysis.extraPaths[1] == "/home/pm-gusmano/dev/Research/cubitx/src")
  for _, exe in ipairs({ "basedpyright-langserver", "pyright-langserver", "ruff", "lua-language-server", "just-lsp", "marksman", "taplo", "stylua", "debugpy-adapter", "jj" }) do
    assert(vim.fn.executable(exe) == 1, "Missing executable: " .. exe)
  end
  vim.cmd("edit check.amf")
  assert(vim.bo.filetype == "ale3d", "ALE3D file detection missing")
  assert(vim.v.errmsg == "", vim.v.errmsg)
  assert(#(_G.neovim_check_errors or {}) == 0, vim.inspect(_G.neovim_check_errors))
end)
if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
else
  print("Nix Neovim checks passed")
  vim.cmd("qa!")
end
