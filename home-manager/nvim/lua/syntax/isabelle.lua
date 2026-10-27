vim.filetype.add({
	extension = {
		thy = "isabelle",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "isabelle",
	desc = "Syntax highlighting and mathematical conceal for Isabelle/HOL",
	callback = function()
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			vim.cmd([[
				syntax clear

				" Comments, Strings & Cartouches
				syntax region isaComment start="(\*" end="\*)" contains=isaComment,@Spell extend keepend
				syntax region isaString  start=/"/ skip=/\\"/ end=/"/ contains=@isaConceals
				syntax region isaCartouche start=/\\<open>\|‹/ end=/\\<close>\|›/ contains=@isaConceals

				" Language Keywords & Structure
				syntax keyword isaTheoryHeader theory imports begin end context locale
				syntax keyword isaSection      chapter section subsection subsubsection text txt
				syntax keyword isaDeclaration  definition abbreviation fun primrec record datatype
				syntax keyword isaDeclaration  type_synonym axiomatization where
				syntax keyword isaTheorem      lemma theorem corollary proposition schematic_goal
				syntax keyword isaTheoremSpec  assumes shows obtains
				syntax keyword isaProof        proof qed by done oops sorry apply subgoal defer prefer
				syntax keyword isaIsar         fix assume have show hence thus with from using
				syntax keyword isaIsar         unfolding including define obtain moreover ultimately
				syntax keyword isaIsar         also finally note interpret case cases next let
				syntax keyword isaMethod       simp auto blast fastforce force clarify clarsimp
				syntax keyword isaMethod       rule erule drule frule intro elim dest subst induct
				syntax keyword isaMethod       coinduct unfold fold

				syntax keyword isaType         nat int real bool list set option char string unit

				" Unicode Conceals (ASCII & Isabelle Tokens)

				" Quantifiers (ASCII + Escape)
				syntax match isaForall /\<ALL\>/ containedin=ALL conceal cchar=∀
				syntax match isaForall /\\<forall>/ containedin=ALL conceal cchar=∀
				syntax match isaExists /\<EX\>/ containedin=ALL conceal cchar=∃
				syntax match isaExists /\\<exists>/ containedin=ALL conceal cchar=∃
				syntax match isaExistsExcl /\\<exists>!/ containedin=ALL conceal cchar=∄

				" Logic Operators
				syntax match isaAnd    /\s\zs&\ze\s/ containedin=ALL conceal cchar=∧
				syntax match isaAnd    /\\<and>/     containedin=ALL conceal cchar=∧
				syntax match isaOr     /\s\zs|\ze\s/ containedin=ALL conceal cchar=∨
				syntax match isaOr     /\\<or>/      containedin=ALL conceal cchar=∨
				syntax match isaNot    /\~[=]\@!/    containedin=ALL conceal cchar=¬
				syntax match isaNot    /\\<not>/     containedin=ALL conceal cchar=¬
				syntax match isaTrue   /\\<top>/     containedin=ALL conceal cchar=⊤
				syntax match isaFalse  /\\<bot>/     containedin=ALL conceal cchar=⊥

				" Connectives & Implications
				syntax match isaImp      /-->/                 containedin=ALL conceal cchar=⟶
				syntax match isaImp      /\\<longrightarrow>/  containedin=ALL conceal cchar=⟶
				syntax match isaFatImp   /==>/                 containedin=ALL conceal cchar=⟹
				syntax match isaFatImp   /\\<Longrightarrow>/  containedin=ALL conceal cchar=⟹
				syntax match isaLeftImp  /<--/                 containedin=ALL conceal cchar=⟵
				syntax match isaLeftImp  /\\<longleftarrow>/   containedin=ALL conceal cchar=⟵
				syntax match isaIff      /<->/                 containedin=ALL conceal cchar=⟷
				syntax match isaIff      /\\<longleftrightarrow>/ containedin=ALL conceal cchar=⟷
				syntax match isaMetaEq   /==/                  containedin=ALL conceal cchar=≡
				syntax match isaMetaEq   /\\<equiv>/           containedin=ALL conceal cchar=≡

				" Relations & Comparisons
				syntax match isaNeq      /\~=/       containedin=ALL conceal cchar=≠
				syntax match isaNeq      /\\<noteq>/ containedin=ALL conceal cchar=≠
				syntax match isaLe       /<=/        containedin=ALL conceal cchar=≤
				syntax match isaLe       /\\<le>/    containedin=ALL conceal cchar=≤
				syntax match isaGe       />=/        containedin=ALL conceal cchar=≥
				syntax match isaGe       /\\<ge>/    containedin=ALL conceal cchar=≥

				" Sets & Arithmetic
				syntax match isaIn       /\\<in>/        containedin=ALL conceal cchar=∈
				syntax match isaNotIn    /\\<notin>/     containedin=ALL conceal cchar=∉
				syntax match isaUnion    /\\<union>/     containedin=ALL conceal cchar=∪
				syntax match isaInter    /\\<inter>/     containedin=ALL conceal cchar=∩
				syntax match isaSubsetEq /\\<subseteq>/  containedin=ALL conceal cchar=⊆
				syntax match isaSubset   /\\<subset>/    containedin=ALL conceal cchar=⊂
				syntax match isaTimes    /\\<times>/     containedin=ALL conceal cchar=×
				syntax match isaRange    /\.\./          containedin=ALL conceal cchar=‥

				" Brackets, Records & Cartouches
				syntax match isaRecOpen    /(|/           containedin=ALL conceal cchar=⦇
				syntax match isaRecClose   /|)/           containedin=ALL conceal cchar=⦄
				syntax match isaJudgOpen   /\[|/          containedin=ALL conceal cchar=⟦
				syntax match isaJudgClose  /|\]/          containedin=ALL conceal cchar=⟧
				syntax match isaLBrace     /\\<lbrace>/   containedin=ALL conceal cchar=⦃
				syntax match isaRBrace     /\\<rbrace>/   containedin=ALL conceal cchar=⦄
				syntax match isaCartOpen   /\\<open>/     containedin=ALL conceal cchar=‹
				syntax match isaCartClose  /\\<close>/    containedin=ALL conceal cchar=›
				syntax match isaLambda     /%/            containedin=ALL conceal cchar=λ
				syntax match isaLambda     /\\<lambda>/   containedin=ALL conceal cchar=λ
				syntax match isaBullet     /\\<bullet>/   containedin=ALL conceal cchar=∙

				" Cluster for containment in strings
				syntax cluster isaConceals contains=isaForall,isaExists,isaExistsExcl,isaAnd,isaOr,isaNot,isaTrue,isaFalse,isaImp,isaFatImp,isaLeftImp,isaIff,isaMetaEq,isaNeq,isaLe,isaGe,isaIn,isaNotIn,isaUnion,isaInter,isaSubsetEq,isaSubset,isaTimes,isaRange,isaRecOpen,isaRecClose,isaJudgOpen,isaJudgClose,isaLBrace,isaRBrace,isaCartOpen,isaCartClose,isaLambda,isaBullet

				" Highlight Group Links
				highlight default link isaComment      Comment
				highlight default link isaString       String
				highlight default link isaCartouche    String
				highlight default link isaTheoryHeader PreProc
				highlight default link isaSection      Title
				highlight default link isaDeclaration  Structure
				highlight default link isaTheorem      Keyword
				highlight default link isaTheoremSpec  Special
				highlight default link isaProof        Statement
				highlight default link isaIsar         Statement
				highlight default link isaMethod       Function
				highlight default link isaType         Type

				highlight default link isaForall       Operator
				highlight default link isaExists       Operator
				highlight default link isaExistsExcl   Operator
				highlight default link isaAnd          Operator
				highlight default link isaOr           Operator
				highlight default link isaNot          Operator
				highlight default link isaTrue         Constant
				highlight default link isaFalse        Constant
				highlight default link isaImp          Operator
				highlight default link isaFatImp       Operator
				highlight default link isaLeftImp      Operator
				highlight default link isaIff          Operator
				highlight default link isaMetaEq       Operator
				highlight default link isaNeq          Operator
				highlight default link isaLe           Operator
				highlight default link isaGe           Operator
				highlight default link isaIn           Operator
				highlight default link isaNotIn        Operator
				highlight default link isaUnion        Operator
				highlight default link isaInter        Operator
				highlight default link isaSubsetEq     Operator
				highlight default link isaSubset       Operator
				highlight default link isaTimes        Operator
				highlight default link isaRange        Delimiter
				highlight default link isaRecOpen      Delimiter
				highlight default link isaRecClose     Delimiter
				highlight default link isaJudgOpen     Delimiter
				highlight default link isaJudgClose    Delimiter
				highlight default link isaLBrace       Delimiter
				highlight default link isaRBrace       Delimiter
				highlight default link isaCartOpen     Delimiter
				highlight default link isaCartClose    Delimiter
				highlight default link isaLambda       Special
				highlight default link isaBullet       Special
			]])
		end)
	end,
})
