-- Autocmds, filetype mappings and small commands that don't belong to a
-- specific feature module.

local M = {}

-- -Config reload------------------------------------------------------------
-- Lua modules cache in package.loaded, so a plain :source does nothing;
-- bust the cache for the safe subset. lazy.nvim and lsp are left alone
-- (re-running lazy.setup() is unsupported).
local reloadable = {
	"config.options",
	"config.ui",
	"config.keymaps",
	"config.build",
	"config.project",
	"config.autocmds",
}

function M.reload_config()
	for _, mod in ipairs(reloadable) do
		package.loaded[mod] = nil
	end
	for _, mod in ipairs(reloadable) do
		require(mod)
	end
	vim.notify("Config reloaded", vim.log.levels.INFO)
end

-- Auto reload on save. The config dir is a symlink into the repo, so match
-- both the symlinked and the resolved paths; backslash is an escape char in
-- autocmd patterns, so everything is normalized to forward slashes.
local patterns, seen = {}, {}
local cfg = vim.fs.normalize(vim.fn.stdpath("config"))
local real = vim.fs.normalize((vim.uv or vim.loop).fs_realpath(vim.fn.stdpath("config")) or cfg)
for _, root in ipairs({ cfg, real }) do
	for _, pat in ipairs({ root .. "/init.lua", root .. "/lua/config/*.lua" }) do
		if not seen[pat] then
			seen[pat] = true
			table.insert(patterns, pat)
		end
	end
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("ConfigReloaded", { clear = true }),
	pattern = patterns,
	callback = function()
		M.reload_config()
	end,
})

-- -Comment continuation-------------------------------------------------------
-- 'formatoptions' is reset by ftplugins, so removing c/r/o must happen per
-- buffer to actually stop comment auto-continuation on o/O and Enter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NoCommentContinue", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- -Filetypes-------------------------------------------------------------------
vim.filetype.add({
	extension = {
		cfx = "fx",
		cfi = "fx",
		rfx = "fx",
		rfi = "fx",
		ixx = "cpp",
		cppm = "cpp",
	},
})

-- Split minified JSON into readable lines; nvim is line-oriented, so many
-- short lines render fast while one huge line does not
vim.api.nvim_create_user_command("JsonPretty", function()
	local tool = vim.fn.executable("jq") == 1 and { "jq", "." } or { "python", "-m", "json.tool" }
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local res = vim.system(tool, { stdin = text, text = true }):wait()
	if res.code ~= 0 then
		vim.notify("JsonPretty failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
		return
	end
	local lines = vim.split(res.stdout, "\n")
	if lines[#lines] == "" then
		table.remove(lines)
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, {})

-- -Skeleton files----------------------------------------------------------------
local templates = vim.fs.joinpath(vim.fn.stdpath("config"), "templates")

local function apply_skeleton(ext)
	if ext == "h" then
		local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"):gsub("%W", "_")
		vim.cmd("silent! %s/%header_name%/" .. bufname:upper() .. "/g")
		local ns = vim.g["project#defaultNamespace"]
		if ns == nil or ns == "" then
			ns = "my_name_space"
		end
		vim.cmd("silent! %s/%namespace%/" .. ns .. "/g")
		if vim.fn.search("%cursor%", "c") > 0 then
			vim.cmd("normal! diW")
		end
		vim.cmd("silent! %s/%%/" .. (vim.g["project#defaultNamespace"] or "") .. "/g")
	end
	-- Mark modified so a template-filled buffer never looks like a saved file
	vim.bo.modified = true
end

local function read_template(tpl, ext)
	if vim.fn.filereadable(tpl) == 0 then
		return
	end
	-- Without a UI (headless/scripted nvim) confirm() would block forever
	if #vim.api.nvim_list_uis() == 0 then
		return
	end
	local choice = vim.fn.confirm(
		"Fill new file from template " .. vim.fn.fnamemodify(tpl, ":t") .. "?",
		"&Yes\n&No",
		1
	)
	if choice ~= 1 then
		return
	end
	vim.cmd("silent keepalt 0read " .. vim.fn.fnameescape(tpl))
	apply_skeleton(ext)
end

local skeletons = vim.api.nvim_create_augroup("skeletons", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
	group = skeletons,
	pattern = "*.*",
	callback = function(ev)
		local ext = vim.fn.fnamemodify(ev.file, ":e")
		read_template(templates .. "/skeleton." .. ext, ext)
	end,
})
vim.api.nvim_create_autocmd("BufNewFile", {
	group = skeletons,
	pattern = { "CMakeLists.txt", "project.vim" },
	callback = function(ev)
		local name = vim.fn.fnamemodify(ev.file, ":t")
		read_template(templates .. "/" .. name, vim.fn.fnamemodify(ev.file, ":e"))
	end,
})

return M
