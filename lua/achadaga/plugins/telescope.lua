return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    -- local transform_mod = require("telescope.actions.mt").transform_mod

    -- local trouble = require("trouble")
    -- local trouble_telescope = require("trouble.sources.telescope")

    -- local custom_actions = transform_mod({
    --   open_trouble_qflist = function(prompt_bufnr)
    --     trouble.toggle("quickfix")
    --   end,
    -- })

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        --   mappings = {
        --     i = {
        --       ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        --       ["<C-j>"] = actions.move_selection_next, -- move to next result
        --       ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
        --       ["<C-t>"] = trouble_telescope.open,
        --     },
        --   },
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("file_browser")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todos" })
    keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
  end,
}
