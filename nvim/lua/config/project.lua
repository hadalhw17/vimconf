-- Session-based :Project loader and the title bar. The JSON-based :Proj
-- system lives in Project.vim, sourced from init.lua before this module runs.

local M = {}

vim.g["project#name"] = ""
vim.g["vimprj#currentProjectName"] = ""

local ft_icons = { qf = "🔧", help = "🎓", netrw = "📁", [""] = "❓" }

function M.update_titlebar()
	local status = ""
	if vim.g.nvimCmpEnabled then
		status = " [ 🧩 Autocompletion enabled ]"
	end
	if vim.g.nvimLSPEnabled then
		status = status .. " [ 🧩 LSP enabled ]"
	end

	local icon = ft_icons[vim.bo.filetype] or "🗒️"
	local name = vim.fn.expand("%:t")
	if name == "" then
		name = vim.bo.filetype
	end

	vim.o.titlestring = (vim.g["vimprj#currentProjectName"] or "")
		.. " :: " .. icon .. " " .. name .. status
end

-- Source project.vim from the nearest ancestor directory that has one and
-- take the project name from it; otherwise show "No Project".
function M.check_project()
	local cwd = vim.fn.getcwd()
	local path = cwd
	local found
	while true do
		if vim.fn.filereadable(path .. "/project.vim") == 1 then
			found = path
			break
		end
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			break
		end
		path = parent
	end

	if found then
		vim.cmd.source(vim.fn.fnameescape(found .. "/project.vim"))
		vim.g["vimprj#path"] = found
		vim.g["vimprj#currentProjectName"] = vim.g["project#name"]
	else
		vim.g["vimprj#path"] = cwd
		vim.g["vimprj#currentProjectName"] = "📁No Project"
	end
	M.update_titlebar()
end

vim.api.nvim_create_user_command("Project", function(a)
	vim.cmd.cd(a.args)
	pcall(vim.cmd.source, a.args .. "/Session.vim")
	M.check_project()
end, { nargs = 1, complete = "dir", desc = "cd to a project and load its Session.vim" })

-- Same augroup name as in Project.vim on purpose: clearing it replaces that
-- file's simpler BufEnter title handler with ours.
local group = vim.api.nvim_create_augroup("dirchange", { clear = true })
vim.api.nvim_create_autocmd("DirChanged", { group = group, callback = M.check_project })
vim.api.nvim_create_autocmd("BufEnter", { group = group, callback = M.update_titlebar })

M.check_project()

return M
