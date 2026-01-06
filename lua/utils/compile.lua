-- lua/utils/compile.lua
local M = {}

function M.compile_current_c_file()
	local file = vim.fn.expand("%:p") -- Ruta completa del archivo actual
	local dir = vim.fn.expand("%:p:h") -- Carpeta del archivo actual
	local filename = vim.fn.expand("%:t:r") -- Nombre sin extensión
	local output = dir .. "/" .. filename -- Binario en la misma carpeta

	if vim.fn.expand("%:e") ~= "c" then
		print("⚠️ Este no es un archivo .c")
		return
	end

	print("🔧 Compilando " .. file .. " → " .. output)
	local cmd = string.format("gcc -g %s -o %s", file, output)
	local result = os.execute(cmd)

	if result == 0 then
		print("✅ Compilación exitosa: " .. output)
	else
		print("❌ Error al compilar " .. file)
	end
end

return M
