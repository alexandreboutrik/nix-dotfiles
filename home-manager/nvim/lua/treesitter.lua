local install_path = vim.fn.expand("~/.local/share/nvim/site/pack/plugins/start/nvim-treesitter")

if vim.fn.isdirectory(install_path) == 0 then
	vim.notify("Tree-sitter not found. Downloading via git...", vim.log.levels.INFO)
	
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/nvim-treesitter/nvim-treesitter.git",
		install_path,
	})
end

vim.opt.rtp:prepend(install_path)

local ok, configs_or_err = pcall(require, "nvim-treesitter.configs")

if not ok then
	vim.notify("Tree-sitter failed to load. Reason:\n" .. tostring(configs_or_err), vim.log.levels.ERROR)
	return
end

configs_or_err.setup({
	ensure_installed = { 
		"c", "lua", "vim", "vimdoc", "query", 
		"haskell", "python", "rust", "go", "bash", "java",
		"markdown", "markdown_inline"
	},
	
	auto_install = true, 

	highlight = {
		enable = true,
		disable = { "coq" },
		additional_vim_regex_highlighting = { "c", "cpp" },
	},
	indent = {
		enable = true,
	},
})
