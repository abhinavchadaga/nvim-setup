return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      cpp = { "clangtidy" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      lua = { "luacheck" },
    }

    -- force shellcheck to run 
    -- on zsh files
    lint.linters.shellcheck.args = {
      "--shell=bash",
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Show linters for the current buffer's file type
    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters then
        print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        print("No linters configured for filetype: " .. filetype)
      end
    end, {})
  end,
}
