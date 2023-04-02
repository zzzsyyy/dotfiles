local theme = require("other.utils").get_colorscheme()

return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme " .. theme)
    end,
  },
}
