local M = {}

local state = {
	win = nil,
	buf = nil,
	prev_win = nil,
	current_dir = nil,
	show_hidden = true,
	entries = {},
}

local function get_icon(name, is_dir)
	local ok_mini, mini_icons = pcall(require, "mini.icons")
	if ok_mini and mini_icons.get then
		local icon, _ = mini_icons.get(is_dir and "directory" or "file", name)
		if icon and icon ~= "" then
			return icon .. " "
		end
	end
	return is_dir and " " or " "
end

local function scan_dir(dir)
	local entries = {}
	local handle = vim.uv.fs_scandir(dir)
	if not handle then
		return entries
	end

	while true do
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end

		if state.show_hidden or not name:match("^%.") then
			local is_dir = (type == "directory")
			table.insert(entries, {
				name = name,
				is_dir = is_dir,
				full_path = dir .. "/" .. name,
			})
		end
	end

	-- Sort: directories first, then alphabetically
	table.sort(entries, function(a, b)
		if a.is_dir ~= b.is_dir then
			return a.is_dir
		end
		return a.name:lower() < b.name:lower()
	end)

	return entries
end

local function render()
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
		return
	end

	state.entries = scan_dir(state.current_dir)
	local lines = { "  .. (parent dir)" }
	local highlights = { { line = 0, hl = "Comment" } }

	for i, entry in ipairs(state.entries) do
		local icon = get_icon(entry.name, entry.is_dir)
		local suffix = entry.is_dir and "/" or ""
		table.insert(lines, string.format("  %s%s%s", icon, entry.name, suffix))

		if entry.is_dir then
			table.insert(highlights, { line = i, hl = "Directory" })
		end
	end

	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.bo[state.buf].modifiable = false

	-- Apply highlights
	local ns = vim.api.nvim_create_namespace("native_explorer")
	vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
	for _, h in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(state.buf, ns, h.hl, h.line, 0, -1)
	end

	-- Update window title
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		local title = string.format(" 📁 %s %s", state.current_dir:gsub(vim.fn.expand("~"), "~"), state.show_hidden and "" or "[Hidden hidden] ")
		vim.api.nvim_win_set_config(state.win, {
			title = title,
			title_pos = "center",
		})
	end
end

local function close()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
	state.buf = nil
end

local function open_entry()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

	-- Parent directory selected
	if cursor_line == 1 then
		local parent = vim.fs.dirname(state.current_dir)
		if parent and parent ~= state.current_dir then
			state.current_dir = parent
			render()
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
		end
		return
	end

	local entry = state.entries[cursor_line - 1]
	if not entry then
		return
	end

	if entry.is_dir then
		state.current_dir = entry.full_path
		render()
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
	else
		local target_path = entry.full_path
		local prev_win = state.prev_win
		close()
		if prev_win and vim.api.nvim_win_is_valid(prev_win) then
			vim.api.nvim_set_current_win(prev_win)
		end
		vim.cmd("edit " .. vim.fn.fnameescape(target_path))
	end
end

local function go_parent()
	local parent = vim.fs.dirname(state.current_dir)
	if parent and parent ~= state.current_dir then
		state.current_dir = parent
		render()
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
	end
end

local function create_file_or_dir()
	vim.ui.input({ prompt = "New file or directory (end with / for dir): " }, function(input)
		if not input or input == "" then
			return
		end
		local full = state.current_dir .. "/" .. input
		if input:match("/$") then
			vim.fn.mkdir(full, "p")
		else
			local parent = vim.fs.dirname(full)
			if vim.fn.isdirectory(parent) == 0 then
				vim.fn.mkdir(parent, "p")
			end
			local f = io.open(full, "w")
			if f then
				f:close()
			end
		end
		render()
	end)
end

local function delete_entry()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	if cursor_line == 1 then
		return
	end

	local entry = state.entries[cursor_line - 1]
	if not entry then
		return
	end

	local prompt = string.format("Delete %s '%s'?", entry.is_dir and "directory" or "file", entry.name)
	local choice = vim.fn.confirm(prompt, "&Yes\n&No", 2)
	if choice == 1 then
		if entry.is_dir then
			vim.fn.delete(entry.full_path, "rf")
		else
			vim.fn.delete(entry.full_path)
		end
		render()
	end
end

local function rename_entry()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	if cursor_line == 1 then
		return
	end

	local entry = state.entries[cursor_line - 1]
	if not entry then
		return
	end

	vim.ui.input({ prompt = "Rename to: ", default = entry.name }, function(new_name)
		if not new_name or new_name == "" or new_name == entry.name then
			return
		end
		local new_path = state.current_dir .. "/" .. new_name
		local success, err = vim.uv.fs_rename(entry.full_path, new_path)
		if not success then
			vim.notify("Error renaming: " .. (err or "unknown"), vim.log.levels.ERROR)
		else
			render()
		end
	end)
end

local function toggle_hidden()
	state.show_hidden = not state.show_hidden
	render()
end

local function setup_buffer_keymaps(buf)
	local opts = { buffer = buf, nowait = true, silent = true }
	vim.keymap.set("n", "<CR>", open_entry, opts)
	vim.keymap.set("n", "l", open_entry, opts)
	vim.keymap.set("n", "-", go_parent, opts)
	vim.keymap.set("n", "h", go_parent, opts)
	vim.keymap.set("n", "a", create_file_or_dir, opts)
	vim.keymap.set("n", "d", delete_entry, opts)
	vim.keymap.set("n", "r", rename_entry, opts)
	vim.keymap.set("n", ".", toggle_hidden, opts)
	vim.keymap.set("n", "R", render, opts)
	vim.keymap.set("n", "q", close, opts)
	vim.keymap.set("n", "<Esc>", close, opts)
end

function M.open(dir)
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		close()
		return
	end

	state.prev_win = vim.api.nvim_get_current_win()

	if not dir or dir == "" then
		local buf_name = vim.api.nvim_buf_get_name(0)
		if buf_name ~= "" and vim.fn.filereadable(buf_name) == 1 then
			dir = vim.fs.dirname(buf_name)
		else
			dir = vim.fn.getcwd()
		end
	end

	state.current_dir = vim.fs.normalize(dir)

	local width = math.floor(vim.o.columns * 0.60)
	local height = math.floor(vim.o.lines * 0.70)
	local row = math.floor((vim.o.lines - height) / 2) - 1
	local col = math.floor((vim.o.columns - width) / 2)

	state.buf = vim.api.nvim_create_buf(false, true)
	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].filetype = "native_explorer"
	vim.bo[state.buf].swapfile = false

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " 📁 Explorer ",
		title_pos = "center",
	})

	vim.wo[state.win].cursorline = true
	vim.wo[state.win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual"

	setup_buffer_keymaps(state.buf)
	render()
end

function M.setup()
	-- Global commands and keymaps
	vim.api.nvim_create_user_command("Explorer", function(opts)
		M.open(opts.args ~= "" and opts.args or nil)
	end, { nargs = "?", complete = "dir", desc = "Open Native Floating File Explorer" })

	vim.keymap.set("n", "-", function()
		M.open()
	end, { desc = "Open Native File Explorer" })

	vim.keymap.set("n", "<leader>-", function()
		M.open()
	end, { desc = "Open Native File Explorer" })
end

return M

