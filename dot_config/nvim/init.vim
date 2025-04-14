" Automatically downloads vim-plug on first startup
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
        !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

lua vim.loader.enable()

call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'alvan/vim-closetag'
Plug 'maxmx03/solarized.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'DanilaMihailov/beacon.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'goolord/alpha-nvim'

" Autocompletion plugins
Plug 'hrsh7th/nvim-cmp'             " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'         " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'           " Buffer completions
Plug 'hrsh7th/cmp-path'             " Path completions
Plug 'hrsh7th/cmp-cmdline'          " Command line completions
Plug 'saadparwaiz1/cmp_luasnip'     " Snippet completions
Plug 'L3MON4D3/LuaSnip'             " Snippet engine

" Typst
Plug 'chomosuke/typst-preview.nvim', {'tag': 'v1.*', 'do': ':TypstPreviewUpdate'}

" LSP and language servers
Plug 'neovim/nvim-lspconfig', {'tag': 'v1.0.0'}             " Configures language servers
Plug 'williamboman/mason.nvim'           " Package manager for language servers
Plug 'williamboman/mason-lspconfig.nvim' " Bridges mason and lspconfig

" Code parsing (treesitter)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lukas-reineke/indent-blankline.nvim'  " Adds indentation guides
Plug 'ThePrimeagen/refactoring.nvim'        " Refactoring utilities
Plug 'andymass/vim-matchup'                 " Extends % to language keywords and constructs
Plug 'nvim-lua/plenary.nvim'                " Required by refactoring.nvim
Plug 'HiPhish/rainbow-delimiters.nvim'      " Colored nested braces and constructs

" Others
" Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-fugitive'
Plug 'lukas-reineke/virt-column.nvim'   " Show a character as colorcolumn
Plug 'folke/todo-comments.nvim'         " Highlight and search TODO comments
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'} " Manage terminal sessions
" Plug 'jiangmiao/auto-pairs'


call plug#end()

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml*.jsx,*.js'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,js,jsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

let g:latex_view_method = 'zathura'

" REMAPPINGS
nnoremap <C-l> gt 
nnoremap <C-h> gT 
nnoremap <C-p> :nohlsearch <Cr>
" Move to the end of the line without exiting insert mode
inoremap <C-a> <C-o>A
tnoremap <Esc> <C-\><C-n> 
tmap <C-l> <Esc>gt
tmap <C-h> <Esc>gT
nnoremap <C-n> :NvimTreeToggle<CR>

nnoremap <silent> <leader>d :lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>tc :TypstPreview<CR>
nnoremap <silent> <leader>fs :TexlabForward<CR>

" nnoremap <silent> 

filetype plugin on
filetype indent on
syntax on
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set expandtab
set nofixendofline " disable automatic newline at end of file
set t_Co=16
set number
set omnifunc=syntaxcomplete#Complete
set cursorline
set textwidth=120
set colorcolumn=120
set clipboard=unnamedplus
set encoding=UTF-8
colorscheme catppuccin

lua require('nvim-web-devicons').setup { default = true }

lua << END
    -- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.g.nvim_tree_respect_buf_cwd = 1

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  }
})
END

" Setup lualine (status line)
"
lua << EOF
require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = { right = '', left = '' },
    -- component_separators = { right = '', left = '' },
    component_separators = { right = '', left = '' },
    icons_enabled = true,
  },
  sections = {
    lualine_a = {
      function() return '' end, 'mode'
    },
    lualine_b = {'branch'},
    lualine_c = {
      {'filename', path = 1}, -- Shows file and folder
    },
    lualine_x = {'diagnostics', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
}
EOF

" Beacon (for cursor highlighting)
"
lua require('beacon').setup()

" Setup bufferline (tabs)
"
set mousemoveevent
set termguicolors
lua << EOF
require("bufferline").setup{
        options = {
            mode = "tabs",
            themable = true,
            separator_style = "slant",
            indicator = {
                icon = 'O', -- this should be omitted if indicator style is not 'icon'
                style = 'icon'
            },
        }
    }
EOF


lua << EOF
  local startify = require('alpha.themes.startify')
  startify.file_icons.provider = "devicons"
  require('alpha').setup(startify.config)
EOF


" Setup nvim-cmp (autocompletion)
"
lua << EOF
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- Expand snippets
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    hover = cmp.config.window.bordered(),
  },
 mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },   -- LSP source
    { name = 'luasnip' },    -- Snippet source
  }, {
    { name = 'buffer' },     -- Buffer source
  })
})

