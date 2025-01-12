return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- lua
        null_ls.builtins.formatting.stylua,
        -- cpp
        null_ls.builtins.formatting.clang_format,
        -- python
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.pylint,
      },
    })

    vim.keymap.set("n", "<leader>mp", vim.lsp.buf.format, { desc = "[m]ake [p]retty" })
  end,
}
