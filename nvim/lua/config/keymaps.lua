-- General keymaps. LSP/completion keymaps live in config/lsp.lua, build keys
-- in config/build.lua, plugin keymaps in their lazy.nvim specs.

local map = vim.keymap.set

-- Move between windows without <C-w>
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-L>", "<C-W><C-L>")
map("n", "<C-H>", "<C-W><C-H>")

-- Use Q for formatting the current paragraph (or selection)
map("v", "Q", "gq", { remap = true })
map("n", "Q", "gqap", { remap = true })

-- Quickly edit/reload the config
map("n", "<leader>ev", "<Cmd>vsp $MYVIMRC<CR>", { silent = true, desc = "Edit init.lua" })
map("n", "<leader>sv", function()
	require("config.autocmds").reload_config()
end, { silent = true, desc = "Reload config" })

-- Quickfix
map("n", "<leader>n", "<Cmd>cnext<CR>", { desc = "Next quickfix entry" })

-- Toggle tabs and EOL
map("n", "<leader>l", "<Cmd>set list!<CR>", { desc = "Toggle whitespace display" })

-- cd to the current file's directory
map("n", "<leader>cd", function()
	vim.cmd("cd %:p:h")
end, { desc = "cd to file's directory" })

-- Save with C-s
map("n", "<C-s>", "<Cmd>update<CR>")
map("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Text selection with shifted arrows
map("n", "<S-Up>", "v<Up>", { remap = true })
map("n", "<S-Down>", "v<Down>", { remap = true })
map("n", "<S-Left>", "v<Left>", { remap = true })
map("n", "<S-Right>", "v<Right>", { remap = true })
map("v", "<S-Up>", "<Up>", { remap = true })
map("v", "<S-Down>", "<Down>", { remap = true })
map("v", "<S-Left>", "<Left>", { remap = true })
map("v", "<S-Right>", "<Right>", { remap = true })

-- Line dragging with Alt+arrows / Alt+j/k
for _, key in ipairs({ "<A-down>", "<A-j>" }) do
	map("n", key, ":m .+1<CR>==")
	map("i", key, "<Esc>:m .+1<CR>==gi")
	map("v", key, ":m '>+1<CR>gv=gv")
end
for _, key in ipairs({ "<A-up>", "<A-k>" }) do
	map("n", key, ":m .-2<CR>==")
	map("i", key, "<Esc>:m .-2<CR>==gi")
	map("v", key, ":m '<-2<CR>gv=gv")
end

-- Buffer access (intentionally no <CR>: leaves the prompt open; note this
-- also shadows <C-i> jumplist-forward in terminals)
map("n", "<Tab>", ":buffer *")

-- Font size adjust (GUI)
local function bump_font(delta)
	vim.o.guifont = vim.o.guifont:gsub(":h(%d+)", function(size)
		return ":h" .. (tonumber(size) + delta)
	end)
end
map("n", "<C-Up>", function() bump_font(1) end, { desc = "Increase font size" })
map("n", "<C-Down>", function() bump_font(-1) end, { desc = "Decrease font size" })

-- Autocomplete with Tab in the native ins-completion menu only
-- (blink.cmp handles its own Tab; see its spec in plugins.lua)
map("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
map("i", "<S-Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })
