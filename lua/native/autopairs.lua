local M = {}

local bracket_pairs = {
	["("] = ")",
	["["] = "]",
	["{"] = "}",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
}

local closing = {
	[")"] = true,
	["]"] = true,
	["}"] = true,
	['"'] = true,
	["'"] = true,
	["`"] = true,
}

local function get_surrounding_chars()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed column
	local prev_char = col > 0 and line:sub(col, col) or ""
	local next_char = line:sub(col + 1, col + 1)
	return prev_char, next_char
end

function M.setup()
	-- Open pairs
	for open_char, close_char in pairs(bracket_pairs) do
		if open_char ~= close_char then
			-- Bracket pairs: ( [ {
			vim.keymap.set("i", open_char, function()
				local _, next_char = get_surrounding_chars()
				-- If followed by word character, just insert open char
				if next_char:match("[%w]") then
					return open_char
				end
				return open_char .. close_char .. "<Left>"
			end, { expr = true, noremap = true })

			-- Closing bracket jump-over: ) ] }
			vim.keymap.set("i", close_char, function()
				local _, next_char = get_surrounding_chars()
				if next_char == close_char then
					return "<Right>"
				end
				return close_char
			end, { expr = true, noremap = true })
		else
			-- Quotes: " ' `
			vim.keymap.set("i", open_char, function()
				local prev_char, next_char = get_surrounding_chars()
				-- Step over closing quote if right in front
				if next_char == open_char then
					return "<Right>"
				end
				-- Don't pair single quote in contractions (e.g. don't)
				if open_char == "'" and prev_char:match("[%w]") then
					return "'"
				end
				-- Don't pair if next is a word char
				if next_char:match("[%w]") then
					return open_char
				end
				return open_char .. open_char .. "<Left>"
			end, { expr = true, noremap = true })
		end
	end

	-- Smart Backspace: deletes pair if cursor is between () [] {} "" '' ``
	vim.keymap.set("i", "<BS>", function()
		local prev_char, next_char = get_surrounding_chars()
		if bracket_pairs[prev_char] and bracket_pairs[prev_char] == next_char then
			return "<BS><Del>"
		end
		return "<BS>"
	end, { expr = true, noremap = true })

	-- Smart Enter: expands {} into formatted block
	vim.keymap.set("i", "<CR>", function()
		local prev_char, next_char = get_surrounding_chars()
		if (prev_char == "{" and next_char == "}") or (prev_char == "(" and next_char == ")") or (prev_char == "[" and next_char == "]") then
			return "<CR><Esc>O"
		end
		return "<CR>"
	end, { expr = true, noremap = true })
end

return M
