return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
    })

    -- Key mappings for multiple terminals
    vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", { desc = "Toggle Terminal 1" })
    vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Toggle Terminal 2" })
    vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Toggle Terminal 3" })
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], { desc = "Navigate left from terminal" })
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { desc = "Navigate down from terminal" })
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { desc = "Navigate up from terminal" })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { desc = "Navigate right from terminal" })
  end,
}
