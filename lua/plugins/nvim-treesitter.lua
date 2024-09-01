return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "cpp" },
      sync_install = false,
      highlight = { enable = true },
      -- can disable indent, I remember this was giving me problems
      -- indent = { enable = true },
    })
  end
}
