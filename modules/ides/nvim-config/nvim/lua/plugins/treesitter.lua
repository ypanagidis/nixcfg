require("nvim-treesitter.configs").setup({
  -- Grammars are installed via Nix (nvim-treesitter.withAllGrammars)
  -- so we don't need ensure_installed

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
