return {
  "rebelot/kanagawa.nvim",
  config = function()
    require('kanagawa').setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      background = {
        dark = "dragon",
        light = "lotus"
      },
    })

    vim.cmd("colorscheme kanagawa")
  end
}