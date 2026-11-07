vim.filetype.add({
	extension = {
		jazz = "jasmin",
		jinc = "jasmin",
		jahh = "jasmin",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "jasmin",
	desc = "Native syntax highlighting and Unicode conceals for the Jasmin language",
	callback = function()
		vim.schedule(function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"
			vim.bo.commentstring = "// %s"

			vim.cmd([[
				syntax case match

				" Prevent sync loss on long Jasmin procedures
				syntax sync minlines=250

				" Comments & Literals (Conceal-exempt regions)
				syntax keyword jasminTodo contained TODO FIXME XXX NOTE
				syntax region  jasminCommentBlock start="/\*" end="\*/" contains=jasminTodo,@Spell
				syntax match   jasminCommentLine  "//.*$" contains=jasminTodo,@Spell
				syntax region  jasminString start=+"+ skip=+\\\\\|\\"+ end=+"+

				" Directives & Structure
				syntax keyword jasminInclude   require from
				syntax keyword jasminStructure param global type namespace
				syntax keyword jasminKeyword   fn export

				" Control Flow & Keywords
				syntax keyword jasminConditional if else
				syntax keyword jasminRepeat      while for to downto
				syntax keyword jasminStatement   return
				syntax keyword jasminBuiltin     assert ArrayInit

				" Storage Qualifiers & Modifiers
				syntax keyword jasminStorageClass reg stack inline ptr const mut

				" Scalar & Word Types
				syntax keyword jasminType int bool msf
				syntax keyword jasminType u8 u16 u32 u64 u128 u256
				syntax keyword jasminType i8 i16 i32 i64 i128 i256
				syntax keyword jasminType ui8 ui16 ui32 ui64 si8 si16 si32 si64

				" Vector Casts & Word Specifiers
				syntax match   jasminCast "\<\d\+[us]\d*\>"

				" Literals
				syntax keyword jasminBoolean true false
				syntax match   jasminNumber  "\<\d[0-9_]*\>"
				syntax match   jasminNumber  "\<0[xX][0-9a-fA-F_]\+\>"
				syntax match   jasminNumber  "\<0[bB][01_]\+\>"

				" Attributes & Architecture Intrinsics
				syntax region  jasminAttribute start="#\[" end="\]" contains=jasminString,jasminNumber
				syntax match   jasminIntrinsic "#[A-Za-z_][A-Za-z0-9_]*"
				syntax match   jasminFunction  "\<\(fn\)\>\s\+\zs[A-Za-z_][A-Za-z0-9_]*"

				" ====================================================================
				" Unicode & Math Conceals (avoiding comments and strings)
				" ====================================================================
				syntax cluster JasminConcealExempt contains=jasminCommentBlock,jasminCommentLine,jasminString

				" Logic & Bitwise
				syntax match JasminAnd  /&&/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=∧
				syntax match JasminOr   /||/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=∨
				syntax match JasminXor  /\^/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=⊕
				syntax match JasminNot  /!\([=]\)\@!/       containedin=ALLBUT,@JasminConcealExempt conceal cchar=¬

				" Relations & Comparisons
				syntax match JasminEq   /\s\zs==\ze\s/      containedin=ALLBUT,@JasminConcealExempt conceal cchar=≡
				syntax match JasminNeq  /!=/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=≠
				syntax match JasminLe   /<=/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=≤
				syntax match JasminGe   />=/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=≥

				" Arrows & Bit Shifts
				syntax match JasminTo   /->/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=→
				syntax match JasminShl  /<</                containedin=ALLBUT,@JasminConcealExempt conceal cchar=≪
				syntax match JasminShr  />>/                containedin=ALLBUT,@JasminConcealExempt conceal cchar=≫
				syntax match JasminMul  /\s\zs\*\ze\s/      containedin=ALLBUT,@JasminConcealExempt conceal cchar=×

				" Highlight Linking
				highlight default link jasminTodo         Todo
				highlight default link jasminCommentBlock Comment
				highlight default link jasminCommentLine  Comment
				highlight default link jasminString       String
				highlight default link jasminInclude      Include
				highlight default link jasminStructure    Structure
				highlight default link jasminKeyword      Keyword
				highlight default link jasminConditional  Conditional
				highlight default link jasminRepeat       Repeat
				highlight default link jasminStatement    Statement
				highlight default link jasminBuiltin      Special
				highlight default link jasminStorageClass StorageClass
				highlight default link jasminType         Type
				highlight default link jasminCast         Type
				highlight default link jasminBoolean      Boolean
				highlight default link jasminNumber       Number
				highlight default link jasminAttribute    PreProc
				highlight default link jasminIntrinsic    Special
				highlight default link jasminFunction     Function

				" Conceal Highlight Links
				highlight default link JasminAnd          Operator
				highlight default link JasminOr           Operator
				highlight default link JasminXor          Operator
				highlight default link JasminNot          Operator
				highlight default link JasminEq           Operator
				highlight default link JasminNeq          Operator
				highlight default link JasminLe           Operator
				highlight default link JasminGe           Operator
				highlight default link JasminTo           Operator
				highlight default link JasminShl          Operator
				highlight default link JasminShr          Operator
				highlight default link JasminMul          Operator
			]])
		end)
	end,
})
