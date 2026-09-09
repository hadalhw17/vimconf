-- LSP servers, diagnostics and completion. Plugin specs live in lua/plugins.lua;
-- this file is required from .vimrc right after lazy.nvim is set up.

local cmp = require("cmp")
local luasnip = require("luasnip")

-- -Completion-------------------------------------------------------------------
vim.o.completeopt = "menu,menuone,noselect"

-- cmp is configured once and gated on this flag, so <F2> can toggle it
-- without re-running the whole setup.
vim.g.nvimCmpEnabled = false

cmp.setup({
	enabled = function()
		return vim.g.nvimCmpEnabled
	end,
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "emoji" },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept selected completion

		-- Use <Tab> and <S-Tab> to select the next/previous item
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
})

-- -LSP servers------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "clangd", "csharp-language-server" }

vim.lsp.config("clangd", {
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--experimental-modules-support",
	},
	init_options = {
		fallbackFlags = { "-std=c++23" },
	},
})

-- nvim-lspconfig ships no defaults under this name, so cmd/filetypes must be
-- spelled out. csharp-ls is the binary from mason's csharp-language-server package.
vim.lsp.config("csharp-language-server", {
	capabilities = capabilities,
	cmd = { "csharp-ls" },
	filetypes = { "cs" },
	root_markers = { ".git" },
})

vim.lsp.enable(servers)
vim.g.nvimLSPEnabled = true

-- -Diagnostics------------------------------------------------------------------
vim.diagnostic.config({
	-- Use keybinding 'gl' to display diagnostics since virtual text is disabled
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

-- -Keymaps and toggles-----------------------------------------------------------
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<A-o>", "<Cmd>LspClangdSwitchSourceHeader<CR>", { desc = "Switch source/header" })

vim.keymap.set("n", "<F2>", function()
	vim.g.nvimCmpEnabled = not vim.g.nvimCmpEnabled
	print(vim.g.nvimCmpEnabled and "Autocomplete enabled" or "Autocomplete disabled")
	vim.fn.UpdateTitleBar()
end, { desc = "Toggle autocompletion" })

-- Remember whether completion was on so re-enabling LSP restores it.
local cmp_enabled_before_lsp_off = vim.g.nvimCmpEnabled

vim.keymap.set("n", "<F3>", function()
	if vim.g.nvimLSPEnabled then
		vim.lsp.enable(servers, false)
		vim.g.nvimLSPEnabled = false
		cmp_enabled_before_lsp_off = vim.g.nvimCmpEnabled
		vim.g.nvimCmpEnabled = false
		print("LSP Disabled")
	else
		vim.lsp.enable(servers)
		vim.g.nvimLSPEnabled = true
		vim.g.nvimCmpEnabled = cmp_enabled_before_lsp_off
		print("LSP Enabled")
	end
	vim.fn.UpdateTitleBar()
end, { desc = "Toggle LSP" })
