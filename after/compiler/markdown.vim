if exists("current_compiler") 
finish 
endif

let current_compiler = "markdown"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let @r='-s % -o %:p:r.pdf'

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=pandoc

CompilerSet efm=%E%m,
CompilerSet efm+=%C%m,
CompilerSet efm+=%C%m,%Z
