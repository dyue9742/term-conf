syntax enable
filetype plugin on
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set cmdheight=2
set pumheight=10
set iskeyword+=-
set shortmess+=c
set shortmess-=F
set completeopt=menu,menuone,noselect
set noautoindent nosmartindent
set noexpandtab nosmarttab
set indentexpr=
set tabstop=2 softtabstop=0 shiftwidth=0
set mouse=a
set cc=80
set t_Co=256
set number relativenumber
set splitbelow splitright
set hidden
set nowrap
set nobackup
set noswapfile
set noshowmode
set nowritebackup
set updatetime=300
set timeoutlen=500
set formatoptions-=cro


call plug#begin()
" THEME
Plug 'sainnhe/everforest'
Plug 'sainnhe/gruvbox-material'

" TOOLS
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-bufferline'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'majutsushi/tagbar'
Plug 'raimondi/delimitmate'
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" INTERFACE
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

call plug#end()

au! BufWritePre $MYVIMRC source %
autocmd BufWritePre * :%s/\s\+$//e
map <F7> gg=G<C-o><C-o>

:lua << EOF

require'telescope'.setup{ defaults = { file_ignore_patterns = {"node_modules"} } }

require'nvim-treesitter.configs'.setup{
	ensure_installed = "all",
	highlight = {
		enable = true
	},
	indent = { enable = true }
}

require'lualine'.setup{ options = { theme = 'gruvbox-material' } }

require'bufferline'.setup{}

local cmp = require'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
		vim.fn["vsnip#anonymous"](args.body)
	end
	},
	mapping = {
		['<C-q>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i','c'}),
		['<C-e>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i','c'}),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i','c'}),
		['<C-y>'] = cmp.config.disable,
		['<C-a>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }
	}, {
		{ name = 'buffer' },
	})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require'lspconfig'
nvim_lsp.clangd.setup{
	capabilities = capabilities
}
nvim_lsp.gopls.setup{
	capabilities = capabilities
}
nvim_lsp.hls.setup{
	capabilities = capabilities
}
nvim_lsp.pyright.setup{
	capabilities = capabilities
}
nvim_lsp.rust_analyzer.setup{
	capabilities = capabilities
}
nvim_lsp.solargraph.setup{
	capabilities = capabilities
}
nvim_lsp.texlab.setup{
	capabilities = capabilities
}
nvim_lsp.tsserver.setup{
	capabilities = capabilities
}

EOF

autocmd BufEnter * lua require'completion'.on_attach()

nnoremap <c-f> :Telescope find_files<CR>
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>b] :BufferLineCyclePrev<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <F8> :TagbarToggle<CR>

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

let g:indentLine_enabled = 0
let delimitMate_quotes = "\" `"

let g:fzf_layout = {'down': '40%'}
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
	\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


if has('termguicolors')
	set termguicolors
endif
set background=dark
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material
" let g:everforest_enable_italic = 1
" let g:everforest_background = 'hard'
" colorscheme everforest
