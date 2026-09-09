-- Aleksandr Slobodov Neovim config
-- https://github.com/hadalhw17/vimconf

-- Legacy JSON-based :Proj project system, kept alongside :Project from
-- config/project.lua (which also replaces the augroup this file creates)
vim.cmd.source(vim.fs.joinpath(vim.fn.stdpath("config"), "Project.vim"))

require("config.options")
require("config.lazy")
require("config.lsp")
require("config.ui")
require("config.keymaps")
require("config.build")
require("config.project")
require("config.autocmds")
