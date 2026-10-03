-- Nix owns all plugin sources. Lazy only handles configuration and load events.
local plugins = vim.json.decode([[@pluginPaths@]])
vim.opt.rtp:prepend(plugins["lazy.nvim"])

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
    -- Apply Nix integration after the original dotfiles and LazyVim extras.
    {
      "nvim-lualine/lualine.nvim",
      -- Trouble discovers its sources through runtimepath, so load the full
      -- plugin before lualine asks it for the document-symbol statusline.
      dependencies = { "folke/trouble.nvim" },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = { install_dir = "@treesitterSite@", ensure_installed = {} },
      opts_extend = {},
    },
    { "mason-org/mason.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "jay-babu/mason-nvim-dap.nvim", enabled = false },
    {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        for _, server in pairs(opts.servers) do
          if type(server) == "table" then
            server.mason = false
          end
        end
      end,
    },
    {
      "saghen/blink.cmp",
      opts = { fuzzy = { prebuilt_binaries = { download = false } } },
    },
  },
  defaults = { lazy = false, version = false },
  dev = {
    path = function(plugin)
      -- Lazy resolves optional specs before discarding unused plugins.
      return plugins[plugin.name] or (vim.g.pm_neovim_config .. "/unpackaged/" .. plugin.name)
    end,
    patterns = { "." },
    fallback = false,
  },
  lockfile = vim.g.pm_neovim_config .. "/lazy-lock.json",
  local_spec = false,
  install = { missing = false, colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  rocks = { enabled = false },
  pkg = { enabled = false },
  performance = {
    rtp = {
      paths = { vim.g.pm_neovim_config, "@treesitterSite@" },
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
