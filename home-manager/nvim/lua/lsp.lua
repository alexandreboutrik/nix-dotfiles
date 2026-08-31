-- lsp
vim.lsp.enable({ 
    "lua_ls",					-- lua
    "tsgo",						-- typescript
    "clangd",					-- c
    "jdtls",					-- java
    "pyright",				-- python
    "rust_analyzer",	-- rust
    "bashls",					-- bash
    "hls",						-- haskell
    "gopls",					-- go
		"dafny",					-- dafny
		"coq_lsp",				-- rocq/coq
		"isabelle",				-- isabelle/hol
		"tinymist"				-- typst
})
vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect")
