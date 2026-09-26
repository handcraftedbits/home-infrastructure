-- Classic command line at the bottom instead of noice's floating box.
return {
  "folke/noice.nvim",

  opts = {
    cmdline = { view = "cmdline" },
    presets = { command_palette = false },
  },
}
