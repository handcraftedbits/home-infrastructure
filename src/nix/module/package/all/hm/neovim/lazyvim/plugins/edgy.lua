-- Fixed sidebars: file tree left, outline right. Quit Neovim once only sidebars remain, and open the tree at startup.
--
-- Edgy snaps its panels back to their configured size after any resize it did not make, which defeats dragging the separator with the mouse. The
-- WinResized hook below is registered before edgy's own handler, so it runs first and records the dragged width as the sidebar's new size for the
-- rest of the session. Resize events carry no caller information and plugins such as aerial resize their own windows on open, so the hook only
-- records widths while the left mouse button is held down.
return {
  "folke/edgy.nvim",

  config = function(_, opts)
    local dragging = false

    vim.on_key(function(key)
      local name = vim.fn.keytrans(key)

      if name == "<LeftMouse>" or name == "<LeftDrag>" then
        dragging = true
      elseif name == "<LeftRelease>" then
        dragging = false
      end
    end)

    vim.api.nvim_create_autocmd("WinResized", {
      callback = function()
        if not dragging then
          return
        end

        for _, win in ipairs(vim.v.event.windows) do
          local edgy_win = require("edgy.window").cache[win]

          if edgy_win and edgy_win.view.edgebar.vertical then
            edgy_win.view.edgebar.size = vim.api.nvim_win_get_width(win)
          end
        end
      end,
    })

    require("edgy").setup(opts)
    require("edgy").open("left")
  end,

  opts = {
    animate = { enabled = false },
    exit_when_last = true,
    options = {
      left = { size = 50 },
      right = { size = 60 },
    },
  },
}
