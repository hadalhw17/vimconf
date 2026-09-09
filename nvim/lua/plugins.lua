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

    -- FloatTerm
    "tpope/vim-dispatch",
    {
        "voldikss/vim-floaterm",
        lazy = false,
        keys = {
            -- <Cmd> mappings run the command in both normal and terminal mode
            -- without needing to leave terminal mode first
            { "<leader><F7>", "<Cmd>FloatermNew! cd %:h:p<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm New" },
            { "<leader><F8>", "<Cmd>FloatermPrev<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Prev" },
            { "<leader><F9>", "<Cmd>FloatermNext<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Next" },
            { "<leader><F11>", "<Cmd>FloatermKill<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Kill" },
            { "<leader><F12>", "<Cmd>FloatermToggle<CR>", mode = { "n", "t" }, silent = true, desc = "Floaterm Toggle" },
        },
        cmd = {
        	"FloatermNew",
        	"FloatermToggle",
        },
    },

    --BBye ------------------------
    {
        'moll/vim-bbye', keys = {
            {"<C-K>k", ":Bdelete!<CR>", desc = "Delete buffers without changing layout", silent = true,},
        },
    },

    --LSP  ------------------------
    'neovim/nvim-lspconfig',
    {
        'mason-org/mason.nvim',
        dependencies = {
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                -- Server configs and vim.lsp.enable() live in lua/config/lsp.lua
                automatic_enable = false,
            })
        end,
    },
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
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",

    --Snippets----------------------
    'L3MON4D3/LuaSnip',
    --'rafamadriz/friendly-snippets',

    --Telescope---------------------
    -- Note: the rg and fd binaries come from the system (scoop), not from plugins
    'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                -- Native C sorter, replaces the slow Lua fuzzy matcher
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
        },
        keys   = {
            {"<C-K>f", ":Telescope live_grep<CR>", desc = "Global grep"},
            {"<C-K>g", ":Telescope grep_string<CR>", desc = "Grep under cursor"},
            {"<C-K>t", ":Telescope find_files<CR>", desc  = "Global file search"},
            {"<C-K>b", ":Telescope buffers<CR>", desc     = "Global buffer search"},
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--trim',
                    },
                    preview = {
                        filesize_limit = 1, -- MB; skip previews of huge files
                    },
                },
                pickers = {
                    grep_string = {
                        word_match = '-w', -- Whole-word match for the word under cursor
                    },
                },
            })
            telescope.load_extension('fzf')
        end,
    },

    -- Big-file guard: oversized files get filetype "bigfile", which skips
    -- syntax, treesitter and LSP attach (servers match on filetype)
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = {
          enabled = true,
          size = 1.5 * 1024 * 1024,
          -- Snacks' default setup, plus per-redraw features turned off.
          -- Display-column math is O(line length), so on minified single-line
          -- files wrap/cursorline/relativenumber make every redraw rescan the
          -- line. Use :JsonPretty to split minified JSON into short lines.
          setup = function(ctx)
            if vim.fn.exists(":NoMatchParen") ~= 0 then
              vim.cmd([[NoMatchParen]])
            end
            Snacks.util.wo(0, {
              foldmethod = "manual",
              statuscolumn = "",
              conceallevel = 0,
              wrap = false,
              cursorline = false,
              relativenumber = false,
              list = false,
            })
            vim.b.completion = false
            vim.b.minianimate_disable = true
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ctx.buf) then
                vim.bo[ctx.buf].syntax = ctx.ft
              end
            end)
          end,
        },
      },
    },

    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      dependencies = { "folke/snacks.nvim" },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Old vimfiler explorer binding, kept for muscle memory
          "<leader>e",
          "<cmd>Yazi<cr>",
          desc = "Open file browser",
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
            -- No normal-mode <Enter>: it would shadow "jump to entry" in quickfix
            {"ga", "<Plug>(EasyAlign)", mode = {"n"}, desc = "Align code to delimiter"},
            {"<Enter>", "<Plug>(EasyAlign)", mode = {"x"}, desc = "Align code to delimiter"},
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

	'sindrets/diffview.nvim',

	'tpope/vim-fugitive',

	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		opts = {
			-- or "fzf-lua" or "snacks" or "default"
			picker = "telescope",
			-- bare Octo command opens picker of commands
			enable_builtin = true,
		},
		keys = {
			{
				"<leader>oi",
				"<CMD>Octo issue list<CR>",
				desc = "List GitHub Issues",
			},
			{
				"<leader>op",
				"<CMD>Octo pr list<CR>",
				desc = "List GitHub PullRequests",
			},
			{
				"<leader>od",
				"<CMD>Octo discussion list<CR>",
				desc = "List GitHub Discussions",
			},
			{
				"<leader>on",
				"<CMD>Octo notification list<CR>",
				desc = "List GitHub Notifications",
			},
			{
				"<leader>os",
				function()
					require("octo.utils").create_base_search_command { include_current_repo = true }
				end,
				desc = "Search GitHub",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR "ibhagwan/fzf-lua",
			-- OR "folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons", -- optional if file_panel.icons is a function
		},
	},

	'sbdchd/neoformat',
	{
        "allaman/emoji.nvim",
        lazy = false,
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

	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

}
