---------------
--- KEYMAPS ---
---------------

vim.g.mapleader = " "

local keymap = vim.keymap

-- for copy paste
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste to system clipboard", noremap = true, silent = true })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlight" })

-- increment numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "increment number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

---------------
--- OPTIONS ---
---------------

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
local g = vim.g

-- LH line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 space tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new one

-- turn off line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- use case-sensitive search when search term is mixed case

opt.cursorline = true

-- some color settings
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
local function is_ssh()
	return vim.env.SSH_CLIENT ~= nil
end

-- clipboard support for orbstack and ssh
local kernel_name = vim.fn.system("uname -r"):lower()
if string.find(kernel_name, "orbstack") then
	vim.g.clipboard = {
		name = "pbcopy",
		copy = {
			["+"] = "pbcopy",
			["*"] = "pbcopy",
		},
		paste = {
			["+"] = "pbpaste",
			["*"] = "pbpaste",
		},
		cache_enabled = 0,
	}
elseif is_ssh() then
	g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
else
	opt.clipboard = ""
end

-- window settings
opt.splitright = true
opt.splitbelow = true

-----------------
--- LAZY.NVIM ---
-----------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {

		-----------------
		-- COLORSCHEME --
		-----------------

		{
			"bluz71/vim-nightfly-colors",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd([[colorscheme nightfly]])
			end,
		},

		----------------
		-- TREESITTER --
		----------------

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = {
						"c",
						"cpp",
						"python",
						"javascript",
						"typescript",
						"lua",
						"vim",
						"markdown",
						"css",
						"html",
						"markdown_inline",
						"bash",
					},
					sync_install = false,
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
				})

				local ts_install = require("nvim-treesitter.install")
				ts_install.compilers = { "cc", "c++" }
			end,
		},

		---------------
		-- TELESCOPE --
		---------------
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-tree/nvim-web-devicons", opts = {} },
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
			},
			config = function()
				-- load telescope extensions
				local telescope = require("telescope")
				telescope.load_extension("fzf")
				telescope.load_extension("ui-select")

				-- keymaps
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			end,
		},

		-------------------
		-- DRESSING.NVIM --
		-------------------

		{
			"stevearc/dressing.nvim",
			opts = {},
		},

		---------------
		-- NVIM-TREE --
		---------------

		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				local function on_attach(bufnr)
					local api = require("nvim-tree.api")
					api.config.mappings.default_on_attach(bufnr)

					keymap.set("n", "<leader>ee", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
					keymap.set(
						"n",
						"<leader>ef",
						"<cmd>NvimTreeFindFile<CR>",
						{ desc = "Focus file explorer on current file" }
					)
					keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
					keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
				end

				require("nvim-tree").setup({
					on_attach = on_attach,
				})
			end,
		},

		--------------
		-- NVIM-CMP --
		--------------

		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip",
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					snippet = {
						expand = function(args)
							vim.fn["vsnip#anonymous"](args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "vsnip" },
					}, {
						{ name = "buffer" },
					}),
				})

				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})

				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
					matching = { disallow_symbol_nonprefix_matching = false },
				})

				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		----------------
		-- LSP Config --
		----------------

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"p00f/clangd_extensions.nvim",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local function default_on_attach(_, bufnr)
					-- CONFIGURE KEYMAPS
					local opts = { buffer = bufnr, noremap = true, silent = true }

					opts.desc = "[g]o to [D]eclaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "[g]o to [d]efinition"
					keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "[g]o to [i]mplementation"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "[g]o to [t]ype definition"
					keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

					opts.desc = "[r]e[n]ame"
					keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

					opts.desc = "[g]o to [r]eferences"
					keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Show line [d]iagnostics"
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Show file [D]iagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Go to [p]revious [d]iagnostic"
					keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev, opts)

					opts.desc = "Go to [n]ext [d]agnostic"
					keymap.set("n", "<leader>nd", vim.diagnostic.goto_next, opts)

					opts.desc = "Add buffer diagnostics to the [q]uickfix list"
					keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

					opts.desc = "Show [c]ode [a]ctions"
					keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end

				-- CONFIGURE LSP SERVERS
				local lspconfig = require("lspconfig")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- Lua
				lspconfig.lua_ls.setup({
					on_attach = default_on_attach,
					capabilities = capabilities,
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
								},
							},
						})
					end,
					settings = {
						Lua = {},
					},
				})

				-- C/C++
				local function clangd_on_attach(client, bufnr)
					default_on_attach(client, bufnr)
					local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })

					vim.keymap.set("n", "<leader>lh", function()
						if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
							vim.api.nvim_create_autocmd("InsertEnter", {
								group = group,
								buffer = bufnr,
								callback = require("clangd_extensions.inlay_hints").disable_inlay_hints,
							})
							vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
								group = group,
								buffer = bufnr,
								callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
							})
						else
							vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
						end
					end, { buffer = bufnr, desc = "[l]sp [h]ints toggle" })

					local opts = { buffer = bufnr, noremap = true, silent = true }
					opts.desc = "Show clangd [t]ype [h]ierarchy"
					keymap.set("n", "<leader>th", "<cmd>ClangdTypeHierarchy<CR>", opts)

					opts.desc = "[s]witch between [s]ource and [h]eader"
					keymap.set("n", "<leader>ssh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
				end

				lspconfig.clangd.setup({
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
						"--compile-commands-dir=build",
						"--all-scopes-completion",
						"--pch-storage=memory",
						"--offset-encoding=utf-16",
					},
					on_attach = clangd_on_attach,
					capabilities = capabilities,
					init_options = {
						clangdFileStatus = true,
						usePlaceholders = true,
						completeUnimported = true,
						semanticHighlighting = true,
					},
				})

				-- PYTHON
				lspconfig.pyright.setup({
					on_attach = default_on_attach,
					capabilities = capabilities,
				})

				-- BASH
				lspconfig.bashls.setup({
					on_attach = default_on_attach,
					capabilities = capabilities,
				})
			end,
		},

		-------------
		-- CONFORM --
		-------------

		{
			"stevearc/conform.nvim",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local conform = require("conform")
				conform.setup({
					formatters_by_ft = {
						javascript = { "prettier" },
						typescript = { "prettier" },
						javascriptreact = { "prettier" },
						typescriptreact = { "prettier" },
						css = { "prettier" },
						html = { "prettier" },
						json = { "prettier" },
						yaml = { "prettier" },
						markdown = { "prettier" },
						lua = { "stylua" },
						c = { "clang-format" },
						cpp = { "clang-format" },
						bash = { "shfmt" },
						zsh = { "shfmt" },
						python = { "isort", "black" },
					},
				})

				keymap.set({ "n", "v" }, "<leader>mp", function()
					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end, { desc = "Format file or range (in visual mode)" })
			end,
		},

		------------------------
		-- VIM-TMUX-NAVIGATOR --
		------------------------

		{
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateLeft",
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateRight",
				"TmuxNavigatePrevious",
				"TmuxNavigatorProcessList",
			},
			keys = {
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
		},

		-------------------
		-- NVIM-SURROUND --
		-------------------

		{
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			opts = {},
		},

		----------------------
		-- INDENT-BLANKLINE --
		----------------------

		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {
				indent = { char = "┊" },
			},
		},

		---------------
		-- AUTOPAIRS --
		---------------

		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
			opts = {},
		},

		-------------
		-- LUALINE --
		-------------

		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				options = { theme = "nightfly" },
			},
		},

		------------------------------
		-- NVIM-LSP-FILE-OPERATIONS --
		------------------------------

		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-tree.lua",
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},

		---------------
		-- AUTO-SAVE --
		---------------

		{
			"pocco81/auto-save.nvim",
			config = function()
				require("auto-save").setup({
					write_all_buffers = true,
					debouce_delay = 1000,
				})
				local opts = { desc = "[t]oggle [a]uto [s]ave" }
				vim.api.nvim_set_keymap("n", "<leader>tas", ":ASToggle<CR>", opts)
			end,
		},
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})
