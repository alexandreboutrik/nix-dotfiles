vim.filetype.add({
	extension = {
		v = "coq",
		rocq = "coq",
	}
})

local coq_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/coq.vim"

if vim.fn.isdirectory(coq_path) == 0 then
	vim.notify("coq.vim not found. Downloading via git...", vim.log.levels.INFO)
	
	vim.fn.system({
		"git",
		"clone",
		"--depth", "1",
		"https://github.com/jvoorhis/coq.vim.git",
		coq_path,
	})
	
	vim.cmd("packadd coq.vim")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "coq",
	desc = "Conceal Rocq/Coq syntax with Unicode characters",
	callback = function()
		-- vim.schedule ensures this runs AFTER the event loop clears,
		-- guaranteeing no other plugins can wipe out the rules.
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			vim.cmd([[
				" Clear custom matches on reload to prevent stacking
				silent! syntax clear CoqRightArrow CoqFatRightArrow CoqLeftArrow CoqForall CoqExists CoqSub0 CoqSub1 CoqSub2 CoqSub3 CoqSub4 CoqSub5 CoqSub6 CoqSub7 CoqSub8 CoqSub9

				" Arrows & Mappings
				syntax match CoqRightArrow /\(<\||\)\@<!->/ containedin=ALL conceal cchar=→
				syntax match CoqLeftArrow /<-\(>\|\)\@!/ containedin=ALL conceal cchar=←
				syntax match CoqFatRightArrow /=>/ containedin=ALL conceal cchar=⇒
				syntax match CoqIff /<->/ containedin=ALL conceal cchar=↔
				syntax match CoqMapsTo /|->/ containedin=ALL conceal cchar=↦
			
				" Math / Logic
				syntax match CoqForall /\<forall\>/ containedin=ALL conceal cchar=∀
				syntax match CoqExists /\<exists\>/ containedin=ALL conceal cchar=∃
				syntax match CoqAnd #/\\# containedin=ALL conceal cchar=∧
				syntax match CoqOr #\\/# containedin=ALL conceal cchar=∨
				syntax match CoqNot #\~# containedin=ALL conceal cchar=¬
				syntax match CoqTrue /\<True\>/ containedin=ALL conceal cchar=⊤
				syntax match CoqFalse /\<False\>/ containedin=ALL conceal cchar=⊥

				" Relations & Operators
				syntax match CoqNeq /<>/ containedin=ALL conceal cchar=≠
				syntax match CoqLe /<=/ containedin=ALL conceal cchar=≤
				syntax match CoqGe />=/ containedin=ALL conceal cchar=≥
				syntax match CoqAssign /:=/ containedin=ALL conceal cchar=≔
				syntax match CoqConcat /++/ containedin=ALL conceal cchar=⧺
				syntax match CoqTurnstile /|-/ containedin=ALL conceal cchar=⊢

				" Types & Universes
				syntax match CoqFun /\<fun\>/ containedin=ALL conceal cchar=λ
				syntax match CoqProp /\<Prop\>/ containedin=ALL conceal cchar=ℙ
				syntax match CoqSet /\<Set\>/ containedin=ALL conceal cchar=𝕊
				syntax match CoqType /\<Type\>/ containedin=ALL conceal cchar=𝕋
				syntax match CoqNat /\<nat\>/ containedin=ALL conceal cchar=ℕ
				syntax match CoqBool /\<bool\>/ containedin=ALL conceal cchar=𝔹

				" Dynamic Subscripts
				syntax match CoqSub0 /\(\<[a-zA-Z_]\w*\)\@<=0/ containedin=ALL conceal cchar=₀
				syntax match CoqSub1 /\(\<[a-zA-Z_]\w*\)\@<=1/ containedin=ALL conceal cchar=₁
				syntax match CoqSub2 /\(\<[a-zA-Z_]\w*\)\@<=2/ containedin=ALL conceal cchar=₂
				syntax match CoqSub3 /\(\<[a-zA-Z_]\w*\)\@<=3/ containedin=ALL conceal cchar=₃
				syntax match CoqSub4 /\(\<[a-zA-Z_]\w*\)\@<=4/ containedin=ALL conceal cchar=₄
				syntax match CoqSub5 /\(\<[a-zA-Z_]\w*\)\@<=5/ containedin=ALL conceal cchar=₅
				syntax match CoqSub6 /\(\<[a-zA-Z_]\w*\)\@<=6/ containedin=ALL conceal cchar=₆
				syntax match CoqSub7 /\(\<[a-zA-Z_]\w*\)\@<=7/ containedin=ALL conceal cchar=₇
				syntax match CoqSub8 /\(\<[a-zA-Z_]\w*\)\@<=8/ containedin=ALL conceal cchar=₈
				syntax match CoqSub9 /\(\<[a-zA-Z_]\w*\)\@<=9/ containedin=ALL conceal cchar=₉
			]])
		end)
	end,
})
