local ui = {}
local conf = require("modules.ui.config")

ui["kyazdani42/nvim-web-devicons"] = { opt = false }
ui["sainnhe/edge"] = { opt = false, config = conf.edge }
ui["shaunsingh/nord.nvim"] = { 
    opt = false,
    config = conf.nord
}
ui["hoob3rt/lualine.nvim"] = {
	opt = true,
	after = "nvim-gps",
	config = conf.lualine,
}
ui["rcarriga/nvim-notify"] = {
	opt = false,
	config = conf.notify,
}
ui["kyazdani42/nvim-tree.lua"] = {
	opt = true,
	cmd = { "NvimTreeToggle" },
	config = conf.nvim_tree,
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	opt = true,
	event = "BufReadPost",
	config = conf.indent_blankline,
}
ui["akinsho/bufferline.nvim"] = {
	opt = true,
	tag = "*",
	event = "BufReadPost",
	config = conf.nvim_bufferline,
}
ui["dstein64/nvim-scrollview"] = {
	opt = true,
	event = { "BufReadPost" },
	config = conf.scrollview,
}
ui["SmiteshP/nvim-gps"] = {
	opt = true,
	after = "nvim-treesitter",
	config = conf.nvim_gps,
}
return ui
