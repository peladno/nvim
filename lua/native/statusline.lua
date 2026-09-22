local M = {}

local modes = {
	["n"] = { name = "NORMAL", hl = "StatusLineNormal" },
	["no"] = { name = "O-PENDING", hl = "StatusLineNormal" },
	["nov"] = { name = "O-PENDING", hl = "StatusLineNormal" },
	["noV"] = { name = "O-PENDING", hl = "StatusLineNormal" },
	["no\22"] = { name = "O-PENDING", hl = "StatusLineNormal" },
	["niI"] = { name = "NORMAL", hl = "StatusLineNormal" },
	["niR"] = { name = "NORMAL", hl = "StatusLineNormal" },
	["niV"] = { name = "NORMAL", hl = "StatusLineNormal" },
	["nt"] = { name = "NORMAL", hl = "StatusLineNormal" },
	["v"] = { name = "VISUAL", hl = "StatusLineVisual" },
	["vs"] = { name = "VISUAL", hl = "StatusLineVisual" },
	["V"] = { name = "V-LINE", hl = "StatusLineVisual" },
	["Vs"] = { name = "V-LINE", hl = "StatusLineVisual" },
	["\22"] = { name = "V-BLOCK", hl = "StatusLineVisual" },
	["\22s"] = { name = "V-BLOCK", hl = "StatusLineVisual" },
	["s"] = { name = "SELECT", hl = "StatusLineVisual" },
	["S"] = { name = "S-LINE", hl = "StatusLineVisual" },
	["\19"] = { name = "S-BLOCK", hl = "StatusLineVisual" },
	["i"] = { name = "INSERT", hl = "StatusLineInsert" },
	["ic"] = { name = "INSERT", hl = "StatusLineInsert" },
	["ix"] = { name = "INSERT", hl = "StatusLineInsert" },
	["R"] = { name = "REPLACE", hl = "StatusLineReplace" },
	["Rc"] = { name = "REPLACE", hl = "StatusLineReplace" },
	["Rx"] = { name = "REPLACE", hl = "StatusLineReplace" },
	["Rv"] = { name = "V-REPLACE", hl = "StatusLineReplace" },
	["Rvc"] = { name = "V-REPLACE", hl = "StatusLineReplace" },
	["Rvx"] = { name = "V-REPLACE", hl = "StatusLineReplace" },
	["c"] = { name = "COMMAND", hl = "StatusLineCommand" },
	["cv"] = { name = "EX", hl = "StatusLineCommand" },
	["ce"] = { name = "EX", hl = "StatusLineCommand" },
	["r"] = { name = "PROMPT", hl = "StatusLineCommand" },
	["rm"] = { name = "MORE", hl = "StatusLineCommand" },
	["r?"] = { name = "CONFIRM", hl = "StatusLineCommand" },
	["!"] = { name = "SHELL", hl = "StatusLineCommand" },
	["t"] = { name = "TERMINAL", hl = "StatusLineInsert" },
}

local function get_git_branch()
	-- Check gitsigns or cached git branch
	if vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head then
		local head = vim.b.gitsigns_status_dict.head
		if head ~= "" then
			return "  " .. head .. " "
		end
	end

	if vim.b.git_branch then
		return vim.b.git_branch ~= "" and ("  " .. vim.b.git_branch .. " ") or ""
	end

	return ""
end

local function get_diagnostics()
	if not vim.diagnostic.is_enabled or not vim.diagnostic.is_enabled() then
		return ""
	end

	local counts = vim.diagnostic.count and vim.diagnostic.count(0)
	if not counts then
		return ""
	end

	local err = counts[vim.diagnostic.severity.ERROR] or 0
	local warn = counts[vim.diagnostic.severity.WARN] or 0
	local info = counts[vim.diagnostic.severity.INFO] or 0
	local hint = counts[vim.diagnostic.severity.HINT] or 0

	local parts = {}
	if err > 0 then
		table.insert(parts, "%#DiagnosticError# " .. err .. "%*")
	end
	if warn > 0 then
		table.insert(parts, "%#DiagnosticWarn# " .. warn .. "%*")
	end
	if info > 0 then
		table.insert(parts, "%#DiagnosticInfo# " .. info .. "%*")
	end
	if hint > 0 then
		table.insert(parts, "%#DiagnosticHint#󰌵 " .. hint .. "%*")
	end

	if #parts > 0 then
		return " " .. table.concat(parts, " ") .. " "
	end
	return ""
