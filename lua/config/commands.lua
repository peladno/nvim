-- lua/config/commands.lua
local compile = require("utils.compile")

-- Comando personalizado
vim.api.nvim_create_user_command("CompileC", function()
	compile.compile_current_c_file()
end, {})

-- Atajo de teclado
vim.keymap.set("n", "<leader>m", function()
	compile.compile_current_c_file()
end, { desc = "Compilar archivo C actual" })
