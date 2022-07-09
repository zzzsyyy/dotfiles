local modules_dir = vim.fn.stdpath("config").."/lua/modules"
local a = vim.split(vim.fn.globpath(modules_dir,"*/plugins.lua"), "\n")
local list = {}
local repos = {}
for _, f in ipairs(a) do
	list[#list + 1] = f:sub(#modules_dir - 6, -1)
end
for _, m in ipairs(list) do
	local rrepos = require(m:sub(0, #m - 4))
	for repo, conf in pairs(rrepos) do
		repos[#repos + 1] = vim.tbl_extend("force", { repo }, conf)
	end
end
vim.cmd [[packadd packer.nvim]]
require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim", opt = true })
	for _, m in ipairs(repos) do
		use(m)
	end
end)
