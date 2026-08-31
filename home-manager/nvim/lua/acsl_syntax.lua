vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	desc = "Conceal ACSL annotations for Frama-C in C files",
	callback = function()
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			vim.cmd([[
				" Define regions strictly for ACSL comments
				syntax region AcslBlock start=/\/\*@/ end=/\*\// contains=@AcslGroup keepend extend
				syntax region AcslLine  start=/\/\/@/  end=/$/   contains=@AcslGroup keepend

				" Ensure comments keep normal comment coloring
				highlight default link AcslBlock Comment
				highlight default link AcslLine Comment

				" Group all ACSL conceal tokens
				syntax cluster AcslGroup contains=AcslForall,AcslExists,AcslImplies,AcslIff,AcslAnd,AcslOr,AcslNot,AcslTrue,AcslFalse,AcslNothing,AcslEmpty,AcslLe,AcslGe,AcslNeq,AcslRange,AcslInteger,AcslReal,AcslBoolean,AcslSub0,AcslSub1,AcslSub2,AcslSub3,AcslSub4,AcslSub5,AcslSub6,AcslSub7,AcslSub8,AcslSub9,AcslValid,AcslValidRead,AcslSeparated,AcslInitialized,AcslResult,AcslOld,AcslRequires,AcslEnsures,AcslAssigns,AcslInvariant,AcslVariant,AcslDecreases,AcslAllocates,AcslFrees

				" Logic & Quantifiers
				syntax match AcslForall /\\forall\>/ contained conceal cchar=∀
				syntax match AcslExists /\\exists\>/ contained conceal cchar=∃
				syntax match AcslImplies /==>/ contained conceal cchar=⇒
				syntax match AcslIff /<==>/ contained conceal cchar=⇔
				syntax match AcslAnd /&&/ contained conceal cchar=∧
				syntax match AcslOr /||/ contained conceal cchar=∨
				syntax match AcslNot /!\([=]\)\@!/ contained conceal cchar=¬
				syntax match AcslTrue /\\true\>/ contained conceal cchar=⊤
				syntax match AcslFalse /\\false\>/ contained conceal cchar=⊥
				syntax match AcslNothing /\\nothing\>/ contained conceal cchar=∅
				syntax match AcslEmpty /\\empty\>/ contained conceal cchar=∅

				" Relations & Ranges
				syntax match AcslLe /<=/ containedin=ALL conceal cchar=≤
				syntax match AcslGe />=/ containedin=ALL conceal cchar=≥
				syntax match AcslNeq /!=/ containedin=ALL conceal cchar=≠
				syntax match AcslRange /\.\./ contained conceal cchar=‥

				" Math
				syntax match AcslInteger /\<integer\>/ contained conceal cchar=ℤ
				syntax match AcslReal /\<real\>/ contained conceal cchar=ℝ
				syntax match AcslBoolean /\<boolean\>/ contained conceal cchar=𝔹

				" Dynamic Subscripts
				syntax match AcslSub9 /\(\<[a-zA-Z_]\w*\)\@<=9/ contained conceal cchar=₉

				syntax match AcslSub0 /\(\<[a-zA-Z_]\w*\)\@<=0/ contained conceal cchar=₀
				syntax match AcslSub1 /\(\<[a-zA-Z_]\w*\)\@<=1/ contained conceal cchar=₁
				syntax match AcslSub2 /\(\<[a-zA-Z_]\w*\)\@<=2/ contained conceal cchar=₂
				syntax match AcslSub3 /\(\<[a-zA-Z_]\w*\)\@<=3/ contained conceal cchar=₃
				syntax match AcslSub4 /\(\<[a-zA-Z_]\w*\)\@<=4/ contained conceal cchar=₄
				syntax match AcslSub5 /\(\<[a-zA-Z_]\w*\)\@<=5/ contained conceal cchar=₅
				syntax match AcslSub6 /\(\<[a-zA-Z_]\w*\)\@<=6/ contained conceal cchar=₆
				syntax match AcslSub7 /\(\<[a-zA-Z_]\w*\)\@<=7/ contained conceal cchar=₇
				syntax match AcslSub8 /\(\<[a-zA-Z_]\w*\)\@<=8/ contained conceal cchar=₈
				syntax match AcslSub9 /\(\<[a-zA-Z_]\w*\)\@<=9/ contained conceal cchar=₉
			]])
		end)
	end,
})
