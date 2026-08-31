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

local ok, ts = pcall(require, "nvim-treesitter")

if not ok then
	vim.notify("Tree-sitter failed to load. Reason:\n" .. tostring(configs_or_err), vim.log.levels.ERROR)
	return
end

ts.install({ 
	"c", "lua", "vim", "vimdoc", "query", 
	"haskell", "python", "rust", "go", "bash", "java",
	"markdown", "markdown_inline"
}, { summary = false })

vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		-- Replaces `disable = { "coq" }`
		if event.match == "coq" then 
			return 
		end
		
		-- Replaces `auto_install = true`
		pcall(ts.install, { event.match }, { summary = false })
		
		-- Replaces `highlight = { enable = true }` with Neovim's native engine
		pcall(vim.treesitter.start, event.buf)
		
		-- Replaces `indent = { enable = true }`
		vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
