vim.filetype.add({
	extension = {
		dfy = "dafny",
	}
})

local dafny_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/vim-loves-dafny"

if vim.fn.isdirectory(dafny_path) == 0 then
	vim.notify("vim-loves-dafny not found. Downloading via git...", vim.log.levels.INFO)
	
	vim.fn.system({
		"git",
		"clone",
		"--depth", "1",
		"https://github.com/mlr-msft/vim-loves-dafny.git",
		dafny_path,
	})
	
	-- Force Neovim to load the package immediately 
	vim.cmd("packadd vim-loves-dafny")
end
