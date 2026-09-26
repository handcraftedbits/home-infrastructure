-- Servers with no LazyVim extra.
return {
  "neovim/nvim-lspconfig",

  opts = {
    servers = {
      bashls = {},
      html = {},
      lemminx = {},
    },
  },
}
