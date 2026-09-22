return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons",
	},
	ft = { "markdown" },
	opts = {
		heading = {
			enabled = true,
			sign = true,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		code = {
			enabled = true,
			sign = true,
			style = "full",
			position = "left",
		},
		bullet = {
			enabled = true,
		},
		checkbox = {
			enabled = true,
		},
		pipe_table = {
			enabled = true,
			style = "full",
		},
	},
	init = function()
		-- Configure tree-sitter-grammars/tree-sitter-markdown parser URLs
		local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok_parsers then
			local parser_config = parsers.get_parser_configs()

			parser_config.markdown = {
				install_info = {
					url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown",
					location = "tree-sitter-markdown",
					files = { "src/parser.c", "src/scanner.c" },
				},
				maintainers = { "@MDeiml" },
				readme_name = "markdown",
			}

			parser_config.markdown_inline = {
				install_info = {
					url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown",
					location = "tree-sitter-markdown-inline",
					files = { "src/parser.c", "src/scanner.c" },
				},
				maintainers = { "@MDeiml" },
				readme_name = "markdown_inline",
			}
		end

		-- Custom User Commands for Markdown
		vim.api.nvim_create_user_command("MarkdownToggle", function()
			require("render-markdown").toggle()
		end, { desc = "Toggle visual Markdown rendering" })

		vim.api.nvim_create_user_command("MarkdownPreview", function()
			require("render-markdown").toggle()
		end, { desc = "Preview / Toggle visual Markdown rendering" })

		vim.api.nvim_create_user_command("MarkdownInstall", function()
			vim.cmd("TSInstall markdown markdown_inline")
		end, { desc = "Install tree-sitter-markdown grammars" })

		vim.api.nvim_create_user_command("MarkdownUpdate", function()
			vim.cmd("TSUpdate markdown markdown_inline")
		end, { desc = "Update tree-sitter-markdown grammars" })
	end,
	keys = {
		{
			"<leader>tm",
			function()
				require("render-markdown").toggle()
			end,
			ft = "markdown",
			desc = "[T]oggle [M]arkdown rendering",
		},
	},
}

