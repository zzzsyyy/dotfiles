local config = {}

function config.filetype()
	require("filetype").setup({
		overrides = {
			shebang = {
				dash = "sh",
			},
		},
	})
end

return config
