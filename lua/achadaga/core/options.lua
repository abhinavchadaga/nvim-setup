-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
local g = vim.g

-- LH line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 space tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new one

-- turn off line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- use case-sensitive search when search term is mixed case

opt.cursorline = true

-- some color settings
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
local function is_ssh()
  return vim.env.SSH_CLIENT ~= nil
end

local kernel_name = vim.fn.system("uname -r"):lower()
if string.find(kernel_name, "orbstack") then
  vim.g.clipboard = {
    name = "pbcopy",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
elseif is_ssh() then
  g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
else
  opt.clipboard = ""
end

-- window settings
opt.splitright = true
opt.splitbelow = true
