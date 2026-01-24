local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		graphql = { "prettierd", "prettier", stop_after_first = true },
		lua = { "stylua" },
		nix = { "nixfmt" },
	},

	format_on_save = {
		timeout_ms = 3000,
		lsp_fallback = true,
	},

	-- Use project-local prettier if available
	formatters = {
		prettier = {
			prepend_args = { "--prose-wrap", "always" },
		},
	},
})

-- Manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	conform.format({
		async = true,
		lsp_fallback = true,
	})
end, { desc = "Format" })
