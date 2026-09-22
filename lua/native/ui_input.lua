local M = {}

function M.input(opts, on_confirm)
	opts = opts or {}
	local prompt = opts.prompt or "Input: "
	local default = opts.default or ""

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "prompt"
	vim.bo[buf].bufhidden = "wipe"

	local width = math.max(40, math.min(vim.o.columns - 4, #prompt + #default + 20))
	local height = 1
	local row = math.floor((vim.o.lines - height) / 2) - 2
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " " .. vim.trim(prompt) .. " ",
		title_pos = "center",
	})

	vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

	-- Set initial text
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })

	local confirmed = false

	local function close(result)
		if confirmed then
			return
		end
		confirmed = true
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if on_confirm then
			on_confirm(result)
		end
	end

	-- Confirm on Enter
	vim.keymap.set({ "n", "i" }, "<CR>", function()
		local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
		close(line)
	end, { buffer = buf, nowait = true })

	-- Cancel on Esc or C-c
	vim.keymap.set({ "n", "i" }, "<Esc>", function()
		close(nil)
	end, { buffer = buf, nowait = true })

	vim.keymap.set({ "n", "i" }, "<C-c>", function()
		close(nil)
	end, { buffer = buf, nowait = true })

	-- Clean up on BufLeave
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = buf,
		once = true,
		callback = function()
			close(nil)
		end,
	})

	vim.cmd("startinsert!")
end

function M.setup()
	-- Replace vim.ui.input with sleek native floating window
	vim.ui.input = M.input

	-- For vim.ui.select, integrate with fzf-lua if available
	local ok_fzf, fzf = pcall(require, "fzf-lua")
	if ok_fzf and fzf.register_ui_select then
		fzf.register_ui_select()
	end
end

return M

