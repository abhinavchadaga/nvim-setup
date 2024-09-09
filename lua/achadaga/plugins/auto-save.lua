return {
  "pocco81/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      write_all_buffers = true,
      debouce_delay = 1000
    })
    local opts = { desc = "[t]oggle [a]uto [s]ave" }
    vim.api.nvim_set_keymap("n", "<leader>tas", ":ASToggle<CR>", opts)
  end
}
