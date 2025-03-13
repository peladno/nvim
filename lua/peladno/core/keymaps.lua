vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab:Explore

-- Yank into system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "yank motion" }) -- yank motion
keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { desc = "yank line" }) -- yank line

-- Delete into system clipboard
keymap.set({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete motion" }) -- delete motion
keymap.set({ "n", "v" }, "<leader>D", '"+D', { desc = "Delete line" }) -- delete line

-- Paste from system clipboard
keymap.set("n", "<leader>p", '"+p', { desc = "Paste after cursor" }) -- paste after cursor
keymap.set("n", "<leader>P", '"+P', { desc = "Paste before cursor" }) -- paste before cursor
