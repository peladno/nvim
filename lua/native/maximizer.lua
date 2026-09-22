local M = {}

local is_maximized = false
local restore_cmd = ""

function M.toggle()
	if is_maximized then
		if restore_cmd ~= "" then
			vim.cmd(restore_cmd)
		end
		is_maximized = false
	else
		restore_cmd = vim.fn.winrestcmd()
		vim.cmd("wincmd |")
		vim.cmd("wincmd _")
		is_maximized = true
	end
end

function M.setup()
	vim.api.nvim_create_user_command("MaximizerToggle", M.toggle, {
		desc = "Maximize/restore current split window",
	})
	vim.keymap.set("n", "<leader>sm", M.toggle, { desc = "Maximize/minimize a split" })
end

return M

