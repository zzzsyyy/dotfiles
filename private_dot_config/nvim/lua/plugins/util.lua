return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- dep by editor::neo-tree
  { "nvim-lua/plenary.nvim", lazy = true },
  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- nui
  { "MunifTanjim/nui.nvim", lazy = true },
}
