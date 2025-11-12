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
	'mason-org/mason.nvim',
	config = function()
	    require("mason").setup()
	end
    }

    use {
        'mason-org/mason-lspconfig.nvim',
        after = "mason.nvim",
	requires = {
	    'mason-org/mason.nvim',
	    'neovim/nvim-lspconfig'
	},
	config = function()
	    require("mason-lspconfig").setup {
	        ensure_installed = {
	            "pyright",
	            "omnisharp",
		    "gopls",
		    "terraformls",
                    "typos_lsp",
                    "snyk_ls",
	        }
	    }
        end
    }

    -- Cleanup whitepace
    use 'ntpeters/vim-better-whitespace'

    -- Yaml
    use {
        "cuducos/yaml.nvim",
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "folke/snacks.nvim", -- optional
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua", --optional
        },
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
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'make',
            }
        },
        config = function()
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
            -- Attempt to load the fzf extension
            pcall(require('telescope').load_extension, 'fzf')
        end
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

    use {
    'github/copilot.vim',
    config = function()
        -- Configure copilot settings
        vim.g.copilot_no_tab_map = true  -- Disable default tab mapping
        vim.g.copilot_assume_mapped = true

        -- Custom keymaps for copilot
        vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            noremap = true,
            silent = true,
            replace_keycodes = false
        })
        vim.api.nvim_set_keymap('i', '<C-L>', '<Plug>(copilot-accept-word)', { silent = true })
        vim.api.nvim_set_keymap('i', '<C-H>', '<Plug>(copilot-previous)', { silent = true })
        vim.api.nvim_set_keymap('i', '<C-K>', '<Plug>(copilot-next)', { silent = true })
    end
}
end)

-- Better whitespace settings
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1


-- Basic Settings
vim.opt.number = true
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
vim.opt.shortmess = "" -- Prevent command line status/messages from disappearing

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
        'yaml',
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

-- LSP Configuration
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
    vim.lsp.config[server] = config
end

-- Completion Setup
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Function to check if Copilot is enabled
local function is_copilot_enabled()
    return vim.g.copilot_enabled == 1
end

-- Custom enabled function for cmp
local function cmp_enabled()
    return not is_copilot_enabled()
end

cmp.setup {
    enabled = cmp_enabled,
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

-- Copilot and nvim-cmp integration
local function setup_copilot_cmp_integration()
    -- Initialize copilot as enabled by default
    if vim.g.copilot_enabled == nil then
        vim.g.copilot_enabled = 1
    end

    -- Function to refresh cmp state
    local function refresh_cmp()
        -- Force cmp to re-evaluate its enabled state
        cmp.setup({ enabled = cmp_enabled })

        -- Also disable for current buffer specifically
        if is_copilot_enabled() then
            cmp.setup.buffer({ enabled = false })
        else
            cmp.setup.buffer({ enabled = true })
        end
    end

    -- Create user commands for manual control
    vim.api.nvim_create_user_command('CopilotEnable', function()
        vim.g.copilot_enabled = 1
        refresh_cmp()
        print("Copilot enabled, nvim-cmp disabled")
    end, {})

    vim.api.nvim_create_user_command('CopilotDisable', function()
        vim.g.copilot_enabled = 0
        refresh_cmp()
        print("Copilot disabled, nvim-cmp enabled")
    end, {})

    vim.api.nvim_create_user_command('CopilotToggle', function()
        if is_copilot_enabled() then
            vim.g.copilot_enabled = 0
            print("Copilot disabled, nvim-cmp enabled")
        else
            vim.g.copilot_enabled = 1
            print("Copilot enabled, nvim-cmp disabled")
        end
        refresh_cmp()
    end, {})

    -- Create autocommands to refresh cmp state
    vim.api.nvim_create_augroup('CopilotCmpIntegration', { clear = true })

    vim.api.nvim_create_autocmd({'InsertEnter', 'BufEnter'}, {
        group = 'CopilotCmpIntegration',
        callback = refresh_cmp,
    })

    -- Initial setup
    refresh_cmp()
end

-- Call the setup function
setup_copilot_cmp_integration()

-- Copilot Keymaps
vim.api.nvim_set_keymap('n', '<leader>ce', ':CopilotEnable<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cd', ':CopilotDisable<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ct', ':CopilotToggle<CR>', { noremap = true, silent = true })

-- Telescope Keymaps
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })

-- Yaml Helpers
vim.api.nvim_buf_set_keymap(0, "n", "<leader>yt", ":YAMLTelescope<CR>", { noremap = false })
vim.api.nvim_buf_set_keymap(0, "n", "<leader>yl", ":!yamllint %<CR>", { noremap = true, silent = true })

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

-- Personal keymaps
vim.api.nvim_set_keymap('n', 'GT', ':tabprev<CR>', { noremap = true})

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
        lualine_c = {{'filename', path = 3}},
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
