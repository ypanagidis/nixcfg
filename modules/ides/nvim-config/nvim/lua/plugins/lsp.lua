-- LSP Configuration

-- Configure tsgo with more memory and inlay hints
vim.lsp.config("tsgo", {
	init_options = {
		maxTsServerMemory = 8192,
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
})

-- Configure oxlint to disable auto-fix on save
-- oxlint >= 1.x uses `oxlint --lsp` instead of the old oxc_language_server binary
-- Keep root markers explicit to avoid package.json breadth-first root detection in monorepos.
local oxlint_root_markers = {
	".oxlintrc.json",
	".oxlintrc.jsonc",
	"oxlint.config.ts",
	"oxlint.config.mts",
	"oxlint.config.cts",
	"oxlint.config.js",
	"oxlint.config.mjs",
	"oxlint.config.cjs",
}

vim.lsp.config("oxlint", {
	-- Nested configs are still supported via root_dir selecting the nearest config marker.
	cmd = { "oxlint", "--lsp", "--disable-nested-config" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(fname, oxlint_root_markers) or vim.fs.root(fname, { ".git" })
		if root then
			on_dir(root)
		end
	end,
	settings = {
		oxc = {
			fixKind = "none", -- Disable all auto-fixes (still shows diagnostics)
		},
	},
})

-- Enable servers (configs come from nvim-lspconfig)
vim.lsp.enable({
	"tsgo",
	"oxlint",
	"tailwindcss",
	-- Add more servers as needed:
	-- "lua_ls",
	-- "pyright",
	-- "rust_analyzer",
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local opts = { buffer = args.buf }

		-- Navigation (using Snacks picker for nice display)
		vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set(
			"n",
			"gD",
			function() Snacks.picker.lsp_declarations() end,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)
		vim.keymap.set(
			"n",
			"gy",
			function() Snacks.picker.lsp_type_definitions() end,
			vim.tbl_extend("force", opts, { desc = "Go to type definition" })
		)
		vim.keymap.set(
			"n",
			"gi",
			function() Snacks.picker.lsp_references() end,
			vim.tbl_extend("force", opts, { desc = "Go to references" })
		)
		vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, vim.tbl_extend("force", opts, { desc = "Find references" }))

		-- Info
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		vim.keymap.set(
			"n",
			"<leader>k",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Signature help" })
		)

		-- Actions
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
		vim.keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.format({ async = true })
		end, vim.tbl_extend("force", opts, { desc = "Format" }))

		-- Diagnostics
		vim.keymap.set(
			"n",
			"<leader>cd",
			vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
		)
		vim.keymap.set(
			"n",
			"[d",
			vim.diagnostic.goto_prev,
			vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
		)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	end,
})

-- Diagnostic appearance
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})
