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
