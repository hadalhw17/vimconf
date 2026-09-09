-- LSP servers and diagnostics. Plugin specs live in lua/plugins.lua; completion
-- is blink.cmp, configured in its plugin spec and gated on g:nvimCmpEnabled.
-- This file is required from .vimrc right after lazy.nvim is set up.

-- -Completion-------------------------------------------------------------------
-- 'completeopt' only affects native ins-completion (the <Tab>/pumvisible maps
-- in .vimrc); blink.cmp manages its own menu.
vim.o.completeopt = "menu,menuone,noselect"

-- Completion off until toggled on with <F2>
vim.g.nvimCmpEnabled = false

-- -LSP servers------------------------------------------------------------------
local capabilities = require("blink.cmp").get_lsp_capabilities()
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
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "All diagnostics to quickfix" })
vim.keymap.set("n", "<A-o>", "<Cmd>LspClangdSwitchSourceHeader<CR>", { desc = "Switch source/header" })

vim.keymap.set("n", "<F2>", function()
	vim.g.nvimCmpEnabled = not vim.g.nvimCmpEnabled
	print(vim.g.nvimCmpEnabled and "Autocomplete enabled" or "Autocomplete disabled")
	require("config.project").update_titlebar()
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
	require("config.project").update_titlebar()
end, { desc = "Toggle LSP" })
