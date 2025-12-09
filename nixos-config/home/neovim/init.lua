-- Neovim init.lua

-- Use the Lua loader for faster startup
vim.loader.enable()

------------------------------------------------------------
-- Global Settings & Options ✨
------------------------------------------------------------
local o = vim.o
local g = vim.g

-- Leader key
g.mapleader = " "
g.maplocalleader = " "

-- Core Editor Settings
o.encoding = "UTF-8"
o.number = true             -- Show line numbers
o.relativenumber = false    -- Use relative numbers
o.cursorline = true         -- Highlight current line
o.termguicolors = true      -- Enable true colors
o.mouse = "a"               -- Enable mouse support in all modes
o.updatetime = 1000          -- Faster update time for CursorHold events (for LSP)

-- Indentation & Tabs
o.tabstop = 2               -- Spaces per tab in the file
o.softtabstop = 2           -- Spaces in tab when editing
o.shiftwidth = 2            -- Spaces for (auto)indentation
o.expandtab = true          -- Use spaces instead of tabs
o.autoindent = true         -- Copy indent from current line
o.indentexpr = "nvim_treesitter#indent()" -- Tree-sitter indentation

-- Formatting & Display
o.textwidth = 120           -- Max width before wrapping
o.colorcolumn = "120"       -- Highlight column 120
o.fixendofline = false      -- Disable automatic newline at end of file
o.clipboard = "unnamedplus" -- Use system clipboard
o.omnifunc = "syntaxcomplete#Complete" -- Omnifunc for basic completion

-- Folding (using Tree-sitter)
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldcolumn = "1"
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Remove default guicursor options (smear_cursor handles this)
o.guicursor = ""

-- Legacy commands (kept for syntax/filetype setup)
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

------------------------------------------------------------
-- Global Variables for Plugins ⚙️
------------------------------------------------------------

-- Disable netrw for nvim-tree/snacks
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- vim-closetag settings
g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.jsx,*.js"
g.closetag_xhtml_filenames = "*.xhtml,*.jsx,*.js"
g.closetag_filetypes = "html,xhtml,phtml,js,jsx,typescriptreact,javascriptreact"
g.closetag_xhtml_filetypes = "xhtml,jsx,js,typescriptreact,javascriptreact"
g.closetag_emptyTags_caseSensitive = 1
g.closetag_regions = {
    ["typescript.tsx"] = "jsxRegion,tsxRegion",
    ["javascript.jsx"] = "jsxRegion",
    ["typescriptreact"] = "jsxRegion,tsxRegion",
    ["javascriptreact"] = "jsxRegion",
}
g.closetag_shortcut = ">"
g.closetag_close_shortcut = "<leader>>"

-- LaTeX viewer setting
g.latex_view_method = "zathura"

------------------------------------------------------------
-- Key Mappings ⌨️
------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Tab Page Navigation (Ctrl+L/H)
map("n", "<C-l>", "gt", opts)
map("n", "<C-h>", "gT", opts)

-- Clear search highlighting
map("n", "<C-p>", ":nohlsearch<CR>:echo<CR>", opts)

-- Terminal mode remappings for proper escape and tab navigation
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "<C-l>", "<Esc>gt", opts)
map("t", "<C-h>", "<Esc>gT", opts)

-- LSP diagnostics & actions
map("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "LSP: Show diagnostics float" })
map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "LSP: Code Action" })
map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "LSP: Rename" })

-- Typst/LaTeX preview
map("n", "<leader>tc", ":TypstPreview<CR>", { desc = "Typst: Start Preview" })
map("n", "<leader>ts", ":TexlabForward<CR>", { desc = "TexLab: Forward Search" })

-- Persistence keymaps (sessions)
map("n", "<leader>pl", function() require("persistence").load() end, { desc = "Load last session for current directory" })
map("n", "<leader>ps", function() require("persistence").select() end, { desc = "Select session" })
map("n", "<leader>pd", function() require("persistence").stop() end, { desc = "Forget this session" })

-- --- Snacks Keymaps (Consolidated) ---
local Snacks = require("snacks")
map("n", "<C-n>", function() require("snacks.explorer").open() end, { desc = "Snacks Explorer (Toggle)" })
map("n", "<leader>e", function() require("snacks.explorer").open() end, { desc = "Snacks Explorer (Toggle)" })
map("n", "<leader><space>", Snacks.picker.smart, { desc = "Smart Find Files" })
map("n", "<leader>/", Snacks.picker.grep, { desc = "Grep" })
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>ff", Snacks.picker.files, { desc = "Find Files" })
map("n", "<leader>fr", Snacks.picker.recent, { desc = "Recent Files" })
map("n", "<leader>sg", Snacks.picker.grep, { desc = "Grep" })
map("n", "<leader>sc", Snacks.picker.grep_word, { desc = "Search word under cursor" })
map("n", "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
map("n", "<leader>gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
map("n", "<leader>gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
map("n", "<leader>gr", Snacks.picker.lsp_references, { desc = "References" })
map("n", "<leader>gI", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })

-- Toggle Aerial (outline)
map("n", "<leader>m", "<cmd>AerialToggle!<CR>", { desc = "Toggle File Outline" })

-- Trouble Keymaps
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: workspace diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: buffer diagnostics" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble: document symbols" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble: LSP defs/refs" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble: location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble: quickfix list" })

-- Format mappings (using conform)
o.formatexpr = "v:lua.require'conform'.formatexpr()"
map("n", "=", "gq", { desc = "Format with motion", remap = true })
map("x", "=", "gq", { desc = "Format selection", remap = true })

------------------------------------------------------------
-- Plugin Setup & Configurations 📦
------------------------------------------------------------