end

local function get_file_info()
	local file = vim.fn.expand("%:t")
	if file == "" then
		file = "[No Name]"
	end

	local flags = {}
	if vim.bo.modified then
		table.insert(flags, "%#StatusLineModified#[+]%*")
	end
	if vim.bo.readonly or not vim.bo.modifiable then
		table.insert(flags, "%#StatusLineRO#[RO]%*")
	end

	local flag_str = #flags > 0 and (" " .. table.concat(flags, "")) or ""
	return file .. flag_str
end

function M.render()
	local m = modes[vim.fn.mode()] or { name = "UNKNOWN", hl = "StatusLineNormal" }
	local mode_str = string.format("%%#%s# %s %%*", m.hl, m.name)
	local git_str = get_git_branch()
	local file_str = " " .. get_file_info()
	local diag_str = get_diagnostics()

	local filetype = vim.bo.filetype ~= "" and (" " .. vim.bo.filetype .. " ") or ""
	local encoding = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8") and (" " .. vim.bo.fileencoding .. " ") or ""
	local position = " %3l:%-2c  %P "

	return table.concat({
		mode_str,
		git_str ~= "" and ("%#StatusLineGit#" .. git_str .. "%*") or "",
		file_str,
		diag_str,
		"%=", -- Separator between left and right sections
		encoding ~= "" and ("%#StatusLineDim#" .. encoding .. "%*") or "",
		filetype ~= "" and ("%#StatusLineDim#" .. filetype .. "%*") or "",
		"%#StatusLinePos#" .. position .. "%*",
	})
end

function M.setup_highlights()
	-- Highlights designed to harmonize cleanly with Kanagawa and dark themes
	local set_hl = vim.api.nvim_set_hl
	set_hl(0, "StatusLineNormal", { fg = "#16161D", bg = "#7E9CD8", bold = true })
	set_hl(0, "StatusLineInsert", { fg = "#16161D", bg = "#98BB6C", bold = true })
	set_hl(0, "StatusLineVisual", { fg = "#16161D", bg = "#957FB8", bold = true })
	set_hl(0, "StatusLineReplace", { fg = "#16161D", bg = "#E46876", bold = true })
	set_hl(0, "StatusLineCommand", { fg = "#16161D", bg = "#FFA066", bold = true })
	set_hl(0, "StatusLineGit", { fg = "#7AA89F", bg = "#1F1F28", bold = true })
	set_hl(0, "StatusLineModified", { fg = "#E6C384", bold = true })
	set_hl(0, "StatusLineRO", { fg = "#E46876", bold = true })
	set_hl(0, "StatusLineDim", { fg = "#727169", bg = "#1F1F28" })
	set_hl(0, "StatusLinePos", { fg = "#DCD7BA", bg = "#2D4F67", bold = true })
end

function M.setup()
	M.setup_highlights()

	-- Update git branch on buffer enter or write
	local group = vim.api.nvim_create_augroup("NativeStatusLine", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
		group = group,
		callback = function(args)
			if vim.b[args.buf].git_branch == nil then
				local dir = vim.fn.expand("%:p:h")
				if dir ~= "" then
					vim.system({ "git", "-C", dir, "branch", "--show-current" }, { text = true }, function(obj)
						if obj.code == 0 and obj.stdout then
							local branch = vim.trim(obj.stdout)
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(args.buf) then
									vim.b[args.buf].git_branch = branch
								end
							end)
						end
					end)
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = M.setup_highlights,
	})

	vim.opt.statusline = "%!v:lua.require('native.statusline').render()"
end

return M
