{ pkgs, pkgsUnstable, ... }:
{
  programs.neovim = {
    enable = true;

    extraLuaConfig =
      builtins.readFile ./nvim/lua/options.lua + builtins.readFile ./nvim/lua/keymaps.lua;

    plugins = with pkgs.vimPlugins; [
      # LSP
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/lsp.lua;
      }

      # Formatting
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/conform.lua;
      }

      # Completion
      {
        plugin = blink-cmp;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/blink.lua;
      }

      # Treesitter
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/treesitter.lua;
      }

      # Telescope
      plenary-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/telescope.lua;
      }

      # Snacks (utilities)
      {
        plugin = snacks-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/snacks.lua;
      }

      # Noice (better UI)
      nui-nvim
      nvim-notify
      {
        plugin = noice-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/noice.lua;
      }

      # Mini (surround + autopairs)
      {
        plugin = mini-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/mini.lua;
      }

      # Bufferline (tab bar)
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/bufferline.lua;
      }

      # UI
      nvim-web-devicons
      {
        plugin = neovim-ayu;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/ui.lua;
      }
      lualine-nvim # loaded by ui.lua

      # Navigation
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/oil.lua;
      }
      {
        plugin = vim-tmux-navigator;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/tmux.lua;
      }
      # Diagnostics list
      {
        plugin = trouble-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/trouble.lua;
      }

      # Better TS/JSX comments
      {
        plugin = nvim-ts-context-commentstring;
        type = "lua";
        config = builtins.readFile ./nvim/lua/plugins/ts-comments.lua;
      }

    ];

    extraPackages = with pkgs; [
      # LSP servers
      typescript
      typescript-language-server
      tsgo # TypeScript 7 native compiler
      oxlint

      # Formatters
      prettierd
      nodePackages.prettier
      stylua
      nixfmt-rfc-style

      # Telescope dependencies
      ripgrep
      fd

      # Snacks dependencies
      lazygit
      pkgsUnstable.oxfmt
    ];

  };
}
