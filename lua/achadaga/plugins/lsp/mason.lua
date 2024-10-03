return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        -- not available on arm64 linux
        -- "clangd",
        "cmake",
        "pyright",
        "bashls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- js/ts
        "eslint_d",
        "prettier",
        -- lua
        "stylua",
        -- python
        "isort",
        "black",
        "pylint",
        -- cpp
        "clang-format",
        -- bash, zsh
        "shfmt",
        "shellcheck",
      },
    })
  end,
}
