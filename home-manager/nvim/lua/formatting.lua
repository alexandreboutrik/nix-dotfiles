local M = {}

-- Tools that format via standard input/output (runs BEFORE save)
M.stdin_formatters = {
	lua = "stylua -",
	nix = "nixpkgs-fmt",
	javascript = "prettier --stdin-filepath %",
	typescript = "prettier --stdin-filepath %",
	typescriptreact = "prettier --stdin-filepath %",
	json = "prettier --stdin-filepath %",
	python = "black -", 
	sh = "shfmt -",
	haskell = "fourmolu --quiet --stdin-input-file %",
	go = "gofmt",
}

-- Tools that format the actual files on disk (runs AFTER save)
M.project_formatters = {
	java = "mvn spotless:apply",
	rust = "cargo fmt",
}

-- Pre-save event: Handle standard input formatters & LSP fallback
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		local cmd = M.stdin_formatters[ft]

		if cmd then
			-- Replace % with actual buffer path for tools that need it
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local resolved = cmd:gsub("%%", bufname)

			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local input = table.concat(lines, "\n")

			local output = vim.fn.system(resolved, input)

			if vim.v.shell_error == 0 then
				local formatted = vim.split(output, "\n", { plain = true })
				-- Remove trailing empty line that shell commands often append
				if formatted[#formatted] == "" then
					table.remove(formatted)
				end
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
			end
		else
			-- No external formatter: try LSP (Handles C/clangd formatting)
			for _, cl in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
				if cl:supports_method("textDocument/formatting") then
					vim.lsp.buf.format({ bufnr = bufnr, async = false })
					break
				end
			end
		end
	end,
})

-- Post-save event: Handle project-wide formatters asynchronously
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		local cmd = M.project_formatters[ft]

		if cmd then
			vim.system(vim.split(cmd, " "), { text = true }, function(obj)
				if obj.code == 0 then
					vim.schedule(function()
						vim.cmd("checktime " .. bufnr)
					end)
				end
			end)
		end
	end,
})

return M
