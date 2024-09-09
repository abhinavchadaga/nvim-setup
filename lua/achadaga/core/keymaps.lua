vim.g.mapleader = " "

local keymap = vim.keymap

-- for copy paste
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = "Copy to system clipboard", noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = "Paste to system clipboard", noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<leader>yy', '"+yy', { desc = "Copy line to system clipboard", noremap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<leader>pp', '"+pp', { desc = "Paste line to system clipboard", noremap = true, silent = true })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlight" })

-- increment numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "increment number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
