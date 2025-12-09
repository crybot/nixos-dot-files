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

-- Set the leader key on the spacebar (default is \, which is hard to reach)
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- Optional: for filetype-specific mappings

-- Enable filetype plugins and syntax highlighting
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Set colorscheme
-- vim.cmd("colorscheme catppuccin")
-- colorscheme catppuccin

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
map('n', '<C-p>', ':nohlsearch<CR>:echo<CR>', opts)

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


-- Telescope keymaps
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Telescope grep cursor' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope lsp references' })
-- vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Telescope lsp definitions' })


-- Normal-mode mapping: open references for symbol under cursor, in NORMAL mode
-- vim.keymap.set('n', '<leader>fr', function()
--   require('telescope.builtin').lsp_references{
--     initial_mode = "normal", -- <-- open the picker in normal mode
--     include_declaration = true, -- optional: include the declaration itself
--     show_line = true,            -- optional: show the line text
--   }
-- end, { desc = 'Telescope lsp references', noremap = true, silent = true })


-- Persistence keymaps (sessions)
-- load the session for the current directory
vim.keymap.set("n", "<leader>pl", function() require("persistence").load() end, { desc = 'Load last session for the current directory' } )
-- select a session to load
vim.keymap.set("n", "<leader>ps", function() require("persistence").select() end, { desc = 'Select session' } )
-- load the last session
-- vim.keymap.set("n", "<leader>pl", function() require("persistence").load({ last = true }) end, { desc = 'Load last session' } )
-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>pd", function() require("persistence").stop() end, { desc = 'Forget this session' } )

-- Other
-- map('n', '<leader>R <cmd>source $MYVIMRC<CR>', opts)

------------------------------------------------------------
-- Plugin Setup & Configurations
------------------------------------------------------------

------------------
-- Catppuccin (Color Scheme Integration)
------------------
require("catppuccin").setup({
  flavour = "macchiato",
  auto_integrations = true,

  integrations = {
    treesitter = true,
    aerial = true,
    navic = {
      enabled = true,
      custom_bg = "lualine",
    },
  },

  styles = {
    comments = { "italic" },
    -- conditionals = { "italic" }, -- (if, else) Separates logic from data
    -- loops = { "italic" },        -- (for, while) Matches conditionals style
    functions = { "bold" },      -- (func_name) Makes function calls/definitions pop
    -- keywords = { "italic" },     -- (return, class) Helps scan for structure
    strings = {},                -- Keep plain to avoid visual clutter
    variables = {},              -- Keep plain; they are the most common text
    numbers = {},
    booleans = { "bold" },       -- (true, false) Important constants often drive logic
    properties = {},
    types = { "bold" },          -- (String, Int) Distinguishes types from variables
    operators = {},
  },
  lsp_styles = {
    underlines = {
      errors = { "undercurl" },    -- "Squiggly" lines are standard for errors
      hints = { "underline" },
      warnings = { "undercurl" },  -- Distinguish warnings from info/hints
      information = { "underline" },
    },
    inlay_hints = {
      background = true,
    },
  },

})

vim.cmd.colorscheme "catppuccin"


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
-- navic (needed by lualine)
------------------
local navic = require('nvim-navic')
navic.setup {
  lsp = {
    auto_attach = true,
  },
  highlight = true,
}
-- vim.api.nvim_set_hl(0, "NavicText", { fg = "#ff9e64", bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NavicSeparator", { fg = "#ff9e64", bg = "NONE" })

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
    lualine_b = { 'branch' },
    lualine_c = {
      { 'filename', path = 1 },
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end,
      },
    },
    lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

------------------
-- snacks (QoL improvements)
require('snacks').setup{
  -- dashboard = { enabled = true },
  -- quickfile = { enabled = true },
  -- scope = { enabled = true },
  -- scroll = { enabled = true },
  -- statuscolumn = { enabled = true },
  -- dim = { 
  --   enabled = true,
  --   scope = "window",
  --   alpha = 0.5,
  -- },
  bigfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  words = { enabled = true },
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        tree = true,
        auto_close = true,
        win = {
          list = {
            keys = {
              ["<C-t>"] = "edit_tab",  -- open selection in a new tab
            },
          },
        },
      },
    },
  },
  scratch = {
    enabled = true,
    auto_save = true,
    auto_restore = true,
  },
}

