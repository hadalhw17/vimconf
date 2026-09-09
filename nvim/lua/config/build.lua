-- Building: async :Make via vim-dispatch; results land in quickfix when the
-- job finishes (the QuickFixCmdPost autocmd below opens the window).

vim.cmd.compiler("msvc")
vim.o.makeprg = "make"

-- Extra MSVC-style error formats on top of the msvc compiler's own.
-- Kept as :set lines because errorformat escaping differs between the
-- :set syntax and the raw option value.
vim.cmd([[
  set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
  set errorformat+=,%f:\ error\ %s:%m
  set errorformat+=,%f:\ fatal\ error\ %s:%m
]])

-- Filter huge quickfix lists with :Cfilter /pattern/
vim.cmd.packadd("cfilter")

vim.api.nvim_create_user_command("Makeprg", function(a)
	vim.o.makeprg = a.args
end, {
	nargs = 1,
	complete = function()
		return { "make", "nmake", "cmake" }
	end,
	desc = "Switch the build program",
})

-- Collect TODOs into the quickfix list
vim.api.nvim_create_user_command("Todo", function()
	vim.cmd([[silent cgetexpr system('todo.bat') | wincmd L]])
end, { desc = "Extract TODOs into quickfix" })

local function toggle_quickfix()
	if vim.bo.buftype == "quickfix" then
		vim.cmd.cclose()
	else
		vim.cmd.copen()
	end
end

vim.keymap.set("n", "<F9>", "<Cmd>Make<CR>", { silent = true, desc = "Build (async)" })
vim.keymap.set("n", "<F10>", "<Cmd>Make clean all<CR>", { silent = true, desc = "Clean rebuild (async)" })
vim.keymap.set("n", "<F4>", toggle_quickfix, { silent = true, desc = "Toggle quickfix window" })

local group = vim.api.nvim_create_augroup("buildwindows", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	command = "wincmd =",
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = group,
	callback = toggle_quickfix,
})
