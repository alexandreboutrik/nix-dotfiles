vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	desc = "Conceal ACSL annotations for Frama-C in C files",
	callback = function()
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			vim.cmd([[
				" Prevent sync loss
				syntax sync minlines=250

				" Define regions strictly for ACSL comments
				syntax region AcslBlock start=/\/\*@/ end=/\*\// containedin=ALL contains=@AcslGroup transparent keepend extend
				syntax region AcslLine  start=/\/\/@/  end=/$/   containedin=ALL contains=@AcslGroup transparent keepend

				" Group all ACSL conceal tokens
				syntax cluster AcslGroup contains=AcslForall,AcslExists,AcslImplies,AcslIff,AcslAnd,AcslOr,AcslXor,AcslNot,AcslTrue,AcslFalse,AcslNothing,AcslEmpty,AcslLe,AcslGe,AcslNeq,AcslRange,AcslInteger,AcslReal,AcslBoolean,AcslUChar,AcslChar,AcslSub0,AcslSub1,AcslSub2,AcslSub3,AcslSub4,AcslSub5,AcslSub6,AcslSub7,AcslSub8,AcslSub9

				" Logic & Quantifiers
				syntax match AcslForall /\\forall\>/ contained conceal cchar=∀
				syntax match AcslExists /\\exists\>/ contained conceal cchar=∃
				syntax match AcslImplies /==>/ contained conceal cchar=⇒
				syntax match AcslIff /<==>/ contained conceal cchar=⇔
				syntax match AcslAnd /&&/ containedin=ALL conceal cchar=∧
				syntax match AcslOr /||/ containedin=ALL conceal cchar=∨
				syntax match AcslXor /\^/ containedin=ALL conceal cchar=⊕
				syntax match AcslNot /!\([=]\)\@!/ contained conceal cchar=¬
				syntax match AcslTrue /\\true\>/ contained conceal cchar=⊤
				syntax match AcslFalse /\\false\>/ contained conceal cchar=⊥
				syntax match AcslNothing /\\nothing\>/ contained conceal cchar=∅
				syntax match AcslEmpty /\\empty\>/ contained conceal cchar=∅

				" Relations & Ranges
				syntax match AcslAtr /\s\zs=\ze\s/ containedin=ALL conceal cchar=←
				syntax match AcslEq /\s\zs==\ze\s/ containedin=ALL conceal cchar==
				syntax match AcslLe /\s\zs<=\ze\s/ containedin=ALL conceal cchar=≤
				syntax match AcslGe /\s\zs>=\ze\s/ containedin=ALL conceal cchar=≥
				syntax match AcslNeq /!=/ containedin=ALL conceal cchar=≠
				syntax match AcslRange /\.\./ contained conceal cchar=‥

				" Math
				syntax match AcslInteger /\<integer\>/ contained conceal cchar=ℤ
				syntax match AcslInteger /\<int\>/ contained conceal cchar=ℤ
				syntax match AcslReal /\<real\>/ contained conceal cchar=ℝ
				syntax match AcslBoolean /\<boolean\>/ contained conceal cchar=𝔹
				syntax match AcslUChar /\<unsigned\s\+char\>/ contained conceal cchar=𝕌
				syntax match AcslChar /\<char\>/ contained conceal cchar=ℂ
			]])
		end)
	end,
})
