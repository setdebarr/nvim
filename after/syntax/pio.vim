" Vim syntax file
" Language:     RP2040/RP2350 PIO assembly (.pio)
" Maintainer:   you
" Filenames:    *.pio

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax case match

" ---------------------------------------------------------------------------
" Comments
" ---------------------------------------------------------------------------
syntax keyword pioTodo        contained TODO FIXME XXX NOTE
syntax match   pioComment     ";.*$"      contains=pioTodo,@Spell
syntax match   pioComment     "//.*$"     contains=pioTodo,@Spell
syntax region  pioComment     start="/\*" end="\*/" contains=pioTodo,@Spell

" ---------------------------------------------------------------------------
" Numbers
" ---------------------------------------------------------------------------
syntax match   pioNumber      "\<0[xX]\x\+\>"
syntax match   pioNumber      "\<0[bB][01]\+\>"
syntax match   pioNumber      "\<\d\+\>"

" ---------------------------------------------------------------------------
" Directives
" ---------------------------------------------------------------------------
syntax match   pioDirective   "^\s*\.\%(program\|define\|origin\|side_set\|wrap_target\|wrap\|lang_opt\|word\|pio_version\|clock_div\|fifo\|mov_status\)\>"
" .program <name>  /  .define <name>
syntax match   pioProgram     "^\s*\.program\s\+\zs\h\w*"
syntax match   pioDefineName  "^\s*\.define\s\+\%(PUBLIC\s\+\)\=\zs\h\w*"

" ---------------------------------------------------------------------------
" Instructions (mnemonics)
" ---------------------------------------------------------------------------
syntax keyword pioInstruction nop jmp wait in out push pull mov irq set

" ---------------------------------------------------------------------------
" Sub-keywords / flags / modifiers
" ---------------------------------------------------------------------------
syntax keyword pioKeyword     side opt PUBLIC
syntax keyword pioModifier    pindirs iffull ifempty block noblock rel next prev
syntax keyword pioModifier    nowait clear
" wait sources / irq targets
syntax keyword pioModifier    gpio jmppin

" Registers / pin groups (sources & destinations)
syntax keyword pioRegister    pins pin x y null isr osr pc exec status

" Branch / wait conditions for jmp
syntax match   pioCondition   "!x\|x--\|!y\|y--\|x!=y\|!osre\|\<pin\>"

" ---------------------------------------------------------------------------
" Labels:  name:   /  PUBLIC name:
" ---------------------------------------------------------------------------
syntax match   pioLabel       "^\s*\%(PUBLIC\s\+\)\=\zs\h\w*\ze\s*:"

" ---------------------------------------------------------------------------
" Side-set / delay  e.g.  side 1 [T1 - 1]
" ---------------------------------------------------------------------------
syntax region  pioDelay       matchgroup=pioDelimiter start="\[" end="\]" contains=pioNumber,pioOperator,pioIdentifier,pioRegister

" ---------------------------------------------------------------------------
" Operators (expression arithmetic, mov invert/reverse)
" ---------------------------------------------------------------------------
syntax match   pioOperator    "::\|<<\|>>\|[-+*/|&^~!()]"

" ---------------------------------------------------------------------------
" Highlight links
" ---------------------------------------------------------------------------
highlight default link pioComment     Comment
highlight default link pioTodo        Todo
highlight default link pioNumber      Number
highlight default link pioDirective   PreProc
highlight default link pioProgram     Function
highlight default link pioDefineName  Constant
highlight default link pioInstruction Statement
highlight default link pioKeyword     Keyword
highlight default link pioModifier    Type
highlight default link pioRegister    Identifier
highlight default link pioCondition   Conditional
highlight default link pioLabel       Label
highlight default link pioDelimiter   Delimiter
highlight default link pioDelay       Special
highlight default link pioOperator    Operator

let b:current_syntax = "pio"

let &cpo = s:cpo_save
unlet s:cpo_save