-- Customize the hover window with a border, similar to completion popup
vim.o.winborder = 'rounded'

-- Global variable to track focus state (default true)
local nvim_focused = true

-- Update when Neovim gains focus
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    nvim_focused = true
  end,
})

-- Update when Neovim loses focus
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    nvim_focused = false
  end,
})

-- Boolean helper function to check if Neovim is focused
local function is_nvim_focused()
  return nvim_focused
end

-- Returns true if there's already an hover window opened
local function is_hover_open()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative and config.relative ~= "" then
      return true
    end
  end
  return false
end

-- Check if the LSP supports hover for the current buffer
function show_hover_if_supported()
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    if is_nvim_focused() and client.supports_method("textDocument/hover") and not is_hover_open() then
      vim.lsp.buf.hover()
      return
    end
  end
end

-- Show LSP hover documentation when the cursor moves over a symbol
vim.cmd([[
  augroup lsp_hover
    autocmd!
    autocmd CursorHold * lua show_hover_if_supported()
  augroup END
]])

-- Optional: Set `updatetime` to make hover appear faster (e.g., 1 second)
vim.o.updatetime = 1000

EOF

" LSP Configuration
"
lua << EOF
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.pyright.setup {
  capabilities = capabilities,
}
lspconfig.tinymist.setup {
  capabilities = capabilities,
}
lspconfig.biome.setup {
  capabilities = capabilities,
}
lspconfig.nil_ls.setup {
  capabilities = capabilities,
}
lspconfig.dockerls.setup {
  capabilities = capabilities,
}
lspconfig.clangd.setup({
  capabilities = capabilities,
	-- 	cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
	-- 	init_options = {
	-- 		fallbackFlags = { "-std=c++17" },
	-- 	},
})
-- lspconfig.opts = {
-- 	servers = {
-- 		clangd = {
-- 			mason = false,
-- 		},
-- 	},
-- }

EOF

" Typst-preview
"
lua << EOF
require('typst-preview').setup {
  open_cmd = 'google-chrome-stable --app=%s --disable-extensions --disable-background-networking --disable-background-timer-throttling',
}
EOF

" Tinymist
"
lua << EOF
require('lspconfig') .tinymist.setup {
    offset_encoding = 'utf-8',
    settings = {
        formatterMode = 'typstyle',
        exportPdf = 'onSave',
    },
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
}
EOF

lua << EOF
require('lspconfig').biome.setup {
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
}
EOF

" TexLab
"
lua << EOF
require('lspconfig').texlab.setup{
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        forwardSearchAfter = true,
        onSave = true,
      },
      forwardSearch = {
      executable = "zathura", -- Replace with your PDF viewer
      args = { "--synctex-forward", "%l:1:%f", "%p" },
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = false,
      },
    },
  },
}
EOF


" Mason (package manager for language servers)
"
lua require('mason').setup()
lua << EOF
require('mason-lspconfig').setup {
  ensure_installed = {
    'tinymist', 'texlab', 'pyright', 'biome', 'nil_ls', 'dockerls',
  }
}
EOF

" Indent-blankline
"
lua << EOF
require('ibl').setup {
  -- indent = { char = "┋" },
  scope = { enabled = true }
}
EOF

lua << EOF
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "python", "typst", "vim", "lua", "dockerfile" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true,
    disable = { "typst" }
  },
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    disable = { },  -- optional, list of language that will be disabled
  },
}
EOF

" lua require('refactoring').setup()

lua << EOF
require("catppuccin").setup({
  integrations = {
    treesitter = true,  -- Enable or customize Catppuccin's Tree-sitter integration
    -- other integrations
  },
})
EOF

lua require("virt-column").setup()

lua require("todo-comments").setup()

lua << EOF
  require("toggleterm").setup({
  open_mapping = [[<c-t>]],
  start_in_insert = true,
})
EOF
