return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          cpp = { "clang-format" },
          lua = { "stylelua" },
          python = { "isort", "black" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        }
      })

      -- keymap for formatting
      vim.keymap.set({ "n", "v" }, "<leader>gf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end
  },
}
