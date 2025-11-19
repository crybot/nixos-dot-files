-- TODO: REMAP :tabm ±i to move active tab

------------------------------------------------------------
-- Neovim init.lua (Converted from VimL)
------------------------------------------------------------

-- Enable the Lua loader (faster startup)
vim.loader.enable()

------------------------------------------------------------
-- Global Settings & Options
------------------------------------------------------------
vim.opt.encoding = "UTF-8"
vim.opt.number = true                          -- show line numbers
vim.opt.cursorline = true                      -- highlight current line
vim.opt.tabstop = 2                            -- number of spaces per tab
vim.opt.softtabstop = 2                        -- number of spaces in tab when editing
vim.opt.shiftwidth = 2                         -- number of spaces for indentation
vim.opt.expandtab = true                       -- use spaces instead of tabs
vim.opt.autoindent = true                      -- copy indent from current line
vim.opt.fixendofline = false                   -- disable automatic newline at end of file
vim.opt.textwidth = 120                        -- maximum width of text before wrapping
vim.opt.colorcolumn = "120"                    -- highlight column 120
vim.opt.clipboard = "unnamedplus"              -- use system clipboard
vim.opt.termguicolors = true                   -- enable true colors
-- vim.opt.t_Co = 16                              -- terminal colors (if needed)
vim.opt.omnifunc = 'syntaxcomplete#Complete'    -- omnifunc for completion
-- globally set the indent expression to Tree-sitter’s indent function
vim.opt.indentexpr = "nvim_treesitter#indent()"

-- Enable filetype plugins and syntax highlighting
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")

------------------------------------------------------------
-- Global Variables for Plugins
------------------------------------------------------------
-- vim-closetag settings
vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml*.jsx,*.js'
vim.g.closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
vim.g.closetag_filetypes = 'html,xhtml,phtml,js,jsx'
vim.g.closetag_xhtml_filetypes = 'xhtml,jsx,js'
vim.g.closetag_emptyTags_caseSensitive = 1
vim.g.closetag_regions = {
  ['typescript.tsx'] = 'jsxRegion,tsxRegion',
  ['javascript.jsx'] = 'jsxRegion',
  ['typescriptreact'] = 'jsxRegion,tsxRegion',
  ['javascriptreact'] = 'jsxRegion',
}
vim.g.closetag_shortcut = '>'
vim.g.closetag_close_shortcut = '<leader>>'

-- LaTeX viewer setting
vim.g.latex_view_method = 'zathura'

------------------------------------------------------------
-- Key Mappings
------------------------------------------------------------
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Navigation for tab pages
map('n', '<C-l>', 'gt', opts)
map('n', '<C-h>', 'gT', opts)

-- Clear search highlighting
map('n', '<C-p>', ':nohlsearch<CR>', opts)

-- In insert mode, move to end of line without leaving insert mode
map('i', '<C-a>', '<C-o>A', {})

-- Terminal mode remappings for proper escape and tab navigation
map('t', '<Esc>', '<C-\\><C-n>', opts)
map('t', '<C-l>', '<Esc>gt', opts)
map('t', '<C-h>', '<Esc>gT', opts)

-- Toggle NvimTree (file explorer)
map('n', '<C-n>', ':NvimTreeToggle<CR>', opts)

-- LSP diagnostics
map('n', '<leader>d', ':lua vim.diagnostic.open_float()<CR>', opts)
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true })
map('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true })

-- Typst preview
map('n', '<leader>tc', ':TypstPreview<CR>', opts)
-- Forward search for TexLab (LaTeX)
map('n', '<leader>ts', ':TexlabForward<CR>', opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Telescope grep cursor' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope lsp references' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Telescope lsp definitions' })

-- Other
-- map('n', '<leader>R <cmd>source $MYVIMRC<CR>', opts)

------------------------------------------------------------
-- Plugin Setup & Configurations
------------------------------------------------------------

------------------
-- nvim-web-devicons
------------------
require('nvim-web-devicons').setup { default = true }

------------------
-- Disable netrw for nvim-tree
------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

------------------
-- nvim-tree (File Explorer)
------------------
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

------------------
-- lualine (Status Line)
------------------
require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = { right = '', left = '' },
    component_separators = { right = '', left = '' },
    icons_enabled = true,
  },
  sections = {
    lualine_a = { function() return '' end, 'mode' },
    lualine_b = {'branch'},
    lualine_c = { {'filename', path = 1} },
    lualine_x = {'diagnostics', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
}

------------------
-- snacks (QoL improvements)
require('snacks').setup{
  bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  -- explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  -- quickfile = { enabled = true },
  -- scope = { enabled = true },
  -- scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  -- words = { enabled = true },
}

------------------
-- smear-cursor (Enhanced cursor highlighting)
------------------
require('smear_cursor').setup{
  stiffness = 0.8,
  trailing_stiffness = 0.5,
  distance_stop_animating = 0.5,
  smear_to_cmd = false, -- otherwise it breaks inputlist() choices (See https://github.com/neovim/neovim/issues/32068)
}

------------------
-- bufferline (Tabline)
------------------
vim.cmd("set mousemoveevent")
vim.opt.termguicolors = true

require("bufferline").setup{
  options = {
    mode = "tabs",
    themable = true,
    separator_style = "slant",
    indicator = {
      icon = 'O',
      style = 'icon'
    },
    diagnostics = "nvim_lsp",
  }
}

------------------
-- alpha-nvim (Start Screen)
------------------
local startify = require('alpha.themes.startify')
startify.file_icons.provider = "devicons"
require('alpha').setup(startify.config)

------------------
-- nvim-cmp (Autocompletion)
------------------
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
      { name = 'buffer' },
    })
})
vim.opt.winborder = 'rounded'

