" Vim syntax file
" Language:		Wonkey / Monkey2
" Maintainer:	Danilo Krahn
" Last Change:	2021/03/08



if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

let b:current_syntax = "wonkey"

"
" Help:
"
" - http://vimdoc.sourceforge.net/htmldoc/syntax.html
"
" :h syn-define
" :h pattern-overview
"
"
" :h syn-sync
"
syntax sync fromstart
"syntax sync minlines=100
syntax sync maxlines=200

"
" :h syn-case
"
syntax case ignore

"
" :h syn-keyword
"
"
" Preprocessor
"
syntax match   Include      "#Import"
syntax match   PreCondit    "#.\+$"

"
" Strings
"
syntax region String start='"' end='"'

"
" Comments
"
syntax region Comment start="#rem" end="#end"
syntax match  Comment "'.*$"

"
" Keywords
"
syntax keyword Keyword      End Return Cast VarPtr
syntax keyword Keyword      Print
syntax keyword Keyword      Function Lambda Method Property Operator Setter Getter Field
syntax keyword Keyword      EndFunction EndLambda EndMethod EndProperty EndOperator
syntax keyword Keyword      Namespace Using
"syntax keyword Structure    Class Struct Interface Enum Extends Extension Implements Where
syntax keyword Keyword      Class Struct Interface Enum Extends Extension Implements Where
syntax keyword Keyword      EndClass EndStruct EndInterface EndEnum
syntax keyword Keyword      New Delete Super Self Null
syntax keyword Keyword      Abstract Virtual Override Final
syntax keyword Keyword      Friend Inline

"
" Access levels
"
syntax keyword StorageClass Local Global Static
syntax keyword StorageClass Extern Public Private Protected Internal

"
" Const
"
syntax keyword Const        Const

"
" Debug Statements/Functions
"
syntax keyword Debug        Assert DebugAssert RuntimeError DebugStop GetDebugStack

"
" Conditional and Loop Statements
"
syntax keyword Conditional  If Then Else ElseIf EndIf
syntax keyword Conditional  Select EndSelect
syntax keyword Repeat       For EndFor To Step Until Next EachIn
syntax keyword Repeat       While Wend EndWhile
syntax keyword Repeat       Repeat Forever
syntax keyword Repeat       Exit Continue
syntax keyword Label        Case Default

"
" Operators and Delimiters
"
syntax match   Delimiter    "[\;\.\:\,]"
syntax match   Operator     "[\+\-\*\/\?\|\~\&\>\<\=\[\]]"
syntax match   Operator     ":="
syntax keyword Keyword      And Or Not
syntax keyword Keyword      Mod Shr Shl

"
" Exception handling
"
syntax keyword Exception    Try EndTry Catch Throw
"
" Reflection
"
syntax keyword Keyword      TypeInfo Typeof 

"
" Identifiers / Variable names
"
syntax match   Identifier   "\<[a-zA-Z_][a-zA-Z0-9_]*"

"
" Function and Method Calls
"
"syntax match Function       "\<[a-zA-Z_][a-zA-Z0-9_]*[(]+"
"syntax match Function       "\<\w\+("
"
" procName(
"
"syntax match Function       "\zs\(\k\w*\)*\s*\ze("
"
" procName:Type(
"
syntax match Function       "\zs\(\k\w*\)*\s*\ze\([:]\+\w\+\)\=("
syntax match Operator       "[()]"

"
" Decimal numbers
"
syntax match   Number       "\d\+"
"
" Hex numbers
"
syntax match   Number       "$\x\+"
"
" Floating Point numbers
"
syntax match   Float        "\d\+\.\d\+\([eE][-+]\=\d\+\)\="
syntax match   Float        "\.\d\+\([eE][-+]\=\d\+\)\="

"
" Data Types
"
syntax keyword Boolean      True False
syntax keyword Type         Void Ptr
syntax keyword Type         Object Throwable WeakRef Variant String CString WString
syntax keyword Type         Bool Byte UByte Short UShort Int UInt Long ULong
syntax keyword Type         Float Double
syntax match   Type         "[:][a-zA-Z_][a-zA-Z0-9_]*"
syntax keyword Typedef      Alias

"
" std.collections...
"
syntax keyword Type         IContainer IIterator
syntax keyword Type         Deque IntDeque FloatDeque StringDeque
syntax keyword Type         List  IntList  FloatList  StringList
syntax keyword Type         Map   IntMap   FloatMap   StringMap
syntax keyword Type         Stack IntStack FloatStack StringStack

"
" wake compiler function
"
function! s:WakeRun()
	"
	" read first 20 lines and search for lines starting with:
	"
	" '%option
	"
	let l:opt = ""
	let l:lines = getbufline(bufnr('%'), 1, 20)
	for l:line in lines
		let l:line = tolower(l:line)
		if strpart(l:line,0,8) == "'%option"
			let l:opt .= " " . strpart(l:line,8)
		endif
	endfor
	"
	" run wake compiler and redirect the output to the Quickfix window
	"
	let l:file = "\"" . expand("%:p") . "\""
	redir => l:wake_output
	silent execute "!wake app -run " . l:opt . " " . l:file
	redir END
	copen
	let l:msg = split(l:wake_output,'\n')
	let l:msg = l:msg[2:]
	cexpr l:msg
endfunction

"
" Wake command
"
command! Wake call s:WakeRun()

"
" Save and Compile current file using F5
"
" modes nvo
noremap  <F5> <ESC>:w<CR>:Wake<CR>
" modes ic
noremap! <F5> <ESC>:w<CR>:Wake<CR>

