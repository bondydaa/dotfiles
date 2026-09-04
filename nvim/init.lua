-- init.lua - Comprehensive Neovim Configuration from Claude.ai

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        return
    end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    {
        "mason-org/mason.nvim",
        config = function(_, _)
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function(_, _)
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "omnisharp",
                    "gopls",
                    "terraformls",
                    "typos_lsp",
                    "snyk_ls",
                    "ts_ls",
                    "rust_analyzer",
                    "sqls",
                },
            })
        end,
    },

    -- Cleanup whitespace
    "ntpeters/vim-better-whitespace",

    -- Yaml
    {
        "cuducos/yaml.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "folke/snacks.nvim", -- optional
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua", -- optional
        },
    },

    -- LSP and Completion
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function(_, _)
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            local servers = {
                pyright = {},
                ts_ls = {},
                omnisharp = {
                    cmd = { "omnisharp", "--languageserver" },
                    on_attach = function(client, _)
                    end,
                },
                sqls = {
                    on_attach = function(client, _)
                        client.server_capabilities.semanticTokensProvider = nil
                    end,
                },
                rust_analyzer = {},
                gopls = {},
                terraformls = {
                    filetypes = { "terraform", "terraform-vars", "hcl" },
                },
            }

            for server, config in pairs(servers) do
                config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
                vim.lsp.config[server] = config
                vim.lsp.enable(server)
            end
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function(_, _)
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            if vim.g.copilot_enabled == nil then
                vim.g.copilot_enabled = 1
            end

            cmp.setup({
                enabled = function()
                    return vim.g.copilot_enabled ~= 1
                end,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        config = function(_, _)
            require("telescope").setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
            pcall(require("telescope").load_extension, "fzf")
        end,
    },

    -- Treesitter for advanced syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
        config = function(_, _)
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "javascript",
                    "typescript",
                    "c_sharp",
                    "sql",
                    "json",
                    "markdown",
                    "bash",
                    "html",
                    "css",
                    "rust",
                    "go",
                    "terraform",
                    "hcl",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

    -- Terraform syntax highlighting
    {
        "hashivim/vim-terraform",
        ft = { "terraform", "terraform-vars", "hcl" },
        config = function(_, _)
            vim.g.terraform_fmt_on_save = 1
            vim.g.terraform_align = 1
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function(_, _)
            require("nvim-treesitter.configs").setup({
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
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        config = function(_, _)
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Git integration
    "tpope/vim-fugitive",

    -- Theme
    {
        "NLKNguyen/papercolor-theme",
        lazy = false,
        priority = 1000,
        config = function(_, _)
            vim.o.background = "light"
            vim.cmd("colorscheme PaperColor")
        end,
    },

    -- null-ls was unconfigured dead weight and is archived; intentionally omitted.

    -- Additional UI improvements
    "nvim-tree/nvim-web-devicons",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function(_, _)
            require("lualine").setup({
                options = {
                    theme = "papercolor_light",
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 3 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    {
        "github/copilot.vim",
        config = function(_, _)
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true

            vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                noremap = true,
                silent = true,
                replace_keycodes = false,
                desc = "Copilot accept",
            })
            vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)", { silent = true, desc = "Copilot accept word" })
            vim.keymap.set("i", "<C-H>", "<Plug>(copilot-previous)", { silent = true, desc = "Copilot previous" })
            vim.keymap.set("i", "<C-K>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot next" })
        end,
    },

    -- Markdown Preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
    },
})

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
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.api.nvim_create_user_command("CopilotEnable", function()
    vim.g.copilot_enabled = 1
    print("Copilot enabled, nvim-cmp disabled")
end, {})

vim.api.nvim_create_user_command("CopilotDisable", function()
    vim.g.copilot_enabled = 0
    print("Copilot disabled, nvim-cmp enabled")
end, {})

vim.api.nvim_create_user_command("CopilotToggle", function()
    if vim.g.copilot_enabled == 1 then
        vim.g.copilot_enabled = 0
        print("Copilot disabled, nvim-cmp enabled")
    else
        vim.g.copilot_enabled = 1
        print("Copilot enabled, nvim-cmp disabled")
    end
end, {})

-- Copilot Keymaps
vim.keymap.set("n", "<leader>ce", "<cmd>CopilotEnable<CR>", { noremap = true, silent = true, desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>cd", "<cmd>CopilotDisable<CR>", { noremap = true, silent = true, desc = "Disable Copilot" })
vim.keymap.set("n", "<leader>ct", "<cmd>CopilotToggle<CR>", { noremap = true, silent = true, desc = "Toggle Copilot" })

-- Telescope Keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true, desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true, desc = "Help tags" })

-- Yaml Helpers
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function(args)
        vim.keymap.set("n", "<leader>yt", "<cmd>YAMLTelescope<CR>", { buffer = args.buf, remap = true, desc = "YAML Telescope" })
        vim.keymap.set("n", "<leader>yl", "<cmd>!yamllint %<CR>", { buffer = args.buf, noremap = true, silent = true, desc = "Yamllint current file" })
    end,
})

-- LSP Keymaps
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "LSP declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP hover" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "LSP implementation" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "LSP signature help" })
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { noremap = true, silent = true, desc = "LSP add workspace" })
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { noremap = true, silent = true, desc = "LSP remove workspace" })
vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { noremap = true, silent = true, desc = "LSP list workspaces" })
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { noremap = true, silent = true, desc = "LSP type definition" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP code action" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "LSP references" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Line diagnostics" })
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { noremap = true, silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { noremap = true, silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostics loclist" })

-- Personal keymaps
vim.keymap.set("n", "GT", ":tabprev<CR>", { noremap = true, desc = "Previous tab" })

-- Diagnostic Configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        severity_sort = true,
    },
    severity_sort = true,
    float = {
        source = true,
        border = "rounded",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "ℹ",
            [vim.diagnostic.severity.HINT] = "➤",
        },
    },
})