-- Catppuccin (Color Scheme Integration)
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

-- nvim-web-devicons
require('nvim-web-devicons').setup { default = true }

-- nvim-tree (File Explorer)
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

-- navic (breadcrumbs: displayed in lualine)
local navic = require('nvim-navic')
navic.setup {
  lsp = {
    auto_attach = true,
  },
  highlight = true,
}

-- lualine (Status Line)
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

-- snacks (QoL improvements)
require('snacks').setup{
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

-- smear-cursor (Enhanced cursor highlighting)
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

-- bufferline (Tabline)
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

-- alpha-nvim (Start Screen)
local startify = require('alpha.themes.startify')
startify.file_icons.provider = "devicons"
require('alpha').setup(startify.config)

-- nvim-cmp (Autocompletion)
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

-- Typst Preview
require('typst-preview').setup {
  -- open_cmd = 'google-chrome-stable --app=%s --disable-extensions --disable-background-networking --disable-background-timer-throttling',
  -- open_cmd = 'firefox %s -P typst-preview --class typst-preview',
  open_cmd = 'firefox %s -P typst-preview --class typst-preview &',
}

-- Treesitter
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

-- virt-column (Visual Column Marker)
require("virt-column").setup()

-- todo-comments (Highlight TODOs)
require("todo-comments").setup()

-- toggleterm (Terminal Manager)
require("toggleterm").setup({
  open_mapping = [[<c-t>]],
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
})

-- osc52 (Clipboard through ssh/tmux)
require('osc52').setup()
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      require('osc52').copy_register('')
    end
  end,
})

-- persistence (Sessions)
require('persistence').setup({
  -- where to save sessions
  dir = vim.fn.stdpath("state") .. "/sessions/",
  -- what to save
  options = { "buffers", "curdir", "tabpages", "winsize" },
})

-- trouble (Better diagnostics interface)
require('trouble').setup({
  -- you can keep defaults, this is just a tiny tweak set
  auto_open = false,    -- don't auto-open on diagnostics
  auto_close = false,   -- don't auto-close when empty
  auto_preview = true,  -- preview location in main window
  focus = false,        -- keep focus in your code window
  use_diagnostic_signs = true, -- use LSP diag signs if available
})

-- fidget (Lsp progress and notifications)
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


-- aerial (Code scopes menu)
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

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


------------------------------------------------------------
-- LSP Configuration ⚙️
------------------------------------------------------------
local lspconfig = vim.lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")

-- --- LSP Helper Functions and Defaults ---

-- 1. Helper: wrap a "normal" cmd in docker exec if LSP_DOCKER_CONTAINER is set
local function dockerized_cmd(local_cmd)
    local container = vim.env.LSP_DOCKER_CONTAINER
    if not container or container == "" then
        return local_cmd -- No container: run LSP on host
    end

    local cmd = { "docker", "exec", "-i", container }
    vim.list_extend(cmd, local_cmd)
    return cmd
end

-- 2. Standard On Attach Function
local function on_attach(client, bufnr)
	require("nvim-navic").attach(client, bufnr)
end

-- --- Server Configurations ---

-- Pyright (Python)
lspconfig.config("pyright", {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = dockerized_cmd({ "pyright-langserver", "--stdio" }),
    before_init = function(params, _config)
        -- Unset processId when running in a container
        params.processId = vim.NIL
    end,
})
lspconfig.enable("pyright")

-- Tinymist (Typst)
lspconfig.config("tinymist", {
    capabilities = capabilities,
    on_attach = on_attach,
    offset_encoding = "utf-8",
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onSave",
    },
    root_dir = util.find_git_ancestor, -- Use standard root detection
})
lspconfig.enable("tinymist")

-- Biome (JS/TS formatting/linting)
lspconfig.config("biome", {
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = util.find_git_ancestor, -- Use standard root detection
})
lspconfig.enable("biome")

-- nil_ls (Nix)
lspconfig.config("nil_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
})
lspconfig.enable("nil_ls")

-- Docker LS
lspconfig.config("dockerls", {
    capabilities = capabilities,
    on_attach = on_attach,
})
lspconfig.enable("dockerls")

-- Clangd (C/C++)
lspconfig.config("clangd", {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
    init_options = { fallbackFlags = { "-std=c++23" } },
})
lspconfig.enable("clangd")

-- TexLab (LaTeX)
lspconfig.config("texlab", {
    capabilities = capabilities,
    on_attach = on_attach,
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
            chktex = { onOpenAndSave = true, onEdit = false },
        },
    },
})
lspconfig.enable("texlab")

------------------------------------------------------------
-- LSP Auto-Hover Logic 💡
------------------------------------------------------------

-- Check if nvim is focused
local nvim_focused = true
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		nvim_focused = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	callback = function()
		nvim_focused = false
	end,
})

-- Returns true if there's already an LSP float/hover window opened
local function is_hover_open()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local config = vim.api.nvim_win_get_config(win)
        -- Check if it's a floating window not managed by a specific relative target
        if config.relative and config.relative ~= "" and config.relative ~= "editor" then
            return true
        end
    end
    return false
end

-- Show hover documentation on CursorHold if supported and no other hover is open
function show_hover_if_supported()
    if not nvim_focused or is_hover_open() then
        return
    end

    local clients = vim.lsp.get_clients()
    for _, client in pairs(clients) do
        if client.supports_method("textDocument/hover") then
            vim.lsp.buf.hover()
            return
        end
    end
end

-- Autocommand that triggers hover on CursorHold (after updatetime)
vim.api.nvim_create_autocmd("CursorHold", { callback = show_hover_if_supported })
