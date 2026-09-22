local M = {}

function M.setup()
	-- Neovim 0.10+ includes built-in commenting with `gc`, `gcc`, `gb`, `gbc`.
	-- Here we ensure accurate commentstring formats across common languages.
	local ft_comments = {
		c = "// %s",
		cpp = "// %s",
		lua = "-- %s",
		python = "# %s",
		sh = "# %s",
		bash = "# %s",
		zsh = "# %s",
		javascript = "// %s",
		javascriptreact = "{/* %s */}",
		typescript = "// %s",
		typescriptreact = "{/* %s */}",
		html = "<!-- %s -->",
		css = "/* %s */",
		scss = "/* %s */",
		sql = "-- %s",
		json = "// %s",
		markdown = "<!-- %s -->",
		toml = "# %s",
		yaml = "# %s",
	}

	local group = vim.api.nvim_create_augroup("NativeCommentConfig", { clear = true })
	for ft, cs in pairs(ft_comments) do
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = ft,
			callback = function(args)
				if vim.bo[args.buf].commentstring == "" or vim.bo[args.buf].commentstring == "/*%s*/" then
					vim.bo[args.buf].commentstring = cs
				end
			end,
		})
	end
end

return M
