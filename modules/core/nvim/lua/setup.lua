local opt = vim.opt
local api = vim.api
local keymap = vim.keymap

-- Visuals
vim.cmd.colorscheme("habamax")
opt.number = true
opt.relativenumber = true

-- Code style
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- Autocomplete
opt.completeopt = { 'menu', 'menuone', 'noselect' }
local lsp = require("lspconfig")
local lsp_defaults = lsp.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)

-- Keybinds
local telescope = require("telescope.builtin")
keymap.set("n", "<leader>ff", telescope.find_files, {})    -- Find files
keymap.set("n", "<leader>f/", telescope.live_grep, {})     -- Find in files
keymap.set("n", "<leader>,", telescope.buffers, {})        -- Find buffer
keymap.set("n", "<leader>fh", telescope.help_tags, {})     -- Find help
local tree = require("nvim-tree.api")
keymap.set("n", "<leader>ft", tree.tree.toggle, {})        -- File explorer
keymap.set("n", "<leader>ch", vim.lsp.buf.hover, {})       -- Hover
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {})      -- Rename
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {}) -- Code actions
keymap.set("n", "<leader>cx", telescope.diagnostics, {})   -- Diagnostics
local cmp = require("cmp")
keymap.set("i", "<C-Space>", cmp.complete, {})             -- Autocomplete
keymap.set("n", "<bar>", vim.cmd.vsplit, {})
keymap.set("n", "<bslash>", vim.cmd.split, {})

-- LSP
-- Rust analyzer
lsp.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {},
    },
}
-- Lua
lsp.lua_ls.setup {}
-- Scala
local metals = require("metals").bare_config()
metals.capabilities = capabilities
api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
        require("metals").initialize_or_attach(metals)
    end,
})
-- Format-on-save
api.nvim_create_autocmd("BufWritePre", {
    callback = function() vim.lsp.buf.format() end,
})

-- Autocomplete
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "buffer",   keyword_length = 3 },
        { name = "luasnip",  keyword_length = 2 },
    },
    window = {
        documentation = cmp.config.window.bordered()
    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<C-f>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
}

-- Blink
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.blink",
    command = "set filetype=blink",
})

-- Other
opt.clipboard = "unnamedplus" -- Always use system clipboard