-- Register templ filetype
vim.filetype.add({ extension = { templ = "templ" } })

-- LSP keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
})

-- Mason setup (installs language servers)
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'ts_ls', 'rust_analyzer', 'gopls', 'pyright', 'lua_ls', 'templ', 'html', 'tailwindcss' },
})

-- Add cmp capabilities to all LSP servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Native Neovim 0.11+ LSP config
vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config('html', {
    filetypes = { 'html', 'templ' },
})

vim.lsp.config('tailwindcss', {
    filetypes = { 'html', 'css', 'templ', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    init_options = {
        userLanguages = {
            templ = 'html',
        },
    },
})

vim.lsp.enable({ 'ts_ls', 'rust_analyzer', 'gopls', 'pyright', 'lua_ls', 'templ', 'html', 'tailwindcss' })

-- Format templ files on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.templ',
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Completion setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 2 },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback() -- falls through to Copilot or normal Tab
            end
        end, { 'i', 's' }),
    }),
})
