call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'Shougo/context_filetype.vim'
Plug 'tyru/caw.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-orgmode/orgmode'
call plug#end()
colorscheme nord
set noshowmode
set nu
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}
let g:nord_uniform_diff_background = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:nord_italic = 1
let g:nord_cursor_line_number_background = 1
let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'separator': {
		\ 'left': "\ue0b0",
		\ 'right': "\ue0b2",
		\ }
	\ }
se mouse+=a

lua <<EOF
local modules_dir = vim.fn.stdpath("config").."/lua/modules"
print(modules_dir)
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
	for _, m in ipairs(repos) do
		use(m)
	end
end)

EOF
