vim.filetype.add({
	extension = {
		agda = "agda",
	}
})

-- Define the native package path
local agda_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/agda-vim"

-- Automatically fetch the syntax files if they are missing
if vim.fn.isdirectory(agda_path) == 0 then
	vim.notify("agda-vim not found. Downloading via git...", vim.log.levels.INFO)
	
	vim.fn.system({
		"git",
		"clone",
		"--depth", "1",
		"https://github.com/derekelkins/agda-vim.git",
		agda_path,
	})
	
	vim.cmd("packadd agda-vim")
end
