return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
  },
  keys = {
    {
      "<leader>re",
      function()
        return require("refactoring").extract_func()
      end,
      mode = { "n", "x" },
      desc = "Extract function",
      expr = true,
    },
    {
      "<leader>ree",
      function()
        return require("refactoring").extract_func() .. "_"
      end,
      mode = "n",
      desc = "Extract function (line)",
      expr = true,
    },
    {
      "<leader>rE",
      function()
        return require("refactoring").extract_func_to_file()
      end,
      mode = { "n", "x" },
      desc = "Extract function to file",
      expr = true,
    },
    {
      "<leader>rv",
      function()
        return require("refactoring").extract_var()
      end,
      mode = { "n", "x" },
      desc = "Extract variable",
      expr = true,
    },
    {
      "<leader>rvv",
      function()
        return require("refactoring").extract_var() .. "_"
      end,
      mode = "n",
      desc = "Extract variable (line)",
      expr = true,
    },
    {
      "<leader>ri",
      function()
        return require("refactoring").inline_var()
      end,
      mode = { "n", "x" },
      desc = "Inline variable",
      expr = true,
    },
    {
      "<leader>rI",
      function()
        return require("refactoring").inline_func()
      end,
      mode = { "n", "x" },
      desc = "Inline function",
      expr = true,
    },
    {
      "<leader>rs",
      function()
        require("refactoring").select_refactor()
      end,
      mode = { "n", "x" },
      desc = "Select refactor",
    },
    {
      "<leader>pv",
      function()
        return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
      end,
      mode = "n",
      desc = "Debug print variable below",
      expr = true,
    },
    {
      "<leader>pv",
      function()
        return require("refactoring.debug").print_var({ output_location = "below" })
      end,
      mode = "x",
      desc = "Debug print variable below",
      expr = true,
    },
    {
      "<leader>pV",
      function()
        return require("refactoring.debug").print_var({ output_location = "above" }) .. "iw"
      end,
      mode = "n",
      desc = "Debug print variable above",
      expr = true,
    },
    {
      "<leader>pV",
      function()
        return require("refactoring.debug").print_var({ output_location = "above" })
      end,
      mode = "x",
      desc = "Debug print variable above",
      expr = true,
    },
    {
      "<leader>pe",
      function()
        return require("refactoring.debug").print_exp({ output_location = "below" })
      end,
      mode = { "n", "x" },
      desc = "Debug print expression below",
      expr = true,
    },
    {
      "<leader>pee",
      function()
        return require("refactoring.debug").print_exp({ output_location = "below" }) .. "_"
      end,
      mode = "n",
      desc = "Debug print expression below (line)",
      expr = true,
    },
    {
      "<leader>pE",
      function()
        return require("refactoring.debug").print_exp({ output_location = "above" })
      end,
      mode = { "n", "x" },
      desc = "Debug print expression above",
      expr = true,
    },
    {
      "<leader>pEE",
      function()
        return require("refactoring.debug").print_exp({ output_location = "above" }) .. "_"
      end,
      mode = "n",
      desc = "Debug print expression above (line)",
      expr = true,
    },
    {
      "<leader>pP",
      function()
        return require("refactoring.debug").print_loc({ output_location = "above" })
      end,
      mode = "n",
      desc = "Debug print location above",
      expr = true,
    },
    {
      "<leader>pp",
      function()
        return require("refactoring.debug").print_loc({ output_location = "below" })
      end,
      mode = "n",
      desc = "Debug print location below",
      expr = true,
    },
    {
      "<leader>pc",
      function()
        return require("refactoring.debug").cleanup({ restore_view = true })
      end,
      mode = { "n", "x" },
      desc = "Debug print cleanup",
      expr = true,
      remap = true,
    },
  },
  lazy = false,
}
