return {
    {
        'glepnir/nerdicons.nvim',
        cmd = 'NerdIcons',
        config = function() require('nerdicons').setup({}) end
    },

	{
		"kyazdani42/nvim-web-devicons",
		lazy = false,
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
        lazy = false,
        keys = {
            { "<leader><F7>", ":FloatermNew! cd %:h:p<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm New" },
            { "<leader><F8>", ":FloatermPrev<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Prev" },
            { "<leader><F9>", ":FloatermNext<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Next" },
            { "<leader><F11>", ":FloatermKill<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Kill" },
            { "<leader><F12>", ":FloatermToggle<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Toggle" },
        },
        cmd = {
        	"FloatermNew",
        	"FloatermToggle",
        },

        config = function()
        -- Terminal mode keymaps need a special treatment:
        vim.keymap.set("t", "<leader><F7>", "<C-\\><C-n>:FloatermNew<CR>", { silent = true, desc = "Floaterm New" })
        vim.keymap.set("t", "<leader><F8>", "<C-\\><C-n>:FloatermPrev<CR>", { silent = true, desc = "Floaterm Prev" })
        vim.keymap.set("t", "<leader><F9>", "<C-\\><C-n>:FloatermNext<CR>", { silent = true, desc = "Floaterm Next" })
        vim.keymap.set("t", "<leader><F11>", "<C-\\><C-n>:FloatermKill<CR>", { silent = true, desc = "Floaterm Kill" })
        vim.keymap.set("t", "<leader><F12>", "<C-\\><C-n>:FloatermToggle<CR>", { silent = true, desc = "Floaterm Toggle" })
        end,
    },

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
            require("mason").setup({})
            require("cmp_nvim_lsp").setup({
                ensure_installed = {"clangd"},
            })
            vim.cmd("MasonUpdate")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config('clangd', {
            	capabilities = capabilities,
            	filetypes = {"c", "cpp", "cc", "ixx", "cppm", "h", "hpp", "inl"},
            	cmd = {
            		"clangd",
            		"--background-index",
            		"--clang-tidy",
            		"--completion-style=detailed",
            		"--experimental-modules-support",
				},
                init_options = {
                    fallbackFlags = { '-std=c++23' },
                },
            });
        end,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
    		'hrsh7th/cmp-nvim-lsp',
        },
    },
    'williamboman/mason-lspconfig.nvim', -- optional
    --CMake-------------------------
    {
    	'Civitasv/cmake-tools.nvim',
    	config = function()
    		require("cmake-tools").setup({
    			cmake_command = "cmake",
    			ctest_command = "ctest",
    			cmake_build_directory = function()
    				return "solutions"
				end,
				cmake_compile_commands_options = {
					action = "lsp",
				},
				cmake_dap_configuration = {
					name    = "cpp",
					type    = "codelldb",
					request = "launch",
					stopOnEntry = false,
					runInTerminal = true,
					console = "integratedTerminal",
				},
    		})
		end,
	},
	--Debugger---------------------
	{
		'mfussenegger/nvim-dap',
		config = function()
			local dap = require('dap')
            dap.adapters.codelldb = {
                  type = "server",
                  port = "${port}",
                  executable = {
                      command = "codelldb", -- I installed codelldb through mason.nvim
                      args = {"--port", "${port}"},
                  },
            }
             dap.configurations.cpp = {
               {
                 name = "Launch",
                 type = "codelldb",
                 request = "launch",
                 program = function()
                   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                 end,
                 cwd = '${workspaceFolder}',
                 stopOnEntry = false,
                 args = {}
               }
             }
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},


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
            {"<C-K>f", ":Telescope live_grep<CR>", desc = "Global grep"},
            {"<C-K>g", ":Telescope grep_string<CR>", desc = "Grep under cursor"},
            {"<C-K>t", ":Telescope find_files<CR>", desc  = "Global file search"},
            {"<C-K>b", ":Telescope buffers<CR>", desc     = "Global buffer search"},
        },
    },
    'BurntSushi/ripgrep',
    'sharkdp/fd',

    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      dependencies = { "folke/snacks.nvim", lazy = true },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Open in the current working directory
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      -- 👇 if you use `open_for_directories=true`, this is recommended
      init = function()
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        -- vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
    },

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
    },
    -- And plugins for it
    'vim-airline/vim-airline-themes',

    'https://github.com/tpope/vim-characterize.git',

	'sbdchd/neoformat',
    {
        "allaman/emoji.nvim",
        lazy = false,
        version = "1.0.0", -- optionally pin to a tag
        dependencies = {
            -- util for handling paths
            "nvim-lua/plenary.nvim",
            -- optional for nvim-cmp integration
            "hrsh7th/nvim-cmp",
            -- optional for telescope integration
            "nvim-telescope/telescope.nvim",
            -- optional for fzf-lua integration via vim.ui.select
            "ibhagwan/fzf-lua",
        },
        opts = {
            -- default is false, also needed for blink.cmp integration!
            enable_cmp_integration = true,
            -- optional if your plugin installation directory
            -- is not vim.fn.stdpath("data") .. "/lazy/
            plugin_path = vim.fn.expand("$HOME/.local/share/nvim/lazy/"),
        },
        config = function(_, opts)
            require("emoji").setup(opts)
            -- optional for telescope integration
            local ts = require('telescope').load_extension 'emoji'
            vim.keymap.set('n', '<C-k>e', ts.emoji, { desc = '[S]earch [E]moji' })
        end,
    },
{
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = 'qwen',
          inline = 'qwen',
        },
      },
      adapters = {
		  http = {
            qwen = function()
              return require('codecompanion.adapters').extend('ollama', {
                name = 'qwen', -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                  model = {
                    default = 'llama3',
                  },
                },
              })
            end,
		},
      },
      opts = {
        log_level = 'DEBUG',
      },
      display = {
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split for default provider
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          provider = 'default', -- default|mini_diff
        },
      },
    },
  },
}
