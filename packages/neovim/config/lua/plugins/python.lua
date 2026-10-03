return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                extraPaths = {
                  "/home/pm-gusmano/dev/Research/cubitx/src",
                  "/home/pm-gusmano/.local/opt/Cubit-17.08/bin",
                },
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
