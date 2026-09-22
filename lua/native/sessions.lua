local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions"
local autosave_enabled = false

local function ensure_dir()
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end
end

local function cwd_to_session_name()
	local cwd = vim.fn.getcwd()
	return (cwd:gsub("/", "%%"):gsub(":", "-"))
end

local function session_name_to_path(name)
	return session_dir .. "/" .. name .. ".vim"
end

function M.save_session(name)
	ensure_dir()
	local sname = name or cwd_to_session_name()
	local file = session_name_to_path(sname)
	vim.cmd("mksession! " .. vim.fn.fnameescape(file))
	vim.notify("Session saved: " .. (name or vim.fn.getcwd()), vim.log.levels.INFO, { title = "Sessions" })
end

function M.list_sessions()
	ensure_dir()
	local handle = vim.uv.fs_scandir(session_dir)
	local sessions = {}
	if handle then
		while true do
			local name, type = vim.uv.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == "file" and name:match("%.vim$") then
				local clean_name = name:gsub("%.vim$", "")
				local display = clean_name:gsub("%%", "/")
				table.insert(sessions, { name = clean_name, display = display })
			end
		end
	end
	return sessions
end

function M.restore_session(name)
	if name then
		local file = session_name_to_path(name)
		if vim.fn.filereadable(file) == 1 then
			vim.cmd("%bd!")
			vim.cmd("source " .. vim.fn.fnameescape(file))
			vim.notify("Session restored: " .. name, vim.log.levels.INFO, { title = "Sessions" })
			return
		else
			vim.notify("Session not found: " .. name, vim.log.levels.ERROR, { title = "Sessions" })
			return
		end
	end

	local sessions = M.list_sessions()
	if #sessions == 0 then
		vim.notify("No saved sessions found.", vim.log.levels.WARN, { title = "Sessions" })
		return
	end

	local current_encoded = cwd_to_session_name()
	table.sort(sessions, function(a, b)
		if a.name == current_encoded then
			return true
		end
		if b.name == current_encoded then
			return false
		end
		return a.display < b.display
	end)

	vim.ui.select(sessions, {
		prompt = "Select session to restore:",
		format_item = function(item)
			if item.name == current_encoded then
				return "󰁯 [Current Dir] " .. item.display
			end
			return "󰁯 " .. item.display
		end,
	}, function(choice)
		if choice then
			local file = session_name_to_path(choice.name)
			vim.cmd("%bd!")
			vim.cmd("source " .. vim.fn.fnameescape(file))
			vim.notify("Session restored: " .. choice.display, vim.log.levels.INFO, { title = "Sessions" })
		end
	end)
end

function M.delete_session()
	local sessions = M.list_sessions()
	if #sessions == 0 then
		vim.notify("No saved sessions found to delete.", vim.log.levels.WARN, { title = "Sessions" })
		return
	end

	vim.ui.select(sessions, {
		prompt = "Select session to delete:",
		format_item = function(item)
			return " " .. item.display
		end,
	}, function(choice)
		if choice then
			local file = session_name_to_path(choice.name)
			vim.fn.delete(file)
			vim.notify("Deleted session: " .. choice.display, vim.log.levels.INFO, { title = "Sessions" })
		end
	end)
end

function M.toggle_autosave()
	autosave_enabled = not autosave_enabled
	local status = autosave_enabled and "enabled" or "disabled"
	vim.notify("Session autosave on exit: " .. status, vim.log.levels.INFO, { title = "Sessions" })
end

function M.setup()
	ensure_dir()

	-- Commands
	vim.api.nvim_create_user_command("SessionSave", function(opts)
		local name = opts.args ~= "" and opts.args or nil
		M.save_session(name)
	end, { nargs = "?", desc = "Save Neovim session" })

	vim.api.nvim_create_user_command("SessionRestore", function(opts)
		local name = opts.args ~= "" and opts.args or nil
		M.restore_session(name)
	end, { nargs = "?", desc = "Restore Neovim session" })

	vim.api.nvim_create_user_command("SessionDelete", function()
		M.delete_session()
	end, { desc = "Delete a saved Neovim session" })

	vim.api.nvim_create_user_command("SessionToggleAutoSave", function()
		M.toggle_autosave()
	end, { desc = "Toggle session auto-save on exit" })

	-- Keymaps
	vim.keymap.set("n", "<leader>ws", function()
		M.save_session()
	end, { desc = "Save session for current directory" })

	vim.keymap.set("n", "<leader>wr", function()
		M.restore_session()
	end, { desc = "Search and restore session" })

	vim.keymap.set("n", "<leader>wa", function()
		M.toggle_autosave()
	end, { desc = "Toggle autosave session" })

	-- Autosave on exit if enabled
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("NativeSessionAutoSave", { clear = true }),
		callback = function()
			if autosave_enabled then
				-- Only save if there are actual buffers open
				local bufs = vim.fn.getbufinfo({ buflisted = 1 })
				if #bufs > 0 then
					M.save_session()
				end
			end
		end,
	})
end

return M
