return {
    {
        'glepnir/nerdicons.nvim',
        cmd = 'NerdIcons',
        config = function() require('nerdicons').setup({}) end
    },

    "adelarsq/vim-emoji-icon-theme",
    -------UNICODE---------
    "chrisbra/unicode.vim",
    ------CURSOR WORD------
    {
        "xiyaowong/nvim-cursorword",
        config = function()
            vim.g.cursorword_disable_at_startup = true
            vim.g.cursorword_min_width = 1
            vim.g.cursorword_max_width = 50
        end
    },

    -- Vimproc to asynchronously run commands (NeoBundle, Unite)
    {
        'Shougo/vimproc',
        build = function()
            local platform = vim.loop.os_uname().sysname
            if platform == "Darwin" then
                vim.fn.system("make -f make_mac.mak")
            elseif platform == "Linux" or platform == "FreeBSD" then
                vim.fn.system("make -f make_unix.mak")
            end
        end,
    },
    ---VIMFILER---------------------
    "Shougo/unite.vim",
    {
        "Shougo/vimfiler.vim",
        keys = {
            {"<leader>e", ":VimFilerExplorer<CR>", mode = {"n"}, silent = true, desc = "Open file browser"},
        },
        config = function()
            vim.g.vimfiler_as_default_explorer = 1
            vim.g.vimfiler_expand_jump_to_first_child = 0

            vim.g.vimfiler_tree_leaf_icon = vim.fn.nr2char(0x1F341)
            vim.g.vimfiler_tree_opened_icon = vim.fn.nr2char(0x1F5C1)
            vim.g.vimfiler_tree_closed_icon = vim.fn.nr2char(0x1F5C0)
            vim.g.vimfiler_file_icon = vim.fn.nr2char(0x1F5B9)
            vim.g.vimfiler_readonly_file_icon = vim.fn.nr2char(0x1F512)

            vim.api.nvim_call_function("vimfiler#custom#profile", {
                "default", "context", {
                    safe = 0,
                    tab = 0,
                    explorer = 1,
                    split = 1,
                    winminwidth = 300,
                    ['edit-action'] = "right",
                }
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "vimfiler",
                callback = function()
                    vim.keymap.set("n", "<CR>", "<Cmd>lua require('vimfiler').smart_cursor_map(vimfiler_expand_tree, vimfiler_edit_file)<CR>", { buffer = true, silent = true, expr = true })
                end,
            })
        end
    },

    -- FloatTerm
    "tpope/vim-dispatch",
    {
        "voldikss/vim-floaterm",
        keys = {
            { "<C-F7>", ":FloatermNew<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm New" },
            { "<C-F8>", ":FloatermPrev<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Prev" },
            { "<C-F9>", ":FloatermNext<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Next" },
            { "<C-F11>", ":FloatermKill<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Kill" },
            { "<C-F12>", ":FloatermToggle<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Toggle" },
        },
        cmd = {
        	"FloatermNew",
        	"FloatermToggle",
        },

        config = function()
        -- Terminal mode keymaps need a special treatment:
        vim.keymap.set("t", "<C-F7>", "<C-\\><C-n>:FloatermNew<CR>", { silent = true, desc = "Floaterm New" })
        vim.keymap.set("t", "<C-F8>", "<C-\\><C-n>:FloatermPrev<CR>", { silent = true, desc = "Floaterm Prev" })
        vim.keymap.set("t", "<C-F9>", "<C-\\><C-n>:FloatermNext<CR>", { silent = true, desc = "Floaterm Next" })
        vim.keymap.set("t", "<C-F11>", "<C-\\><C-n>:FloatermKill<CR>", { silent = true, desc = "Floaterm Kill" })
        vim.keymap.set("t", "<C-F12>", "<C-\\><C-n>:FloatermToggle<CR>", { silent = true, desc = "Floaterm Toggle" })
        end,
    },

    -- NETMAN -----------------------
    "miversen33/netman.nvim",

    --BBye ------------------------
    {
        'moll/vim-bbye', keys = {
            {"<C-K>k", ":Bdelete!<CR>", desc = "Delete buffers without changing layout", silent = true,},
        },
    },

    --LSP  ------------------------
    'neovim/nvim-lspconfig', -- Required
    {
        'williamboman/mason.nvim', -- Optional
        config = function()
            require("mason").setup()
            vim.cmd("MasonUpdate")
        end,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        },
    },
    'williamboman/mason-lspconfig.nvim', -- optional

    --Autocompletion---------------
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    --'saadparwaiz1/cmp_luasnip ",
    "hrsh7th/cmp-nvim-lua",

    --Snippets----------------------
    'L3MON4D3/LuaSnip',
    --'rafamadriz/friendly-snippets',
    {'VonHeikemen/lsp-zero.nvim', branch = 'v1.x'},
  
    --Telescope---------------------
    'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        keys   = {
            {"<C-K>g", ":Telescope grep_string<CR>", desc = "Global grep"},
            {"<C-K>f", ":Telescope find_files<CR>", desc  = "Global file search"},
            {"<C-K>b", ":Telescope buffers<CR>", desc     = "Global buffer search"},
        },
    },
                 'BurntSushi/ripgrep',
                         'sharkdp/fd',
    'nvim-treesitter/nvim-treesitter',
    --'nvim-tree/nvim-web-devicons'
    --'ryanoasis/vim-devicons'

    --Code aligning------------------
    {
        'junegunn/vim-easy-align',
        keys = {
            {"<Enter>", "<Plug>(EasyAlign)", mode = {"n", "v"}, desc = "Align code to delimiter"},
        },
        lazy = true,
    },
    -- Replacement for standard status line
    {
        'vim-airline/vim-airline',
        dependencies = {
            'vim-airline/vim-airline-themes',
        },
        lazy = true,
    },
    -- And plugins for it
    'vim-airline/vim-airline-themes',

    'https://github.com/tpope/vim-characterize.git',
}