------------------
-- LSP Hover on CursorHold
------------------
local nvim_focused = true

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function() nvim_focused = true end,
})
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function() nvim_focused = false end,
})

-- Returns true if there's already an hover window opened
local function is_hover_open()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative and config.relative ~= "" and config.relative ~= "editor" then
      return true
    end
  end
  return false
end

function show_hover_if_supported()
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    if nvim_focused and client.supports_method("textDocument/hover") and not is_hover_open() then
      vim.lsp.buf.hover()
      return
    end
  end
end

-- Create an autocommand that triggers on CursorHold and simply calls the hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = show_hover_if_supported
})
vim.opt.updatetime = 1000

------------------
-- LSP Configuration
------------------
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Pyright
lspconfig.pyright.setup { capabilities = capabilities }

-- Tinymist
lspconfig.tinymist.setup {
  capabilities = capabilities,
  offset_encoding = 'utf-8',
  settings = {
    formatterMode = 'typstyle',
    exportPdf = 'onSave',
  },
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
}

-- Biome
lspconfig.biome.setup {
  capabilities = capabilities,
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
}

-- nil_ls
lspconfig.nil_ls.setup { capabilities = capabilities }

-- Docker LS
lspconfig.dockerls.setup { capabilities = capabilities }

-- Clangd
lspconfig.clangd.setup({
  capabilities = capabilities,
  -- Uncomment and adjust if needed:
  cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
  init_options = { fallbackFlags = { "-std=c++23" } },
})

-- TexLab (LaTeX)
lspconfig.texlab.setup{
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        forwardSearchAfter = true,
        onSave = true,
      },
      forwardSearch = {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = false,
      },
    },
  },
}

------------------
-- Typst Preview
------------------
require('typst-preview').setup {
  -- open_cmd = 'google-chrome-stable --app=%s --disable-extensions --disable-background-networking --disable-background-timer-throttling',
  -- open_cmd = 'firefox %s -P typst-preview --class typst-preview',
  open_cmd = 'firefox %s -P typst-preview --class typst-preview &',
}

------------------
-- Mason (LSP Installer)
------------------
-- require('mason').setup()
-- require('mason-lspconfig').setup {
--   ensure_installed = {
--     'tinymist', 'texlab', 'pyright', 'biome', 'nil_ls', 'dockerls',
--   }
-- }

------------------
-- Indent-Blankline Replacement (ibl)
------------------
-- require('ibl').setup {
--   scope = { enabled = true }
-- }

------------------
-- Treesitter
------------------
require('nvim-treesitter.configs').setup {
  -- ensure_installed = { "python", "typst", "vim", "lua", "dockerfile" },
  sync_install = false,
  -- auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "typst" },
  },
  matchup = {
    enable = true,
    disable = {},
  },
}

------------------
-- Catppuccin (Color Scheme Integration)
------------------
require("catppuccin").setup({
  integrations = {
    treesitter = true,
    -- Add other integrations as needed
  },
})

------------------
-- virt-column (Visual Column Marker)
------------------
require("virt-column").setup()

------------------
-- todo-comments (Highlight TODOs)
------------------
require("todo-comments").setup()

------------------
-- toggleterm (Terminal Manager)
------------------
require("toggleterm").setup({
  open_mapping = [[<c-t>]],
  start_in_insert = true,
})

require('osc52').setup()
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      require('osc52').copy_register('')
    end
  end,
})