-- 1. Keymap to open the Explorer

-- Top Pickers & Explorer
vim.keymap.set('n', '<leader>e', function() require("snacks.explorer").open() end, { desc = "Snacks Explorer (Toggle)" })
vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, {desc = "Smart Find Files"}) -- TODO: maybe map buffers() instead
vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, {desc = "Grep"})
vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, {desc = "Toggle Scratch Buffer"})

-- files
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, {desc = "Find Files"})
vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, {desc = "Recent Files"})

-- buffers
vim.keymap.set('n', '<leader>fs', function() Snacks.scratch() end, {desc = "Scratch"})

-- search
-- vim.keymap.set('n', '<leader>gI', function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation"})
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, {desc = "Grep"})
vim.keymap.set('n', '<leader>sc', function() Snacks.picker.grep_word() end, {desc = "Search word under cursor"})
vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, {desc = "Marks"})

-- lsp
vim.keymap.set('n', '<leader>gd', function() Snacks.picker.lsp_definitions() end, {desc = "Goto Definition"})
vim.keymap.set('n', '<leader>gD', function() Snacks.picker.lsp_declarations() end, {desc = "Goto Declaration"})
vim.keymap.set('n', '<leader>gr', function() Snacks.picker.lsp_references() end, {desc = "References"})
vim.keymap.set('n', '<leader>gI', function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation"})




-- -- 2. Common keymap for revealing the current file
-- vim.keymap.set('n', '<leader>E', function()
--   require("snacks.explorer").reveal()
-- end, { desc = "Snacks Explorer (Reveal Current File)" })

------------------
-- smear-cursor (Enhanced cursor highlighting)
------------------
require('smear_cursor').setup{
  stiffness = 0.8,
  trailing_stiffness = 0.5,
  distance_stop_animating = 0.5,
  smear_to_cmd = false, -- otherwise it breaks inputlist() choices (See https://github.com/neovim/neovim/issues/32068)
  hide_target_hack = true,
  never_draw_over_target = true,
  cursor_color = "none",
  distance_stop_animating = 0.4,
  smear_between_neighbor_lines = true,   -- keep vertical smear if you like it
  min_horizontal_distance_smear = 1,     -- don’t smear for 0→1 cell jitters
  min_vertical_distance_smear   = 1,
  -- smear_insert_mode = false,
}

vim.o.guicursor = ""

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
local lspconfig = vim.lsp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local util = require("lspconfig.util")

-- Helper: wrap a "normal" cmd in docker exec if LSP_DOCKER_CONTAINER is set
local function dockerized_cmd(local_cmd)
  local container = vim.env.LSP_DOCKER_CONTAINER
  if not container or container == "" then
    -- No container: run LSP on host
    return local_cmd
  end

  local cmd = { "docker", "exec", "-i", container }
  vim.list_extend(cmd, local_cmd)
  return cmd
end

lspconfig.config("pyright", {
  -- pyright normally runs as:
  --   { "pyright-langserver", "--stdio" }
  -- we wrap it via dockerized_cmd so it becomes:
  --   { "docker", "exec", "-i", <container>, "pyright-langserver", "--stdio" }

  capabilities = capabilities,
  cmd = dockerized_cmd({ "pyright-langserver", "--stdio" }),

  -- root_dir = util.root_pattern(
  --   "pyrightconfig.json",
  --   "pyproject.toml",
  --   "setup.cfg",
  --   "setup.py",
  --   "requirements.txt",
  --   "Dockerfile",
  --   "Dockerfile.gpu",
  --   ".git"
  -- ),

  -- When running in a container, it's often safer to unset processId
  before_init = function(params, _config)
    params.processId = vim.NIL
  end,

  -- on_attach = function(client, bufnr)
  --   navic.attach(client, bufnr)
  -- end,
})

-- Pyright
-- lspconfig.config("pyright", {
--   capabilities = capabilities 
-- })
lspconfig.enable("pyright")


-- Tinymist
lspconfig.config("tinymist", {
  capabilities = capabilities,
  offset_encoding = 'utf-8',
  settings = {
    formatterMode = 'typstyle',
    exportPdf = 'onSave',
  },
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
})
lspconfig.enable("tinymist")

-- Biome
lspconfig.config("biome", {
  capabilities = capabilities,
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
})
lspconfig.enable("biome")

-- nil_ls
lspconfig.config("nil_ls", { capabilities = capabilities })
lspconfig.enable("nil_ls")

-- Docker LS
lspconfig.config("dockerls", { capabilities = capabilities })
lspconfig.enable("dockerls")

-- Clangd
lspconfig.config("clangd", {
  capabilities = capabilities,
  -- Uncomment and adjust if needed:
  cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
  init_options = { fallbackFlags = { "-std=c++23" } },
})
lspconfig.enable("clangd")

-- TexLab (LaTeX)
lspconfig.config("texlab", {
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
})
lspconfig.enable("texlab")

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
require("nvim-treesitter.configs").setup({
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

	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aF"] = "@function.outer",
				["iF"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ib"] = "@block.inner",
				["ab"] = "@block.outer",
				["if"] = "@call.inner",
				["af"] = "@call.outer",
				["ip"] = "@parameter.inner",
				["ap"] = "@parameter.outer",
				["ia"] = "@assignment.inner",
				["aa"] = "@assignment.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["gsa"] = "@parameter.inner", -- Swap parameters/arguments with next
			},
			swap_previous = {
				["gsA"] = "@parameter.inner", -- Swap parameters/arguments with prev
			},
		},
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
  insert_mappings = true,
  terminal_mappings = true,
})

require('osc52').setup()
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      require('osc52').copy_register('')
    end
  end,
})

