local tools = {}
local conf = require("modules.tools.config")

tools["nathom/filetype.nvim"] = {
	opt = false,
	config = conf.filetype,
}

return tools
