local M = {}

function M.setup()
	require("native.maximizer").setup()
	require("native.comments").setup()
	require("native.statusline").setup()
	require("native.sessions").setup()
	require("native.autopairs").setup()
	require("native.ui_input").setup()
	require("native.explorer").setup()
end

return M

