syntax enable
filetype indent plugin on

let mapleader = "§"

set nocompatible
set formatoptions-=cro
set expandtab smarttab
set incsearch hlsearch
set ignorecase smartcase
set backspace=indent,eol,start
set showcmd showmode showmatch
set noswapfile nobackup nowritebackup
set noautoindent nosmartindent
set noerrorbells
set nowrap
set hidden
set mouse=a
set t_Co=256
set cursorline
set indentexpr=
set cmdheight=2
set pumheight=10
set iskeyword+=-
set shortmess+=c
set shortmess-=F
set pyxversion=3
set laststatus=2
set encoding=utf-8
set fileencoding=utf-8
set number relativenumber
set splitbelow splitright
set rtp+=/usr/local/opt/fzf
set tabstop=2 shiftround shiftwidth=2
set completeopt=menu,menuone,noselect,preview
set wildmenu wildmode=list:longest


call plug#begin()
" COMPLETION
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" INTERFACE
Plug 'bling/vim-bufferline'
Plug 'folke/trouble.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'vim-airline/vim-airline'

" TOOLS
Plug 'ap/vim-css-color'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'mileszs/ack.vim'
Plug 'p00f/nvim-ts-rainbow'
Plug 'raimondi/delimitmate'
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'yggdroot/indentline'

" THEME
Plug 'junegunn/seoul256.vim'
Plug 'sainnhe/everforest'
call plug#end()


lua << EOF

local signs = { Error = "❌", Warn = "⚠️", Hint = "🪄", Info ="🌀" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nl })
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end


local cmp = require'cmp'
cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local util = require'lspconfig.util'

require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_dir = util.root_pattern(
        "*.clangd",
        "*.clang-tidy",
        "*.clang-format",
        "compile_flags.txt",
        "configure.ac"
    ),
    single_file_support = true
}

require'lspconfig'.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "go", "gomod", "gotmpl" },
    root_dir = util.root_pattern("go.mod"),
    single_file_support = true
}

require'lspconfig'.hls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "hs", "haskell", "lhaskell" },
    root_dir = util.root_pattern(
        "*.cabal",
        "stack.yaml",
        "cabal.project",
        "package.yaml",
        "hie.yaml"
    ),
    single_file_support = true
}

local pid = vim.fn.getpid()
local omnisharp_bin = "/Users/george/Git/repos/omnisharp-roslyn/artifacts/publish/OmniSharp.Stdio.Driver/osx-x64/net6.0/OmniSharp"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cs", "vb" },
    root_dir = util.root_pattern("*.sln", "*.csproj"),
    single_file_support = true
}

require'lspconfig'.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "py" },
    single_file_support = true
}

require'lspconfig'.rust_analyzer.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "rust" },
    root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
}

require'lspconfig'.solargraph.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "ruby" },
    init_options = { formatting = true },
    root_dir = util.root_pattern("Gemfile"),
    settings = { solargraph = { diagnostics = true } },
    single_file_support = true
}

require'lspconfig'.sumneko_lua.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
    },
    root_dir = util.root_pattern(
        "*.luarc.json",
        "*.luacheckrc",
        "*.stylua.toml",
        "selene.toml"
    ),
    settings = { Lua = { telemetry = { enable = false } } },
    single_file_support = true
}

require'lspconfig'.tsserver.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    },
    root_dir = util.root_pattern(
        "package.json",
        "tsconfig.json",
        "jsconfig.json"
    )
}




require'trouble'.setup{
    use_diagnostic_signs = true
}

require'telescope'.setup{
    defaults = { file_ignore_patterns = { "node_modules", "target", "obj" } }
}

require'nvim-treesitter.configs'.setup{
    ensure_installed = "all",
    highlight = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    indent = { enable = true }
}


EOF

" vimairline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Easymotion
let g:EasyMotion_do_mapping  = 0
let g:EasyMotion_smartcase   = 1
let g:EasyMotion_startofline = 0
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" FZF
let g:fzf_layout = { 'down': '40%' }

" Ack!
nnoremap <Leader>a :Ack!<Space>

" Delimit Mate
let delimitMate_quotes = "\" `"

" Ultimate Snippets
let g:UltiSnipsExpandTrigger       ="<tab>"
let g:UltiSnipsJumpForwardTrigger  ="<c-b>"
let g:UltiSnipsJumpBackwardTrigger ="<c-z>"

" Multiple-Cursors
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Indent Line
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel  = 0
let g:indentLine_char_list     = ['Æ']
let g:indentLine_enabled       = 1

if $LC_TERMINAL == 'iTerm2'
    set termguicolors
    let g:everforest_background = 'hard'
    let g:everforest_better_performance = 1
    let g:everforest_enable_italic = 1
    let g:everforest_sign_column_background = 'grey'
    let g:everforest_spell_foreground = 1
    let g:everforest_ui_contrast = 'high'
    let g:everforest_diagnostic_text_highlight = 1
    let g:everforest_diagnostic_line_highlight = 1
    colorscheme everforest
else
    let g:seoul256_background = 256
    colo seoul256
endif
let g:airline_theme = 'everforest'

nnoremap <leader>gp :silent %!prettier --stdin-filepath %<CR>

autocmd BufWritePre * :%s/\s\+$//e
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
