local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })

local str = vim.api.nvim_get_hl(0, { name = "String", link = false }) -- Green-ish
local warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false }) -- Yellow-ish
local err = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false }) -- Red-ish

vim.api.nvim_set_hl(0, "StlNormal", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlInsert", { fg = pms.bg, bg = str.fg }) 
vim.api.nvim_set_hl(0, "StlVisual", { fg = pms.bg, bg = warn.fg }) 
vim.api.nvim_set_hl(0, "StlCommand", { fg = pms.bg, bg = err.fg })

vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

local mode_hls = {
	n = "StlNormal",
	i = "StlInsert",
	v = "StlVisual",
	V = "StlVisual",
	["\22"] = "StlVisual",
	c = "StlCommand",
	t = "StlCommand",
	R = "StlCommand",
	s = "StlVisual",
	S = "StlVisual",
	["\19"] = "StlVisual",
}

function _G._statusline()
	local m = vim.fn.mode()
	local mode = modes[m] or m:upper()
	
	-- Fallback to StlNormal if a weird mode is entered
	local mode_hl = mode_hls[m] or "StlNormal"

	local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
	local path = vim.b.rel_path or "%f"

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local labels = { " ", " ", " ", " " }
	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end

	-- Inject the dynamic mode_hl variable here instead of the
	-- hardcoded StlMode
	return "%#" .. mode_hl .. "# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c"
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
		if root ~= "" then
			vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
			vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2)
		else
			vim.b.git_branch = nil
			vim.b.rel_path = vim.fn.expand("%:p:~")
		end
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"
