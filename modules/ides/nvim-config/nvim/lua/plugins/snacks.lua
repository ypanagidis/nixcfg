require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
        { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
        { icon = "󰒲 ", key = "q", desc = "Quit", action = ":qa" },
      },
      header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
      ]],
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    },
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = true },
})

-- Lazygit
vim.keymap.set("n", "<leader>G", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- Terminal
vim.keymap.set("n", "<leader>t", function() Snacks.terminal() end, { desc = "Terminal" })