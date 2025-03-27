-- init.lua - Comprehensive Neovim Configuration from Claude.ai
-- set leader to comma
vim.g.mapleader = ","

-- Install Packer if not already installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

-- Plugins
require('packer').startup(function(use)
    -- Plugin Manager
    use 'wbthomason/packer.nvim'

    use {
        'williamboman/mason.nvim',
        require("mason").setup()
    }

    use {
        'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig'
        },
        require("mason-lspconfig").setup {
            ensure_installed = {
                "pyright",
                "tsserver",
                "omnisharp",
                "sqls",
                "rust_analyzer",
                "gopls",
                "terraformls",
            }
        }
    }

    -- LSP and Completion
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'

    -- Telescope for fuzzy finding
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
        }
    }

    -- Treesitter for advanced syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Terraform syntax highlighting
    use {
        'hashivim/vim-terraform',
        ft = 'terraform',
        config = function()
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_align = 1
        end
    }

    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'windwp/nvim-ts-autotag'

    -- Git integration
    use 'tpope/vim-fugitive'

    -- Theme
    use 'NLKNguyen/papercolor-theme'

    -- Language-specific plugins
    use 'OmniSharp/omnisharp-vim'  -- .NET support
    use 'jose-elias-alvarez/null-ls.nvim'  -- Additional linters/formatters

    -- Additional UI improvements
    use 'kyazdani42/nvim-web-devicons'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 
            'kyazdani42/nvim-web-devicons',
            opt = true 
        }
    }
end)

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = 'a'  -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Theme Setup
vim.o.background = 'light'
vim.cmd('colorscheme PaperColor')

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
    -- Ensure these parsers are installed
    ensure_installed = {
        'lua', 
        'python', 
        'javascript', 
        'typescript', 
        'c_sharp', 
        'sql', 
        'json', 
        'markdown', 
        'bash', 
        'html', 
        'css', 
        'rust', 
        'go',
        'terraform',
        'hcl',
    },

    -- Enable syntax highlighting
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    -- Enable indentation
    indent = {
        enable = true
    },

    -- Text objects
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },

    -- Auto close and rename HTML/XML tags
    autotag = {
        enable = true,
    }
}

-- Telescope Configuration
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
-- Load fzf extension
require('telescope').load_extension('fzf')

-- LSP Configuration
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Capabilities for LSP
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Language Servers Configuration
local servers = {
    pyright = {},  -- Python
    ts_ls = {},  -- JavaScript/TypeScript
    omnisharp = {  -- .NET
        cmd = { "omnisharp", "--languageserver" },
        on_attach = function(client, bufnr)
            -- Custom on_attach logic if needed
        end
    },
    sqls = {  -- PostgreSQL
        on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
        end
    },
    rust_analyzer = {},  -- Rust
    gopls = {},  -- Go,
    terraformls = { -- Terraform
        filetypes = {"terraform", "tf", "hcl"},
    },
}

-- Setup each language server
for server, config in pairs(servers) do
    config.capabilities = capabilities
    lspconfig[server].setup(config)
end

-- Completion Setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
            { name = 'buffer' },
        })
}

-- Telescope Keymaps
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })

-- LSP Keymaps
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Lualine Configuration
require('lualine').setup {
    options = {
        theme = 'papercolor_light',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

-- Diagnostic Configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        severity_sort = true,
    },
    severity_sort = true,
    float = {
        source = "always",
        border = "rounded",
    },
})

-- Sign column configuration
vim.fn.sign_define("DiagnosticSignError", {text = "✘", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "▲", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "ℹ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "➤", texthl = "DiagnosticSignHint"})
