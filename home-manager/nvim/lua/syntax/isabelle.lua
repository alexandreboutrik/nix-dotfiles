vim.filetype.add({
	extension = {
		thy = "isabelle",
	}
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "isabelle",
	desc = "Conceal Isabelle/HOL syntax with Unicode characters",
	callback = function()
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			vim.cmd([[
				" Clear custom matches on reload to prevent stacking
				silent! syntax clear IsaRightArrow IsaFatRightArrow IsaLongRightArrow IsaLongFatRightArrow IsaLeftArrow IsaLongLeftArrow IsaIff IsaLongIff IsaForall IsaExists IsaAnd IsaOr IsaNot IsaEquiv IsaIn IsaNotIn IsaUnion IsaInter IsaSubsetEq IsaSubset IsaNeq IsaLe IsaGe IsaTimes IsaLBrace IsaRBrace IsaLBracket IsaRBracket IsaLambda IsaPercent

				" Arrows
				syntax match IsaRightArrow /-->/ containedin=ALL conceal cchar=⟶
				syntax match IsaFatRightArrow /=>/ containedin=ALL conceal cchar=⇒
				syntax match IsaLongRightArrow /\\<longrightarrow>/ containedin=ALL conceal cchar=⟶
				syntax match IsaLongFatRightArrow /\\<Rightarrow>/ containedin=ALL conceal cchar=⇒
				syntax match IsaLeftArrow /<--/ containedin=ALL conceal cchar=⟵
				syntax match IsaLongLeftArrow /\\<longleftarrow>/ containedin=ALL conceal cchar=⟵
				syntax match IsaIff /<->/ containedin=ALL conceal cchar=⟷
				syntax match IsaLongIff /\\<longleftrightarrow>/ containedin=ALL conceal cchar=⟷

				" Logic
				syntax match IsaForall /\\<forall>/ containedin=ALL conceal cchar=∀
				syntax match IsaExists /\\<exists>/ containedin=ALL conceal cchar=∃
				syntax match IsaAnd /\\<and>/ containedin=ALL conceal cchar=∧
				syntax match IsaOr /\\<or>/ containedin=ALL conceal cchar=∨
				syntax match IsaNot /\\<not>/ containedin=ALL conceal cchar=¬
				syntax match IsaEquiv /\\<equiv>/ containedin=ALL conceal cchar=≡

				" Math / Sets / Relations
				syntax match IsaIn /\\<in>/ containedin=ALL conceal cchar=∈
				syntax match IsaNotIn /\\<notin>/ containedin=ALL conceal cchar=∉
				syntax match IsaUnion /\\<union>/ containedin=ALL conceal cchar=∪
				syntax match IsaInter /\\<inter>/ containedin=ALL conceal cchar=∩
				syntax match IsaSubsetEq /\\<subseteq>/ containedin=ALL conceal cchar=⊆
				syntax match IsaSubset /\\<subset>/ containedin=ALL conceal cchar=⊂
				syntax match IsaNeq /\\<noteq>/ containedin=ALL conceal cchar=≠
				syntax match IsaLe /\\<le>/ containedin=ALL conceal cchar=≤
				syntax match IsaGe /\\<ge>/ containedin=ALL conceal cchar=≥
				syntax match IsaTimes /\\<times>/ containedin=ALL conceal cchar=×

				" Program Logic (AutoCorres / Separation Logic)
				syntax match IsaLBrace /\\<lbrace>/ containedin=ALL conceal cchar=⦃
				syntax match IsaRBrace /\\<rbrace>/ containedin=ALL conceal cchar=⦄
				syntax match IsaLBracket /\\<lbrakk>/ containedin=ALL conceal cchar=⟦
				syntax match IsaRBracket /\\<rbrakk>/ containedin=ALL conceal cchar=⟧
				
				" Functions / Lambda
				syntax match IsaLambda /\\<lambda>/ containedin=ALL conceal cchar=λ
				syntax match IsaPercent /%/ containedin=ALL conceal cchar=λ
			]])
		end)
	end,
})