require('persistence').setup({
  -- where to save sessions
  dir = vim.fn.stdpath("state") .. "/sessions/",
  -- what to save
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

-- require('illuminate').configure({})

require('trouble').setup({
  -- you can keep defaults, this is just a tiny tweak set
  auto_open = false,    -- don't auto-open on diagnostics
  auto_close = false,   -- don't auto-close when empty
  auto_preview = true,  -- preview location in main window
  focus = false,        -- keep focus in your code window
  use_diagnostic_signs = true, -- use LSP diag signs if available
})

-- Keymaps (Trouble v3-style commands)
-- See plugin README's lazy.nvim example for the same mappings :contentReference[oaicite:0]{index=0}
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Workspace diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: workspace diagnostics",
}))

-- Current buffer diagnostics
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: buffer diagnostics",
}))

-- Document symbols (like a quick outline)
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: document symbols",
}))

-- LSP defs/refs/impls/etc for symbol under cursor
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: LSP defs/refs",
}))

-- Location list
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: location list",
}))

-- Quickfix list
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", vim.tbl_extend("force", opts, {
  desc = "Trouble: quickfix list",
}))


require('fidget').setup({
  -- LSP progress options
  progress = {
    suppress_on_insert = true,      -- don't spam while typing
  },

  -- Notification options (Fidget as a notification UI)
  notification = {
    override_vim_notify = true,     -- make vim.notify use Fidget
    window = {
      normal_hl = "Normal",         -- use regular text color
      winblend = 0,                 -- 0 = opaque, easier to see
      border = "rounded",           -- nice visible border
      zindex = 45,
    },
  },
})


require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>m", "<cmd>AerialToggle!<CR>")


-- Folds
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- 
-- require('ufo').setup({
--     provider_selector = function(bufnr, filetype, buftype)
--         return {'treesitter', 'indent'}
--     end
-- })


-- Tiny diagonistc lines
require("tiny-inline-diagnostic").setup({
  options = {
    multilines = {
      enabled = false,
    },
  },
})


-- Code formatter
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" }, -- Conform will run multiple formatters sequentially
  },
})

-- vim.keymap.set({ "n", "v" }, "gq", function()
--   require("conform").format({
--     lsp_fallback = true,
--     async = false,
--     timeout_ms = 500,
--   })
-- end, { desc = "Format file or range (in visual mode)" })


vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set("n", "=", "gq", { desc = "Format with motion", remap = true })
vim.keymap.set("x", "=", "gq", { desc = "Format selection", remap = true })
