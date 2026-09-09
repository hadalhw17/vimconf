return {
    --Colorscheme-------------------
    {
        'webhooked/kanso.nvim',
        lazy = false,
        priority = 1000,
    },

    --Treesitter--------------------
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            require('nvim-treesitter').install({ 'c', 'cpp', 'c_sharp', 'lua' })
            -- On the main branch, highlighting is opt-in per filetype
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
                pattern = { 'c', 'cpp', 'cs', 'lua' },
                callback = function()
                    if pcall(vim.treesitter.start) then
                        -- Structural folds where a parser runs; other buffers
                        -- keep the manual foldmethod from .vimrc
                        vim.wo.foldmethod = 'expr'
                        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    end
                end,
            })
        end,
    },

    {
        'glepnir/nerdicons.nvim',
        cmd = 'NerdIcons',
        config = function() require('nerdicons').setup({}) end
    },

	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
	},
    -------UNICODE---------
    "chrisbra/unicode.vim",

    -- Async build/test runner (:Make used by Build()/Rebuild() in .vimrc)
    "tpope/vim-dispatch",

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
    {
        'saghen/blink.cmp',
        -- A version tag makes blink download the prebuilt Rust fuzzy matcher
        -- instead of requiring a cargo build
        version = '1.*',
        opts = {
            -- Gated on the same flag the <F2> toggle flips (see config/lsp.lua)
            enabled = function()
                return vim.g.nvimCmpEnabled
            end,
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },
            completion = {
                list = {
                    -- <CR> only accepts an item you explicitly navigated to
                    selection = { preselect = false, auto_insert = true },
                },
                menu = { border = 'rounded' },
                documentation = {
                    auto_show = true,
                    window = { border = 'rounded' },
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
    },

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
            {"<C-K>r", ":Telescope resume<CR>", desc = "Resume previous"},
            {"<C-K>f", ":Telescope live_grep<CR>", desc = "Global grep"},
            {"<C-K>g", ":Telescope grep_string<CR>", desc = "Grep under cursor"},
            {"<C-K>t", ":Telescope find_files<CR>", desc  = "Global file search"},
            {"<C-K>b", ":Telescope buffers<CR>", desc     = "Global buffer search"},
            {"<C-K>s", ":Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Code symbol search"},
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
      keys = {
        { "<leader><F12>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
        { "<leader><F7>", function() Snacks.terminal.toggle(nil, { cwd = vim.fn.expand("%:p:h") }) end, desc = "Terminal in file's dir" },
        { "<C-K>k", function() Snacks.bufdelete() end, desc = "Delete buffer, keep layout" },
      },
      opts = {
        words = { enabled = true },
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
        notifier = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
              icon = " ",
              title = "Recent Files (project)",
              section = "recent_files",
              -- Scope to the git root when there is one, else the cwd.
              -- History comes from shada; nothing is written into the worktree.
              cwd = vim.fs.root(vim.fn.getcwd(), ".git") or true,
              indent = 2,
              padding = 1,
            },
            { section = "startup" },
          },
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
    -- mini.align is part of mini.nvim, which is already installed as a
    -- render-markdown dependency; ga/gA in normal and visual mode
    {
        'nvim-mini/mini.nvim',
        config = function()
            require('mini.align').setup({})
            -- Preserve the old visual-mode <Enter> alignment habit
            vim.keymap.set('x', '<Enter>', 'ga', { remap = true, desc = 'Align code to delimiter' })
        end,
    },
    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },

    'https://github.com/tpope/vim-characterize.git',

	'sindrets/diffview.nvim',

	'tpope/vim-fugitive',

	-- Git hunk signs, navigation and staging
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			on_attach = function(bufnr)
				local gs = require('gitsigns')
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				map('n', ']c', function()
					if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
				end, 'Next change')
				map('n', '[c', function()
					if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
				end, 'Prev change')
				map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
				map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
				map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
				map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
			end,
		},
	},

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

	-- Formatting, on demand only (<leader>f); falls back to LSP (clangd) when
	-- no formatter binary is available for the filetype
	{
		'stevearc/conform.nvim',
		keys = {
			{
				'<leader>f',
				function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
				mode = { 'n', 'x' },
				desc = 'Format buffer or range',
			},
		},
		opts = {
			formatters_by_ft = {
				c = { 'clang-format' },
				cpp = { 'clang-format' },
				cs = { 'clang-format' },
				json = { 'jq' },
			},
		},
	},

	{
        "allaman/emoji.nvim",
        lazy = false,
        dependencies = {
            -- util for handling paths
            "nvim-lua/plenary.nvim",
			-- optional for telescope integration
			"nvim-telescope/telescope.nvim",
			-- optional for fzf-lua integration via vim.ui.select
			"ibhagwan/fzf-lua",
		},
		opts = {
			-- cmp integration off: completion moved to blink.cmp; emoji picking
			-- stays available via <C-k>e (telescope)
			enable_cmp_integration = false,
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
