return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "p00f/clangd_extensions.nvim" },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function(_, bufnr)
      -- define keymaps
      local opts = { buffer = bufnr, noremap = true, silent = true }
      local keymap = vim.keymap

      opts.desc = "[g]o to [D]eclaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "[g]o to [d]efinition"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "[g]o to [i]mplementation"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "[g]o to [t]ype definition"
      keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

      opts.desc = "[r]e[n]ame"
      keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

      opts.desc = "[g]o to [r]eferences"
      keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Show line [d]iagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Show file [D]iagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Go to [p]revious [d]iagnostic"
      keymap.set("n", "pd", vim.diagnostic.goto_prev, opts)

      opts.desc = "Go to [n]ext [d]agnostic"
      keymap.set("n", "nd", vim.diagnostic.goto_next, opts)

      opts.desc = "Add buffer diagnostics to the [q]uickfix list"
      keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

      opts.desc = "Show [c]ode [a]ctions"
      keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      -- clangd extensions inlay hints
      local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })

      vim.keymap.set("n", "<leader>lh", function()
        if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
          vim.api.nvim_create_autocmd(
            "InsertEnter",
            { group = group, buffer = bufnr, callback = require("clangd_extensions.inlay_hints").disable_inlay_hints }
          )
          vim.api.nvim_create_autocmd(
            { "TextChanged", "InsertLeave" },
            { group = group, buffer = bufnr, callback = require("clangd_extensions.inlay_hints").set_inlay_hints }
          )
        else
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        end
      end, { buffer = bufnr, desc = "[l]sp [h]ints toggle" })

      opts.desc = "Show clangd [t]ype [h]ierarchy"
      keymap.set("n", "<leader>th", "<cmd>ClangdTypeHierarchy<CR>", opts)

      opts.desc = "[s]witch between [s]ource and [h]eader"
      keymap.set("n", "<leader>ssh", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
    end

    -- change diagnostics symbols
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local default_capabilities = cmp_nvim_lsp.default_capabilities()

    -- define handlers for each server
    local handlers = {
      function(server_name)
        lspconfig[server_name].setup({ capabilities = default_capabilities, on_attach = on_attach })
      end,
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          capabilities = default_capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
      ["clangd"] = function()
        require("clangd_extensions").setup({})
        lspconfig.clangd.setup({
          capabilities = default_capabilities,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=/opt/homebrew/opt/llvm/bin/clang++",
            "--compile-commands-dir=build",
            "--all-scopes-completion",
            "--pch-storage=memory",
            "--offset-encoding=utf-16",
          },
          on_attach = on_attach,
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
        })
      end,
      ["bashls"] = function()
        lspconfig.bashls.setup({
          filetypes = { "sh", "zsh" },
          on_attach = on_attach,
        })
      end,
    }

    mason_lspconfig.setup_handlers(handlers)
  end,
}
