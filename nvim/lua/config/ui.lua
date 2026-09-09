-- Visual settings. Plugin specs live in lua/plugins.lua; this module runs
-- after config.lazy, so the colorscheme plugin is available here.

vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("kanso-ink")

-- Highlight only the number of the cursor line, not the whole line
vim.o.cursorlineopt = "number"

-- Rounded borders for every floating window (hover, signature help, diagnostics)
vim.o.winborder = "rounded"

-- Subtle guide one column past 'textwidth'
vim.o.colorcolumn = "+1"

vim.opt.fillchars = {
	vert = "│",
	diff = "╱",
	eob = " ", -- hide the ~ markers past the end of the buffer
}

-- Nerd-font gutter signs; merges into the diagnostic config from config/lsp.lua
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})
