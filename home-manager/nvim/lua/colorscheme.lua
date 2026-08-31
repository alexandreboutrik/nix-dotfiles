local install_path = vim.fn.stdpath("data") .. "/site/pack/themes/start/catppuccin"

if vim.fn.isdirectory(install_path) == 0 then
	vim.notify("Catppuccin not found. Downloading via git...", vim.log.levels.INFO)
	
	vim.fn.system({
		"git",
		"clone",
		"--depth", "1",
		"https://github.com/catppuccin/nvim.git",
		install_path,
	})
	
	-- Force Neovim to load the package immediately because native 'start'
	-- packages are normally loaded before init.lua runs
	vim.cmd("packadd catppuccin")
end

local ok, _ = pcall(vim.cmd.colorscheme, "catppuccin")

if ok then
	vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
else
	vim.notify("Error: Catppuccin failed to load.", vim.log.levels.ERROR)
end
