return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			compile = false,
			transparent = true,
			theme = "wave",
		})
		vim.cmd("colorscheme kanagawa")
	end,
	build = function()
		vim.cmd("KanawagaCompile")
	end,
}
